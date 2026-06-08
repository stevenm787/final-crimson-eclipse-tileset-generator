import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:crimson_eclipse_tileset_generator/app.dart';
import 'package:crimson_eclipse_tileset_generator/state/app_state.dart';
import 'package:crimson_eclipse_tileset_generator/state/generation_state.dart';
import 'package:crimson_eclipse_tileset_generator/state/settings_state.dart';

void main() {
  testWidgets('App renders without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AppState()),
          ChangeNotifierProvider(create: (_) => GenerationState()),
          ChangeNotifierProvider(create: (_) => SettingsState()),
        ],
        child: const CrimsonEclipseApp(),
      ),
    );

    expect(find.text('Crimson Eclipse\nTileset Generator'), findsOneWidget);
  });
}
