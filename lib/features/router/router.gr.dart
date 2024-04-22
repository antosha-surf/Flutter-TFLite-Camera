// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'router.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    CameraViewRoute.name: (routeData) {
      final args = routeData.argsAs<CameraViewRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: CameraViewScreen(
          key: args.key,
          cameraResolutionPreset: args.cameraResolutionPreset,
        ),
      );
    },
    HomeRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const HomeScreen(),
      );
    },
    InferenceImageRoute.name: (routeData) {
      final args = routeData.argsAs<InferenceImageRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: InferenceImageScreen(
          key: args.key,
          data: args.data,
        ),
      );
    },
    InitialRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const InitialScreen(),
      );
    },
  };
}

/// generated route for
/// [CameraViewScreen]
class CameraViewRoute extends PageRouteInfo<CameraViewRouteArgs> {
  CameraViewRoute({
    Key? key,
    required ResolutionPreset cameraResolutionPreset,
    List<PageRouteInfo>? children,
  }) : super(
          CameraViewRoute.name,
          args: CameraViewRouteArgs(
            key: key,
            cameraResolutionPreset: cameraResolutionPreset,
          ),
          initialChildren: children,
        );

  static const String name = 'CameraViewRoute';

  static const PageInfo<CameraViewRouteArgs> page =
      PageInfo<CameraViewRouteArgs>(name);
}

class CameraViewRouteArgs {
  const CameraViewRouteArgs({
    this.key,
    required this.cameraResolutionPreset,
  });

  final Key? key;

  final ResolutionPreset cameraResolutionPreset;

  @override
  String toString() {
    return 'CameraViewRouteArgs{key: $key, cameraResolutionPreset: $cameraResolutionPreset}';
  }
}

/// generated route for
/// [HomeScreen]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [InferenceImageScreen]
class InferenceImageRoute extends PageRouteInfo<InferenceImageRouteArgs> {
  InferenceImageRoute({
    Key? key,
    required InferenceImageViewImageData data,
    List<PageRouteInfo>? children,
  }) : super(
          InferenceImageRoute.name,
          args: InferenceImageRouteArgs(
            key: key,
            data: data,
          ),
          initialChildren: children,
        );

  static const String name = 'InferenceImageRoute';

  static const PageInfo<InferenceImageRouteArgs> page =
      PageInfo<InferenceImageRouteArgs>(name);
}

class InferenceImageRouteArgs {
  const InferenceImageRouteArgs({
    this.key,
    required this.data,
  });

  final Key? key;

  final InferenceImageViewImageData data;

  @override
  String toString() {
    return 'InferenceImageRouteArgs{key: $key, data: $data}';
  }
}

/// generated route for
/// [InitialScreen]
class InitialRoute extends PageRouteInfo<void> {
  const InitialRoute({List<PageRouteInfo>? children})
      : super(
          InitialRoute.name,
          initialChildren: children,
        );

  static const String name = 'InitialRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}
