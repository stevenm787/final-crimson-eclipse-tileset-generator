import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/provider_config.dart';
import '../../state/app_state.dart';

/// A dropdown for selecting the AI image-generation provider.
class ProviderDropdown extends StatelessWidget {
  const ProviderDropdown({super.key});

  /// Human-readable labels for each provider.
  static const Map<ProviderId, String> _providerLabels = {
    ProviderId.huggingFace: 'HuggingFace (SDXL + LoRA)',
    ProviderId.googleGemini: 'Google Gemini',
    ProviderId.comfyUI: 'ComfyUI (Local)',
    ProviderId.automatic1111: 'Automatic1111 (Local)',
    ProviderId.auto: 'Auto',
  };

  /// Subtitle descriptions for each provider.
  static const Map<ProviderId, String> _providerDescriptions = {
    ProviderId.huggingFace: 'Free tier - cloud API',
    ProviderId.googleGemini: 'Free tier - cloud API',
    ProviderId.comfyUI: 'Local node-based workflow',
    ProviderId.automatic1111: 'Local WebUI endpoint',
    ProviderId.auto: 'Best available provider',
  };

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final theme = Theme.of(context);

    final items = ProviderId.values.map((providerId) {
      return DropdownMenuItem<ProviderId>(
        value: providerId,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _providerLabels[providerId] ?? providerId.name,
              style: theme.textTheme.bodyMedium,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              _providerDescriptions[providerId] ?? '',
              style: theme.textTheme.bodySmall?.copyWith(fontSize: 11),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      );
    }).toList();

    return DropdownButtonFormField<ProviderId>(
      initialValue: appState.selectedProvider,
      decoration: const InputDecoration(labelText: 'Provider'),
      isExpanded: true,
      dropdownColor: theme.colorScheme.surface,
      menuMaxHeight: 300,
      items: items,
      onChanged: (provider) {
        if (provider != null) {
          appState.selectedProvider = provider;
        }
      },
    );
  }
}
