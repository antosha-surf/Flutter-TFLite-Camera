import 'dart:math' as math;
import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tflite/common/common.dart';
import 'package:tflite/features/camera_view/camera_view.dart';
import 'package:tflite/features/router/router.dart';
import 'package:tflite/l10n/l10n.dart';
import 'package:tflite_camera_plugin/tflite_camera_plugin.dart';
import 'package:native_device_orientation/native_device_orientation.dart';

@RoutePage()
class CameraViewScreen extends StatefulWidget {
  final ResolutionPreset cameraResolutionPreset;

  const CameraViewScreen({
    super.key,
    required this.cameraResolutionPreset,
  });

  @override
  State<CameraViewScreen> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraViewScreen> {
  final key = GlobalKey();

  final Stream<NativeDeviceOrientation> orientationStream =
      NativeDeviceOrientationCommunicator()
          .onOrientationChanged(useSensor: true);

  late final StreamController<List<DetectedObject>> dataStream;
  late final StreamController<_FPSInfo> fpsStream;

  CameraController? controller;
  int lastTimestamp = 0;

  List<DetectedObject> lastDetections = const [];

  Future<void> initCamera() async {
    final cameras = await availableCameras();

    final cam = cameras.firstWhere((c) {
      return c.lensDirection == CameraLensDirection.back;
    });
    controller = CameraController(
      cam,
      widget.cameraResolutionPreset,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );
    controller!.resolutionPreset;
    await controller!.initialize();
    await Future.wait([
      controller!.setFlashMode(FlashMode.off),
      controller!.setExposureMode(ExposureMode.auto),
      controller!.setFocusMode(FocusMode.auto),
      controller!.lockCaptureOrientation(DeviceOrientation.portraitUp),
      controller!.initializeTFLiteModel(
        'assets/model.tflite',
      ),
    ]);
    await controller!.startPredictionStream((data) {
      if (dataStream.isClosed) return;
      final detections =
          data.map((m) => DetectedObject.fromPluginData(m)).toList();
      lastDetections = detections;
      dataStream.add(detections);
    });

    if (!mounted) return;
    setState(() {});
  }

  void setUpFPSMeasurements() {
    void measureFps() async {
      if (lastTimestamp == 0) {
        lastTimestamp = DateTime.now().millisecondsSinceEpoch;
        return;
      }

      final now = DateTime.now().millisecondsSinceEpoch;
      final latency = now - lastTimestamp;
      final fps = 1000 / latency;
      lastTimestamp = now;
      fpsStream.add(_FPSInfo(latency: latency, fps: fps));
    }

    dataStream.stream.listen((_) {
      measureFps();
    });
  }

  @override
  void initState() {
    dataStream = StreamController.broadcast();
    fpsStream = StreamController.broadcast();
    setUpFPSMeasurements();
    initCamera();
    super.initState();
  }

  @override
  void dispose() {
    dataStream.close();
    fpsStream.close();
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ImageInferenceBloc(),
        ),
      ],
      child: BlocListener<ImageInferenceBloc, ImageInferenceState>(
        listener: (context, state) {
          if (state is Done) {
            context.replaceRoute(
              InferenceImageRoute(
                data: state.result,
              ),
            );
          }
        },
        child: StreamBuilder(
          stream: orientationStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const SizedBox();
            final orientation = snapshot.requireData;

            final int quarterTurns = switch (orientation) {
              NativeDeviceOrientation.landscapeLeft => 1,
              NativeDeviceOrientation.portraitDown => 2,
              NativeDeviceOrientation.landscapeRight => 3,
              _ => 0,
            };

            return Scaffold(
              appBar: AppBar(
                title: const Text('CameraView'),
              ),
              body: SafeArea(
                child: Stack(
                  children: [
                    () {
                      if (controller == null) {
                        return Center(
                          child: Text(
                            context.l10n.cameraViewInitializingModel,
                            textAlign: TextAlign.center,
                          ),
                        );
                      }

                      return CameraPreview(
                        controller!,
                        key: key,
                      );
                    }(),
                    Positioned.fill(
                      child: RotatedBox(
                        quarterTurns: quarterTurns,
                        child: _Overlay(
                          onTakeScreenshot: () => _onTakeScreenshot(
                            context,
                            orientation,
                          ),
                          dataStream: dataStream.stream,
                          fpsStream: fpsStream.stream,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _onTakeScreenshot(
    BuildContext context,
    NativeDeviceOrientation withOrientation,
  ) async {
    final b = BlocProvider.of<ImageInferenceBloc>(context);
    if (b.state.isLoading) return;

    b.add(GetLatestCameraSnapshot(() async {
      await Future.wait([
        controller!.setFlashMode(FlashMode.off),
        controller!.setExposureMode(ExposureMode.locked),
        controller!.setFocusMode(FocusMode.locked),
      ]);

      final res = await controller!.takePictureAndPredict();
      // Give camera enough time to finish running all its post-capture
      // logic and not run into any app-crashing thread collisions
      // due to camera trying to drop its heavy TFLite workload.
      // Mainly the problem is that the camera tries running `unlockAutofocus`
      // after `dispose` and `close` calls, crashing the app.
      //
      // NOTE TO FUTURE PROGRAMMERS:
      // If you are confident enough - you can try and fix the crash (I couldn't).
      // First try removing this delay and see what is going on (also try
      // slower/older devices).
      await Future.delayed(const Duration(milliseconds: 250));
      return res;
    }));
  }
}

class _Overlay extends StatelessWidget {
  final VoidCallback onTakeScreenshot;
  final Stream<List<DetectedObject>> dataStream;
  final Stream<_FPSInfo> fpsStream;

  const _Overlay({
    required this.onTakeScreenshot,
    required this.dataStream,
    required this.fpsStream,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        StreamBuilder(
          stream: dataStream,
          builder: (context, snapshot) {
            final data = snapshot.data;
            if (data == null) return const SizedBox();
            return SizedBox.expand(
              child: LayoutBuilder(builder: (ctx, ctrx) {
                final maxDim = math.max(ctrx.maxWidth, ctrx.maxHeight);
                return Center(
                  child: OverflowBox(
                    maxWidth: maxDim,
                    maxHeight: maxDim,
                    child: SizedBox.square(
                      dimension: maxDim,
                      child: CustomPaint(
                        painter: _PredictionsPainter(
                          data,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            );
          },
        ),
        Align(
          alignment: AlignmentDirectional.topStart,
          child: BlocBuilder<ImageInferenceBloc, ImageInferenceState>(
            builder: (context, state) {
              if (state.isLoading) return const SizedBox();

              return StreamBuilder(
                stream: fpsStream,
                builder: (context, snapshot) {
                  final info = snapshot.data;
                  if (info == null) return const SizedBox();
                  return _FPSCounter(info: info);
                },
              );
            },
          ),
        ),
        PositionedDirectional(
          end: 16,
          bottom: 16,
          child: FloatingActionButton(
            onPressed: onTakeScreenshot,
            child: BlocBuilder<ImageInferenceBloc, ImageInferenceState>(
                builder: (ctx, state) {
              if (state.isLoading) {
                return const Center(
                  child: SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              return const Icon(Icons.camera_alt_outlined);
            }),
          ),
        ),
      ],
    );
  }
}

class _PredictionsPainter extends CustomPainter {
  final List<DetectedObject> detections;

  const _PredictionsPainter(this.detections);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..strokeWidth = _strokeWidth;

    for (final detection in detections) {
      final label = cocoLabels[detection.categoryIndex];
      final score = detection.categoryScore.toStringAsFixed(2);
      paint.color = Colors.white;

      final tlX = (detection.boundingBox.tl.dx) * size.width;
      final tlY = (detection.boundingBox.tl.dy) * size.height;
      final brX = (detection.boundingBox.br.dx) * size.width;
      final brY = (detection.boundingBox.br.dy) * size.height;

      canvas.drawRect(
        Rect.fromLTRB(tlX, tlY, brX, brY),
        paint..style = PaintingStyle.stroke,
      );

      canvas.drawRRect(
        RRect.fromLTRBAndCorners(
          tlX - _strokeWidth / 2,
          tlY - _textPadHeight,
          brX + _strokeWidth / 2,
          tlY,
          topLeft: const Radius.circular(_radius),
          topRight: const Radius.circular(_radius),
          bottomLeft: const Radius.circular(0),
          bottomRight: const Radius.circular(0),
        ),
        paint..style = PaintingStyle.fill,
      );

      drawText('$label ($score)', Offset(tlX, tlY), Offset(brX, brY), canvas);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  void drawText(
    String text,
    Offset tl,
    Offset br,
    Canvas canvas,
  ) {
    assert(tl.dx <= br.dx);
    assert(tl.dy <= br.dy);

    const textStyle = TextStyle(
      color: Colors.black,
      fontSize: _textHeight,
      height: 1.0,
      overflow: TextOverflow.ellipsis,
    );

    final textSpan = TextSpan(
      text: text,
      style: textStyle,
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      maxLines: 1,
    );

    textPainter.layout(
      minWidth: 0,
      maxWidth: br.dx - tl.dx,
    );

    textPainter.paint(canvas, tl.translate(0, -_textHeight));
  }
}

class _FPSCounter extends StatelessWidget {
  final _FPSInfo info;

  const _FPSCounter({
    required this.info,
  });

  @override
  Widget build(BuildContext context) {
    final fpsTitle = context.l10n.cameraViewDetectionFPSTitle;
    final latencyTitle = context.l10n.cameraViewDetectionLatencyTitle;
    final msAbbr = context.l10n.commonMillisecondsAbbr;
    final fpsRounded = info.fps.toStringAsFixed(2);
    final latency = info.latency;

    return Text(
      '$fpsTitle $fpsRounded\n$latencyTitle $latency $msAbbr',
      style: const TextStyle(
        color: Colors.red,
      ),
    );
  }
}

class _FPSInfo {
  /// Latency in ms.
  final int latency;

  /// Frames per second.
  final double fps;

  _FPSInfo({
    required this.latency,
    required this.fps,
  });
}

const double _strokeWidth = 2.0;
const double _radius = 3.0;
const double _textHeight = 10.0;
const double _textPadHeight = 13.0;
