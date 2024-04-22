package com.example.tflite_camera_plugin.tflite;

import android.app.Activity;
import android.graphics.Bitmap;
import android.media.Image;
import android.media.ImageReader;
import android.os.Handler;
import android.os.HandlerThread;
import android.util.Log;
import android.view.OrientationEventListener;
import android.view.Surface;

import com.example.tflite_camera_plugin.utils.Utils;
import com.google.android.gms.tflite.client.TfLiteInitializationOptions;
import org.tensorflow.lite.support.image.ImageProcessor;
import org.tensorflow.lite.support.image.TensorImage;
import org.tensorflow.lite.support.image.ops.ResizeOp;
import org.tensorflow.lite.support.image.ops.ResizeWithCropOrPadOp;
import org.tensorflow.lite.support.image.ops.Rot90Op;
import org.tensorflow.lite.task.core.BaseOptions;
import org.tensorflow.lite.gpu.CompatibilityList;
import org.tensorflow.lite.task.gms.vision.TfLiteVision;
import org.tensorflow.lite.task.vision.detector.Detection;
import org.tensorflow.lite.task.vision.detector.ObjectDetector;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;

public class TFLiteSession {
    public static final String TAG = "TFLiteSession";

    private class OnCameraImageAvailableListener implements ImageReader.OnImageAvailableListener {
        @Override
        public void onImageAvailable(ImageReader reader) {
            Image image = reader.acquireLatestImage();
            if (image == null) return;
            if (!addFromCameraStream(image)) {
                image.close();
            }
        }
    }

    private final String modelPath;
    private final Activity activity;
    private TFLitePredictionCaptureController predictionCaptureController;
    private final ImageReader imageReader;
    private ObjectDetector objectDetector;
    private final OrientationEventListener orientationListener;
    private EventChannel.EventSink eventSink;
    private final Handler backgroundHandler;
    private final HandlerThread backgroundHandlerThread;
    private final OnCameraImageAvailableListener onImageAvailableListener =
            new OnCameraImageAvailableListener();
    private int quarterTurns;
    private boolean isStreamingPredictions;
    private volatile boolean isInferring;
    private volatile boolean isDisposed;

    protected TFLiteSession(
            Activity activity,
            String modelPath,
            int resolutionWidth,
            int resolutionHeight,
            int imageFormat
            ) {
        if (!TfLiteVision.isInitialized()) {
            TfLiteVision.initialize(
                activity.getApplicationContext(),
                TfLiteInitializationOptions
                    .builder()
                    .setEnableGpuDelegateSupport(true)
                    .build()
            );
        }
        this.modelPath = modelPath;
        this.activity = activity;

        backgroundHandlerThread = new HandlerThread("TFLiteSessionBackgroundThread");
        backgroundHandlerThread.start();
        backgroundHandler = new Handler(backgroundHandlerThread.getLooper());

        // We set up a 2 image queue because we will still be working on one image when
        // the next ones arrive. Don't waste memory keeping them. Take 1 image and start
        // processing it. Then take subsequent images and drop each of them until we are
        // done processing.
        imageReader = ImageReader.newInstance(
            resolutionWidth,
            resolutionHeight,
            imageFormat,
            2
        );

        orientationListener = new OrientationEventListener(activity) {
            @Override
            public void onOrientationChanged(int orientation) {
                final int quarterTurns = Math.round(((float) orientation) / 90f) % 4;
                if (TFLiteSession.this.quarterTurns != quarterTurns) {
                    TFLiteSession.this.quarterTurns = quarterTurns;
                }
            }
        };
    }

    protected void startPredictionsStream(EventChannel eventChannel, Handler backgroundHandler) {
        eventChannel.setStreamHandler(
            new EventChannel.StreamHandler() {
                @Override
                public void onListen(Object o, EventChannel.EventSink imageStreamSink) {
                    orientationListener.enable();
                    isStreamingPredictions = true;
                    eventSink = imageStreamSink;
                    imageReader.setOnImageAvailableListener(
                            onImageAvailableListener,
                            backgroundHandler
                    );
                }

                @Override
                public void onCancel(Object o) {
                    orientationListener.disable();
                    isStreamingPredictions = false;
                    imageReader.setOnImageAvailableListener(null, backgroundHandler);
                }
            });
    }

    private void onPredictionsReceived(List<Map<String, Object>> json, boolean forImage) {
        if (forImage) {
            // We just trust ourselves here basically to set predictionCaptureController
            // and then pass forImage = true to the addImage function.
            predictionCaptureController.onDetectionsReceived(json);
            return;
        }

        activity.runOnUiThread(() -> {
            if (isDisposed) return;
            eventSink.success(json);
        });
    }

    public void onImageForInferenceCaptured(Image image, MethodChannel.Result result) {
        if (isDisposed) {
            result.error(
                "alreadyDisposed",
                "This session is already disposed and will not accept any more images",
                null
            );
            return;
        }

        Bitmap bitmap = processImageToBitmap(image);
        if (bitmap == null) return;
        final Bitmap rotated = processBitmapToTensorImage(
            bitmap,
            false,
            true
        ).getBitmap();

        predictionCaptureController = new TFLitePredictionCaptureController(
            Utils.bitmapToJPEGBytes(rotated),
            (predictionCapture, reason) -> {
                // Set this field to null to complete our routine.
                predictionCaptureController = null;

                if (reason == TFLitePredictionCaptureController.CompletionReason.OK) {
                    // Everything is OK. Send data to Flutter side.
                    result.success(predictionCapture.toJson());
                    return;
                }

                // Report an error to Flutter side depending on error reason.
                String msg;
                switch (reason) {
                    case UNEXPECTED_NULL: {
                        msg = "Unexpected result received in image inference " +
                                "onComplete callback. Closing this with an error";
                        break;
                    }
                    case TIMEOUT: {
                        msg = "Timeout inferring predictions from a captured image. " +
                                "Closing this with an error.";
                        break;
                    }
                    case DISPOSED: {
                        msg = "TFLite session was disposed before the results of " +
                                "image inference could arrive. Closing this.";
                        break;
                    }
                    default: {
                        msg = ""; // Should be unreachable.
                        break;
                    }
                }

                result.error(
                    "predictionCaptureControllerError",
                    msg,
                    null
                );
            }
        );

        if (isDisposed()) return;

        backgroundHandler.post(() -> {
            addBitmapInternal(rotated, true, true);
        });
    }

