import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'state/app_state.dart';
import 'state/generation_state.dart';
import 'state/settings_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final settingsState = SettingsState();
  await settingsState.loadSettings();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
        ChangeNotifierProvider(create: (_) => GenerationState()),
        ChangeNotifierProvider.value(value: settingsState),
      ],
      child: const CrimsonEclipseApp(),
    ),
  );
}
