import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:tflite/features/camera_view/camera_view.dart';
import 'package:tflite/features/home/home.dart';
import 'package:tflite/features/inference_image_view/inference_image_view.dart';
import 'package:tflite/features/initial_screen/initial_screen.dart';
import 'package:tflite_camera_plugin/tflite_camera_plugin.dart';

part 'router.gr.dart';

/// Main point of the application navigation.
@AutoRouterConfig(replaceInRouteName: 'ScreenWidget|Screen|Page,Route')
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: InitialRoute.page, path: '/', initial: true),
        AutoRoute(page: HomeRoute.page, path: '/home'),
        AutoRoute(page: CameraViewRoute.page, path: '/cameraView'),
        AutoRoute(page: InferenceImageRoute.page, path: '/inferredImage'),
      ];

  @override
  RouteType get defaultRouteType => const RouteType.cupertino();

  /// [AppRouter] constructor.
  AppRouter();
}
