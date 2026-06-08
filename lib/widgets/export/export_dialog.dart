import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';

import '../../services/export_service.dart';
import '../../state/app_state.dart';
import '../../state/generation_state.dart';

/// A dialog for exporting the currently generated tileset to disk.
class ExportDialog extends StatefulWidget {
  const ExportDialog({super.key});

  /// Shows the export dialog. Returns `true` if export was successful.
  static Future<bool?> show(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (_) => const ExportDialog(),
    );
  }

  @override
  State<ExportDialog> createState() => _ExportDialogState();
}

class _ExportDialogState extends State<ExportDialog> {
  String? _outputDirectory;
  bool _includeMetadata = true;
  bool _isExporting = false;
  String? _resultMessage;
  bool _exportSuccess = false;

  String get _filenamePreview {
    final appState = context.read<AppState>();
    final location = appState.selectedLocation;
    final tilesetType = appState.selectedTilesetType;
    final locationSlug =
        (location?.name ?? 'untitled').replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_').toLowerCase();
    final typeSlug = tilesetType.id.name;
    return '${locationSlug}_$typeSlug.png';
  }

  Future<void> _pickDirectory() async {
    final result = await FilePicker.platform.getDirectoryPath(
      dialogTitle: 'Select Output Directory',
    );
    if (result != null) {
      setState(() {
        _outputDirectory = result;
      });
    }
  }

  Future<void> _export() async {
    final generationState = context.read<GenerationState>();
    final result = generationState.currentResult;

    if (result == null || _outputDirectory == null) return;

    setState(() {
      _isExporting = true;
      _resultMessage = null;
    });

    try {
      final appState = context.read<AppState>();
      final exportService = ExportService();
      final path = await exportService.exportTileset(
        imageBytes: result.imageBytes,
        location: appState.selectedLocation!,
        tilesetType: appState.selectedTilesetType,
        tileSize: appState.selectedTileSize,
        outputDirectory: _outputDirectory!,
      );

      setState(() {
        _isExporting = false;
        _exportSuccess = true;
        _resultMessage = 'Exported to $path';
      });
    } catch (e) {
      setState(() {
        _isExporting = false;
        _exportSuccess = false;
        _resultMessage = 'Export failed: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final generationState = context.watch<GenerationState>();
    final hasResult = generationState.currentResult != null;

    return AlertDialog(
      title: const Text('Export Tileset'),
      content: SizedBox(
        width: 450,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!hasResult) ...[
              Text(
                'No tileset has been generated yet. Generate a tileset before exporting.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFFCF6679),
                ),
              ),
            ] else ...[
              // Output directory
              Text(
                'Output Directory',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFF8B0000).withAlpha(120),
                        ),
                      ),
                      child: Text(
                        _outputDirectory ?? 'No directory selected',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: _outputDirectory != null
                              ? theme.textTheme.bodyMedium?.color
                              : const Color(0xFF606060),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _pickDirectory,
                    icon: const Icon(Icons.folder_open),
                    tooltip: 'Browse...',
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Filename preview
              Text(
                'Filename',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _filenamePreview,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: const Color(0xFF00BCD4),
                ),
              ),
              const SizedBox(height: 16),

              // Metadata toggle
              Row(
                children: [
                  Switch(
                    value: _includeMetadata,
                    onChanged: (value) {
                      setState(() => _includeMetadata = value);
                    },
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Include metadata JSON',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),

              // Result message
              if (_resultMessage != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _exportSuccess
                        ? const Color(0xFF4CAF50).withAlpha(30)
                        : const Color(0xFFE94560).withAlpha(30),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _exportSuccess
                          ? const Color(0xFF4CAF50).withAlpha(80)
                          : const Color(0xFFE94560).withAlpha(80),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _exportSuccess ? Icons.check_circle : Icons.error,
                        size: 18,
                        color: _exportSuccess
                            ? const Color(0xFF4CAF50)
                            : const Color(0xFFE94560),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _resultMessage!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: _exportSuccess
                                ? const Color(0xFF4CAF50)
                                : const Color(0xFFE94560),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        if (hasResult)
          ElevatedButton(
            onPressed:
                _outputDirectory == null || _isExporting ? null : _export,
            child: _isExporting
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text('Export'),
          ),
      ],
    );
  }
}
