import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tflite/features/app/app.dart';
import 'package:tflite/features/router/router.dart';
import 'package:tflite/l10n/l10n.dart';

class TFLiteApp extends StatefulWidget {
  const TFLiteApp({super.key});

  @override
  State<TFLiteApp> createState() => _TFLiteAppState();
}

class _TFLiteAppState extends State<TFLiteApp> {
  final router = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LocalesBloc()),
      ],
      child: BlocBuilder<LocalesBloc, Locale?>(
        builder: (context, locale) {
          return MaterialApp.router(
            locale: locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            routerDelegate: router.delegate(/*Fill the params here.*/),
            routeInformationParser: router.defaultRouteParser(),
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
          );
        },
      ),
    );
  }
}