    public boolean addFromCameraStream(Image image) {
        if (isDisposed || isInferring) return false;
        isInferring = true;
        backgroundHandler.post(() -> {
            Bitmap bitmap = processImageToBitmap(image);
            image.close(); // Close this image immediately once we are done with it.
            if (!isDisposed() && bitmap != null) {
                addBitmapInternal(bitmap, false, false);
            }
            isInferring = false;
        });
        return true;
    }

    private void addBitmapInternal(Bitmap bitmap, boolean forImage, boolean isBitmapRotated) {
        if (isDisposed) return;

        if (objectDetector == null) {
            // We need to ensure that we *create* and *use* these objects *with the same thread*.
            // This is a stipulation of TFLite, not ours.
            // This means, we cannot create TFLite Objects in a constructor, as it runs with the
            // main app thread, not background thread (where we will do actual inference).
            initTFLiteObjects();
        }

        List<Detection> detections = objectDetector.detect(
                processBitmapToTensorImage(bitmap, true, !isBitmapRotated)
        );

        // Async gap here.

        if (isDisposed) return;

        onPredictionsReceived(detections.stream().map((el) -> {
            return (Map<String, Object>) (new HashMap<String, Object>() {{
                put("categoryIndex", el.getCategories().get(0).getIndex());
                put("categoryScore", el.getCategories().get(0).getScore());
                put("left", el.getBoundingBox().left / 384);
                put("top", el.getBoundingBox().top / 384);
                put("right", el.getBoundingBox().right / 384);
                put("bottom", el.getBoundingBox().bottom / 384);
            }});
        }).collect(Collectors.toList()), forImage);
    }

    private TensorImage processBitmapToTensorImage(
        Bitmap bitmap,
        boolean doResize,
        boolean doRotate
    ) {
        final ImageProcessor.Builder builder = new ImageProcessor.Builder();

        if (doResize) {
            final int maxDim = Math.max(bitmap.getWidth(), bitmap.getHeight());
            builder
                .add(new ResizeWithCropOrPadOp(maxDim, maxDim))
                .add(
                    new ResizeOp(
                        384,
                        384,
                        ResizeOp.ResizeMethod.NEAREST_NEIGHBOR
                    )
                );
        }

        if (doRotate) {
            builder.add(new Rot90Op(-1 - quarterTurns));
        }

        return builder
                .build()
                .process(TensorImage.fromBitmap(bitmap));
    }

    private void initTFLiteObjects() {
        ObjectDetector.ObjectDetectorOptions.Builder optionsBuilder =
                ObjectDetector.ObjectDetectorOptions.builder()
                        .setScoreThreshold(.1f)
                        .setMaxResults(25);
        BaseOptions.Builder baseOptionsBuilder = BaseOptions.builder();
        baseOptionsBuilder.setNumThreads(4);
        try (CompatibilityList cl = new CompatibilityList()) {
            if (cl.isDelegateSupportedOnThisDevice()) {
                baseOptionsBuilder.useGpu();
            } else {
                baseOptionsBuilder.useNnapi();
            }
        }
        optionsBuilder.setBaseOptions(baseOptionsBuilder.build());

        try {
            objectDetector = ObjectDetector.createFromFileAndOptions(
                    activity.getApplicationContext(),
                    modelPath,
                    optionsBuilder.build()
            );
        } catch (IOException e) {
            Log.e(TAG, "COULD NOT CREATE OBJECT DETECTOR FROM FILE " + modelPath);
        }
    }

    private Bitmap processImageToBitmap(Image image) {
        try {
            return Utils.yuv420ToBitmap(image);
        } catch (Exception e) {
            Log.e(TAG, "Error in processImage");
            Log.e(TAG, e.getMessage());
            Log.e(TAG, e.getStackTrace().toString());

            if (isDisposed) {
                Log.e(TAG, "This might be expected behaviour due " +
                        "to uncritical thread collision. TFLiteSession is disposed but stale " +
                        "images are still trying to be processed in another background thread");
            }
        }

        return null;
    }

    public Surface getImageReaderSurface() {
        return imageReader.getSurface();
    }

    public boolean isStreamingPredictions() {
        return isStreamingPredictions;
    }

    public synchronized boolean isDisposed() {
        return isDisposed;
    }

    public void dispose() {
        synchronized (this) {
            if (isDisposed) return;
            isDisposed = true;
            if (predictionCaptureController != null) {
                predictionCaptureController.dispose();
                predictionCaptureController = null;
            }
            imageReader.setOnImageAvailableListener(null, null);
            imageReader.close();
            orientationListener.disable();
            backgroundHandler.removeCallbacksAndMessages(null);
            backgroundHandlerThread.quit();
            try {
                backgroundHandlerThread.join();
            } catch (InterruptedException e) { /* Do nothing. */}
            if (objectDetector != null) {
                objectDetector.close();
            }
        }
    }
}
