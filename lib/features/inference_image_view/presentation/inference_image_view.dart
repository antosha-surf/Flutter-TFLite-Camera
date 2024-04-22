import 'dart:math' as math;

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:photo_view/photo_view.dart';
import 'package:tflite/common/common.dart';
import 'package:tflite/features/inference_image_view/domain/domain.dart';
import 'package:tflite/features/router/router.dart';
import 'package:tflite/l10n/l10n.dart';

@RoutePage()
class InferenceImageScreen extends StatefulWidget {
  final InferenceImageViewImageData data;

  const InferenceImageScreen({
    super.key,
    required this.data,
  });

  @override
  State<InferenceImageScreen> createState() => _InferenceImageScreenState();
}

class _InferenceImageScreenState extends State<InferenceImageScreen> {
  final controller = PhotoViewController();
  late final image = img.decodeJpg(widget.data.image)!;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (s) => _goToHomeScreen(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context).imageInferenceScreenTitle,
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _goToHomeScreen,
          ),
        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: LayoutBuilder(builder: (ctx, ctrx) {
                return PhotoView(
                  imageProvider: Image.memory(
                    widget.data.image,
                  ).image,
                  controller: controller,
                  enablePanAlways: true,
                );
              }),
            ),
            Positioned.fill(
              child: IgnorePointer(
                child: LayoutBuilder(builder: (ctx, ctrx) {
                  return StreamBuilder(
                    stream: controller.outputStateStream,
                    builder: (ctx, snapshot) {
                      if (!snapshot.hasData) return const SizedBox();
                      return CustomPaint(
                        painter: _Painter(
                          objects: _getProductBoundingBoxes(
                            ctrx,
                            snapshot.requireData,
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<DetectedObject> _getProductBoundingBoxes(
    BoxConstraints ctrx,
    PhotoViewControllerValue value,
  ) {
    final position = value.position;

    final imgWidth = value.scale! * image.width;
    final imgHeight = value.scale! * image.height;
    final imgDim = math.max(imgWidth, imgHeight);

    final imgTopLeft = Offset(
      position.dx + (ctrx.maxWidth - imgDim) / 2,
      position.dy + (ctrx.maxHeight - imgDim) / 2,
    );

    return widget.data.detections.map((e) {
      final bb = e.boundingBox;

      final bbtlX = imgTopLeft.dx + bb.tl.dx * imgDim;
      final bbtlY = imgTopLeft.dy + bb.tl.dy * imgDim;
      final bbbrX = imgTopLeft.dx + bb.br.dx * imgDim;
      final bbbrY = imgTopLeft.dy + bb.br.dy * imgDim;

      return DetectedObject(
        categoryIndex: e.categoryIndex,
        categoryScore: e.categoryScore,
        boundingBox: BoundingBox(
          Offset(bbtlX, bbtlY),
          Offset(bbbrX, bbbrY),
        ),
      );
    }).toList();
  }

  void _goToHomeScreen() {
    context.router.replaceAll([const HomeRoute()]);
  }
}

final class _Painter extends CustomPainter {
  final List<DetectedObject> objects;

  const _Painter({
    required this.objects,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 3.0
      ..color = Colors.white
      ..style = PaintingStyle.stroke;

    for (final o in objects) {
      canvas.drawRRect(o.boundingBox.rrect, paint);
      drawText(
        cocoLabels[o.categoryIndex],
        o.boundingBox.tl + Offset(0, -10),
        o.boundingBox.br,
        canvas,
      );
    }
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
      color: Colors.white,
      fontSize: 10.0,
      fontWeight: FontWeight.w500,
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

    textPainter.paint(canvas, tl.translate(0, -5));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

extension on BoundingBox {
  Radius get displayRadius {
    return const Radius.circular(5);
  }

  RRect get rrect {
    return RRect.fromRectAndRadius(rect, displayRadius);
  }
}
