import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/generation_config.dart';
import '../../services/prompt_builder.dart';
import '../../services/providers/huggingface_provider.dart';
import '../../services/generation_service.dart';
import '../../services/usage_tracker.dart';
import '../../state/app_state.dart';
import '../../state/generation_state.dart';
import '../../state/settings_state.dart';

/// A full-width crimson button that triggers tileset generation.
class GenerateButton extends StatelessWidget {
  const GenerateButton({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final generationState = context.watch<GenerationState>();

    final isDisabled =
        appState.selectedLocation == null || generationState.isGenerating;

    return SizedBox(
      width: double.infinity,
      height: 48,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: isDisabled
              ? null
              : const LinearGradient(
                  colors: [Color(0xFF8B0000), Color(0xFFE94560)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
          color: isDisabled ? const Color(0xFF2A2A3E) : null,
          borderRadius: BorderRadius.circular(8),
        ),
        child: ElevatedButton(
          onPressed: isDisabled ? null : () => _onGenerate(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            disabledBackgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: generationState.isGenerating
              ? const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      'GENERATING...',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                )
              : const Text(
                  'GENERATE TILESET',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    letterSpacing: 1.5,
                  ),
                ),
        ),
      ),
    );
  }

  Future<void> _onGenerate(BuildContext context) async {
    final appState = context.read<AppState>();
    final generationState = context.read<GenerationState>();
    final location = appState.selectedLocation;

    if (location == null) return;

    generationState.startGeneration();

    final prompt = PromptBuilder.buildPrompt(
      location: location,
      tilesetType: appState.selectedTilesetType,
      sheetType: appState.selectedSheetType,
    );

    generationState.addLog('Provider: ${appState.selectedProvider.name}');
    generationState.addLog('Location: ${location.name}');
    generationState.addLog('Tileset: ${appState.selectedTilesetType.name}');
    generationState.addLog('Sheet type: ${appState.selectedSheetType}');
    generationState.addLog('Building prompt...');

    final config = GenerationConfig(
      location: location,
      tilesetType: appState.selectedTilesetType,
      tileSize: appState.selectedTileSize,
      provider: appState.selectedProvider,
      customPrompt: prompt,
    );

    try {
      generationState.addLog('Sending request to provider...');
      generationState.progress = 0.3;

      final settings = context.read<SettingsState>();
      final provider = HuggingFaceProvider(
        apiToken: settings.huggingFaceApiToken,
        modelId: settings.selectedModelId,
      );
      final service = GenerationService(
        providers: [provider],
        usageTracker: UsageTracker(),
      );
      final result = await service.generate(config);

      generationState.completeGeneration(result);
    } catch (e) {
      generationState.failGeneration(e.toString());
    }
  }
}
