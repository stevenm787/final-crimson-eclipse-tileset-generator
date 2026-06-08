import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

/// Root widget for the Crimson Eclipse Tileset Generator application.
class CrimsonEclipseApp extends StatelessWidget {
  const CrimsonEclipseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crimson Eclipse Tileset Generator',
      theme: AppTheme.darkTheme,
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
