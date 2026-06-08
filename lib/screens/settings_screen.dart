import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/settings_state.dart';

/// Full-page settings screen for configuring API keys, models, and display
/// preferences.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController _huggingFaceTokenController;
  late TextEditingController _googleApiKeyController;
  late TextEditingController _selectedModelIdController;
  late TextEditingController _selectedLoraIdController;
  late TextEditingController _localSdEndpointController;
  late TextEditingController _outputDirectoryController;

  @override
  void initState() {
    super.initState();
    final settings = context.read<SettingsState>();
    _huggingFaceTokenController =
        TextEditingController(text: settings.huggingFaceApiToken);
    _googleApiKeyController =
        TextEditingController(text: settings.googleApiKey);
    _selectedModelIdController =
        TextEditingController(text: settings.selectedModelId);
    _selectedLoraIdController =
        TextEditingController(text: settings.selectedLoraId);
    _localSdEndpointController =
        TextEditingController(text: settings.localSdEndpoint);
    _outputDirectoryController =
        TextEditingController(text: settings.outputDirectory);
  }

  @override
  void dispose() {
    _huggingFaceTokenController.dispose();
    _googleApiKeyController.dispose();
    _selectedModelIdController.dispose();
    _selectedLoraIdController.dispose();
    _localSdEndpointController.dispose();
    _outputDirectoryController.dispose();
    super.dispose();
  }

  void _save() {
    final settings = context.read<SettingsState>();
    settings.huggingFaceApiToken = _huggingFaceTokenController.text;
    settings.googleApiKey = _googleApiKeyController.text;
    settings.selectedModelId = _selectedModelIdController.text;
    settings.selectedLoraId = _selectedLoraIdController.text;
    settings.localSdEndpoint = _localSdEndpointController.text;
    settings.outputDirectory = _outputDirectoryController.text;
    settings.save();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Settings saved'),
        backgroundColor: Color(0xFF4CAF50),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsState>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          IconButton(
            onPressed: _save,
            icon: const Icon(Icons.save),
            tooltip: 'Save Settings',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── API Keys ─────────────────────────────────────────────
                _SectionHeader(title: 'API Keys'),
                const SizedBox(height: 12),
                TextField(
                  controller: _huggingFaceTokenController,
                  decoration: const InputDecoration(
                    labelText: 'HuggingFace API Token',
                    prefixIcon: Icon(Icons.key),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _googleApiKeyController,
                  decoration: const InputDecoration(
                    labelText: 'Google API Key',
                    prefixIcon: Icon(Icons.key),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 32),

                // ── Model Selection ──────────────────────────────────────
                _SectionHeader(title: 'Model Selection'),
                const SizedBox(height: 12),
                TextField(
                  controller: _selectedModelIdController,
                  decoration: const InputDecoration(
                    labelText: 'Model ID',
                    hintText: 'stabilityai/stable-diffusion-xl-base-1.0',
                    prefixIcon: Icon(Icons.model_training),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _selectedLoraIdController,
                  decoration: const InputDecoration(
                    labelText: 'LoRA Model ID',
                    hintText: 'Optional LoRA identifier',
                    prefixIcon: Icon(Icons.tune),
                  ),
                ),
                const SizedBox(height: 32),

                // ── Local SD ─────────────────────────────────────────────
                _SectionHeader(title: 'Local Stable Diffusion'),
                const SizedBox(height: 12),
                TextField(
                  controller: _localSdEndpointController,
                  decoration: const InputDecoration(
                    labelText: 'Endpoint URL',
                    hintText: 'http://127.0.0.1:7860',
                    prefixIcon: Icon(Icons.link),
                  ),
                ),
                const SizedBox(height: 32),

                // ── Output ───────────────────────────────────────────────
                _SectionHeader(title: 'Output'),
                const SizedBox(height: 12),
                TextField(
                  controller: _outputDirectoryController,
                  decoration: const InputDecoration(
                    labelText: 'Default Output Directory',
                    prefixIcon: Icon(Icons.folder),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<int>(
                  initialValue: settings.defaultTileSize,
                  decoration: const InputDecoration(
                    labelText: 'Default Tile Size',
                    prefixIcon: Icon(Icons.grid_on),
                  ),
                  dropdownColor: theme.colorScheme.surface,
                  items: const [
                    DropdownMenuItem(value: 48, child: Text('48px')),
                    DropdownMenuItem(value: 32, child: Text('32px')),
                    DropdownMenuItem(value: 24, child: Text('24px')),
                    DropdownMenuItem(value: 16, child: Text('16px')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      settings.defaultTileSize = value;
                    }
                  },
                ),
                const SizedBox(height: 32),

                // ── Display ──────────────────────────────────────────────
                _SectionHeader(title: 'Display'),
                const SizedBox(height: 12),
                SwitchListTile(
                  title: Text(
                    'Grid Overlay',
                    style: theme.textTheme.bodyMedium,
                  ),
                  subtitle: Text(
                    'Show tile grid lines on preview',
                    style: theme.textTheme.bodySmall,
                  ),
                  value: settings.gridOverlay,
                  onChanged: (value) {
                    settings.gridOverlay = value;
                  },
                  contentPadding: EdgeInsets.zero,
                ),
                SwitchListTile(
                  title: Text(
                    'Dark Mode',
                    style: theme.textTheme.bodyMedium,
                  ),
                  subtitle: Text(
                    'Use dark gothic theme',
                    style: theme.textTheme.bodySmall,
                  ),
                  value: settings.darkMode,
                  onChanged: (value) {
                    settings.darkMode = value;
                  },
                  contentPadding: EdgeInsets.zero,
                ),
                const SizedBox(height: 32),

                // ── Save ─────────────────────────────────────────────────
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _save,
                    icon: const Icon(Icons.save),
                    label: const Text('SAVE SETTINGS'),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: theme.textTheme.headlineSmall?.copyWith(fontSize: 14),
        ),
        const SizedBox(height: 4),
        Container(
          height: 2,
          width: 40,
          decoration: BoxDecoration(
            color: const Color(0xFFE94560),
            borderRadius: BorderRadius.circular(1),
          ),
        ),
      ],
    );
  }
}
