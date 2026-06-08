import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;

import '../models/location.dart';
import '../models/tileset_type.dart';

/// Exports generated tileset images to disk with proper naming and metadata.
class ExportService {
  ExportService();

  /// Exports a single tileset image to the specified [outputDirectory].
  ///
  /// Creates a subdirectory named after the [location] if it does not exist.
  /// Returns the full path of the written file.
  Future<String> exportTileset({
    required Uint8List imageBytes,
    required Location location,
    required TilesetType tilesetType,
    required int tileSize,
    required String outputDirectory,
  }) async {
    // Build filename: e.g. "crimson_citadel_a2_48.png"
    final filename = '${location.id}_${tilesetType.id.name}_$tileSize.png';

    // Create location subdirectory if needed.
    final locationDir = Directory(p.join(outputDirectory, location.id));
    if (!locationDir.existsSync()) {
      await locationDir.create(recursive: true);
    }

    final filePath = p.join(locationDir.path, filename);
    final file = File(filePath);
    await file.writeAsBytes(imageBytes);

    return filePath;
  }

  /// Exports multiple tilesets in a single batch.
  ///
  /// Creates a timestamped folder inside [outputDirectory], writes all
  /// images, and generates a `metadata.json` file describing the batch.
  /// Returns the list of all written file paths.
  Future<List<String>> batchExport({
    required Map<TilesetType, Uint8List> tilesets,
    required Location location,
    required int tileSize,
    required String outputDirectory,
  }) async {
    // Create timestamped batch folder.
    final timestamp =
        DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final batchDirName = '${location.id}_$timestamp';
    final batchDir = Directory(p.join(outputDirectory, batchDirName));
    await batchDir.create(recursive: true);

    final exportedPaths = <String>[];
    final metadataEntries = <Map<String, dynamic>>[];

    for (final entry in tilesets.entries) {
      final tilesetType = entry.key;
      final imageBytes = entry.value;

      final filename =
          '${location.id}_${tilesetType.id.name}_$tileSize.png';
      final filePath = p.join(batchDir.path, filename);
      final file = File(filePath);
      await file.writeAsBytes(imageBytes);

      exportedPaths.add(filePath);

      final dims = tilesetType.getDimensions(tileSize);
      metadataEntries.add({
        'filename': filename,
        'tilesetType': tilesetType.id.name,
        'tilesetName': tilesetType.name,
        'width': dims.width,
        'height': dims.height,
        'cols': dims.cols,
        'rows': dims.rows,
      });
    }

    // Generate metadata.json.
    final metadata = _buildMetadata(
      location: location,
      tileSize: tileSize,
      entries: metadataEntries,
      timestamp: timestamp,
    );

    final metadataPath = p.join(batchDir.path, 'metadata.json');
    final metadataFile = File(metadataPath);
    const encoder = JsonEncoder.withIndent('  ');
    await metadataFile.writeAsString(encoder.convert(metadata));
    exportedPaths.add(metadataPath);

    return exportedPaths;
  }

  /// Builds a metadata JSON map describing a batch export.
  Map<String, dynamic> _buildMetadata({
    required Location location,
    required int tileSize,
    required List<Map<String, dynamic>> entries,
    required String timestamp,
  }) {
    return {
      'generator': 'Crimson Eclipse Tileset Generator',
      'version': '1.0.0',
      'exportedAt': timestamp,
      'location': {
        'id': location.id,
        'name': location.name,
        'category': location.category,
      },
      'tileSize': tileSize,
      'tilesets': entries,
    };
  }
}
