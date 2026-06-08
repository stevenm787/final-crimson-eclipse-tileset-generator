import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import '../provider_base.dart';

/// Image generation provider backed by the Google Gemini / Imagen API.
///
/// Uses the Imagen 3 REST endpoint for text-to-image generation. Falls back
/// to a direct REST call since the `google_generative_ai` Dart package does
/// not yet expose image-generation output natively.
class GoogleGeminiProvider implements ImageGenerationProvider {
  /// Creates a provider that authenticates with the given [apiKey].
  GoogleGeminiProvider({required this.apiKey});

  /// Google AI API key.
  final String apiKey;

  /// Imagen model used for generation.
  static const String _model = 'imagen-3.0-generate-002';

  static const String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models';

  @override
  String get name => 'Google Gemini';

  @override
  String get id => 'googleGemini';

  @override
  Future<bool> checkAvailability() async {
    if (apiKey.isEmpty) return false;
    try {
      final uri = Uri.parse('$_baseUrl/$_model').replace(
        queryParameters: {'key': apiKey},
      );
      final response = await http.get(uri);
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<Uint8List> generateImage({
    required String prompt,
    String? negativePrompt,
    required int width,
    required int height,
    int steps = 30,
    double guidanceScale = 7.5,
    String? loraModel,
  }) async {
    final effectivePrompt = negativePrompt != null
        ? '$prompt. Avoid: $negativePrompt'
        : prompt;

    final uri =
        Uri.parse('$_baseUrl/$_model:predict').replace(
      queryParameters: {'key': apiKey},
    );

    final body = jsonEncode({
      'instances': [
        {'prompt': effectivePrompt},
      ],
      'parameters': {
        'sampleCount': 1,
        'aspectRatio': _closestAspectRatio(width, height),
      },
    });

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode != 200) {
      final errorMessage = _parseError(response);
      throw GoogleGeminiException(
        'Gemini API error (${response.statusCode}): $errorMessage',
        statusCode: response.statusCode,
      );
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final predictions = json['predictions'] as List<dynamic>?;

    if (predictions == null || predictions.isEmpty) {
      throw GoogleGeminiException(
        'No predictions returned from Gemini API.',
        statusCode: response.statusCode,
      );
    }

    final prediction = predictions[0] as Map<String, dynamic>;
    final base64Image = prediction['bytesBase64Encoded'] as String?;

    if (base64Image == null) {
      throw GoogleGeminiException(
        'No image data in Gemini API response.',
        statusCode: response.statusCode,
      );
    }

    return base64Decode(base64Image);
  }

  /// Maps pixel dimensions to the closest Imagen-supported aspect ratio.
  String _closestAspectRatio(int width, int height) {
    final ratio = width / height;
    if (ratio >= 1.7) return '16:9';
    if (ratio >= 1.3) return '4:3';
    if (ratio <= 0.6) return '9:16';
    if (ratio <= 0.8) return '3:4';
    return '1:1';
  }

  String _parseError(http.Response response) {
    try {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final error = json['error'] as Map<String, dynamic>?;
      return error?['message']?.toString() ?? response.body;
    } catch (_) {
      return response.body;
    }
  }

  @override
  Future<void> dispose() async {
    // No persistent resources to release.
  }
}

/// Exception thrown when the Google Gemini API returns an error.
class GoogleGeminiException implements Exception {
  GoogleGeminiException(this.message, {required this.statusCode});

  final String message;
  final int statusCode;

  @override
  String toString() => 'GoogleGeminiException: $message';
}
