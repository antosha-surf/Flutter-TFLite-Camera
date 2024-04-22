import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tflite/features/app/domain/domain.dart';
import 'package:tflite/features/home/presentation/screens/home_screen_selection.dart';
import 'package:tflite/features/home/presentation/widgets/locale_select_bottom_sheet.dart';
import 'package:tflite/features/router/router.dart';
import 'package:tflite/l10n/l10n.dart';
import 'package:tflite_camera_plugin/tflite_camera_plugin.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final selection = ValueNotifier<HomeScreenSelection>(
    const HomeScreenSelection(
      resolutionPreset: null,
    ),
  );

  @override
  void dispose() {
    selection.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.commonAppName),
        actions: [
          IconButton(
            onPressed: () async {
              final localesBloc = BlocProvider.of<LocalesBloc>(context);
              final locale = await showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (ctx) {
                  return const LocaleSelectBottomSheet();
                },
              );
              if (locale == null || !mounted) return;
              localesBloc.add(ChangeLocale(locale));
            },
            icon: const Icon(Icons.language),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(context.l10n.cameraViewCameraResolutionPreset),
              ),
              ValueListenableBuilder(
                valueListenable: selection,
                builder: (ctx, value, _) {
                  return _ResolutionPresetPicker(
                    preset: selection.value.resolutionPreset,
                    onPresetChanged: (p) =>
                        selection.value = selection.value.copyWith(
                      resolutionPreset: p,
                    ),
                  );
                },
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (selection.value.resolutionPreset != null) {
                        context.router.push(
                          CameraViewRoute(
                            cameraResolutionPreset:
                                selection.value.resolutionPreset!,
                          ),
                        );
                      }
                    },
                    child: Text(context.l10n.cameraViewStartButtonTitle),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResolutionPresetPicker extends StatelessWidget {
  final ValueSetter<ResolutionPreset?> onPresetChanged;
  final ResolutionPreset? preset;

  const _ResolutionPresetPicker({
    required this.onPresetChanged,
    required this.preset,
  });

  @override
  Widget build(BuildContext context) {
    const values = ResolutionPreset.values;

    Widget presets(List<ResolutionPreset> presets) {
      return Column(
        children: [
          for (final p in presets)
            RadioListTile<ResolutionPreset?>.adaptive(
              value: p,
              groupValue: preset,
              onChanged: onPresetChanged,
              title: Text(
                p.name,
                style: const TextStyle(
                  fontSize: 13,
                ),
              ),
            ),
        ],
      );
    }

    return Row(children: [
      Expanded(child: presets(values.sublist(0, 3))),
      Expanded(child: presets(values.sublist(3, 6))),
    ]);
  }
}
