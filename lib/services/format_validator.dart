import 'dart:typed_data';

import 'package:image/image.dart' as img;

import '../models/tileset_type.dart';

/// Validates and optionally fixes generated tileset images to ensure
/// they conform to RPG Maker MZ dimensional requirements.
class FormatValidator {
  FormatValidator._();

  /// Validates that [imageBytes] matches the expected format for the given
  /// [tilesetType] and [tileSize].
  ///
  /// Returns a list of error strings. An empty list means the image is valid.
  static List<String> validate(
    Uint8List imageBytes,
    TilesetType tilesetType,
    int tileSize,
  ) {
    final errors = <String>[];

    // Check that image can be decoded as PNG.
    final image = img.decodeImage(imageBytes);
    if (image == null) {
      errors.add('Image data could not be decoded. Expected a valid PNG.');
      return errors;
    }

    final dims = tilesetType.getDimensions(tileSize);
    final expectedWidth = dims.width;
    final expectedHeight = dims.height;

    // Check dimensions match expected.
    if (image.width != expectedWidth) {
      errors.add(
        'Width mismatch: got ${image.width}px, expected ${expectedWidth}px.',
      );
    }

    if (image.height != expectedHeight) {
      errors.add(
        'Height mismatch: got ${image.height}px, expected ${expectedHeight}px.',
      );
    }

    // Check width is an even number.
    if (image.width % 2 != 0) {
      errors.add('Image width (${image.width}) is not an even number.');
    }

    return errors;
  }

  /// Attempts to fix common issues with a generated tileset image.
  ///
  /// - Resizes to the correct dimensions if they are wrong.
  /// - Ensures the image uses RGBA colour mode.
  /// - Re-encodes as PNG.
  ///
  /// Returns the corrected PNG bytes, or `null` if the image could not
  /// be decoded at all.
  static Uint8List? autoFix(
    Uint8List imageBytes,
    TilesetType tilesetType,
    int tileSize,
  ) {
    var image = img.decodeImage(imageBytes);
    if (image == null) return null;

    final dims = tilesetType.getDimensions(tileSize);
    final expectedWidth = dims.width;
    final expectedHeight = dims.height;

    // Resize if dimensions do not match.
    if (image.width != expectedWidth || image.height != expectedHeight) {
      image = img.copyResize(
        image,
        width: expectedWidth,
        height: expectedHeight,
        interpolation: img.Interpolation.nearest,
      );
    }

    // Ensure RGBA by converting to a 4-channel image if needed.
    if (image.numChannels < 4) {
      final rgba = img.Image(
        width: image.width,
        height: image.height,
        numChannels: 4,
      );
      img.compositeImage(rgba, image);
      image = rgba;
    }

    // Re-encode as PNG.
    final pngBytes = img.encodePng(image);
    return Uint8List.fromList(pngBytes);
  }
}
