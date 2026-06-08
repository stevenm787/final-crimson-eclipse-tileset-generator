import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../widgets/controls/generate_button.dart';
import '../widgets/controls/location_dropdown.dart';
import '../widgets/controls/provider_dropdown.dart';
import '../widgets/controls/tileset_type_dropdown.dart';
import '../widgets/controls/usage_display.dart';
import '../widgets/export/export_dialog.dart';
import '../widgets/preview/generation_log.dart';
import '../widgets/preview/tileset_preview.dart';
import 'settings_screen.dart';

/// The main application screen with a sidebar for controls and a main panel
/// for the tileset preview and generation log.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const List<String> _sheetTypes = [
    'terrain',
    'walls',
    'decor',
    'special',
  ];

  @override
  Widget build(BuildContext context) {
    return PlatformMenuBar(
      menus: [
        PlatformMenu(
          label: 'File',
          menus: [
            PlatformMenuItem(
              label: 'Export Tileset...',
              onSelected: () => ExportDialog.show(context),
            ),
            const PlatformMenuItemGroup(members: [
              PlatformProvidedMenuItem(
                type: PlatformProvidedMenuItemType.quit,
              ),
            ]),
          ],
        ),
        PlatformMenu(
          label: 'Edit',
          menus: [
            PlatformMenuItem(
              label: 'Settings...',
              onSelected: () => _openSettings(context),
            ),
          ],
        ),
        PlatformMenu(
          label: 'Help',
          menus: [
            PlatformMenuItem(
              label: 'About Crimson Eclipse',
              onSelected: () => _showAbout(context),
            ),
          ],
        ),
      ],
      child: Scaffold(
        body: Row(
          children: [
            // ── Sidebar ────────────────────────────────────────────────
            _buildSidebar(context),
            // ── Divider ────────────────────────────────────────────────
            VerticalDivider(
              width: 1,
              thickness: 1,
              color: const Color(0xFF8B0000).withAlpha(60),
            ),
            // ── Main Panel ─────────────────────────────────────────────
            Expanded(child: _buildMainPanel(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildSidebar(BuildContext context) {
    final appState = context.watch<AppState>();
    final theme = Theme.of(context);

    return SizedBox(
      width: 300,
      child: Container(
        color: const Color(0xFF12122A),
        child: Column(
          children: [
            // App header
            Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 8, 12),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: const Color(0xFF8B0000).withAlpha(60),
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Crimson Eclipse\nTileset Generator',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: const Color(0xFFE94560),
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => _openSettings(context),
                    icon: const Icon(Icons.settings, size: 20),
                    tooltip: 'Settings',
                  ),
                  IconButton(
                    onPressed: () => ExportDialog.show(context),
                    icon: const Icon(Icons.file_download, size: 20),
                    tooltip: 'Export',
                  ),
                ],
              ),
            ),

            // Scrollable controls
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Target Engine & Format
                    _SectionLabel(text: 'Target Engine & Format'),
                    const SizedBox(height: 8),
                    const TilesetTypeDropdown(),
                    const SizedBox(height: 20),

                    // Location Prompt
                    _SectionLabel(text: 'Location Prompt'),
                    const SizedBox(height: 8),
                    const LocationDropdown(),
                    const SizedBox(height: 20),

                    // Sheet Type
                    _SectionLabel(text: 'Sheet Type'),
                    const SizedBox(height: 8),
                    SegmentedButton<String>(
                      segments: _sheetTypes.map((type) {
                        return ButtonSegment<String>(
                          value: type,
                          label: Text(
                            type[0].toUpperCase() + type.substring(1),
                            style: const TextStyle(fontSize: 12),
                          ),
                        );
                      }).toList(),
                      selected: {appState.selectedSheetType},
                      onSelectionChanged: (selection) {
                        appState.selectedSheetType = selection.first;
                      },
                      showSelectedIcon: false,
                      style: ButtonStyle(
                        visualDensity: VisualDensity.compact,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        padding: WidgetStateProperty.all(
                          const EdgeInsets.symmetric(horizontal: 8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Backend
                    _SectionLabel(text: 'Backend'),
                    const SizedBox(height: 8),
                    const ProviderDropdown(),
                    const SizedBox(height: 24),

                    // Generate Button
                    const GenerateButton(),
                    const SizedBox(height: 20),

                    // Usage Display
                    const UsageDisplay(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainPanel(BuildContext context) {
    return const Column(
      children: [
        // Preview area (expanded)
        Expanded(
          child: Padding(
            padding: EdgeInsets.fromLTRB(12, 12, 12, 6),
            child: TilesetPreview(),
          ),
        ),
        // Generation log (fixed height)
        SizedBox(
          height: 150,
          child: Padding(
            padding: EdgeInsets.fromLTRB(12, 6, 12, 12),
            child: GenerationLog(),
          ),
        ),
      ],
    );
  }

  void _openSettings(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const SettingsScreen(),
      ),
    );
  }

  void _showAbout(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Crimson Eclipse Tileset Generator',
      applicationVersion: '1.0.0',
      applicationLegalese:
          'AI-powered pixel art tileset generation for RPG Maker MZ.',
      children: [
        const SizedBox(height: 16),
        const Text(
          'Generate gothic dark-fantasy tilesets for the Crimson Eclipse '
          'universe using AI providers including HuggingFace and Google Gemini.',
        ),
      ],
    );
  }
}

/// Styled section label for the sidebar.
class _SectionLabel extends StatelessWidget {
  final String text;

  const _SectionLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: const Color(0xFFB0B0B0),
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            fontSize: 10,
          ),
    );
  }
}
