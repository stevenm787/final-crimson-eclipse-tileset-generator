/// Identifies an AI image-generation provider.
enum ProviderId {
  huggingFace,
  comfyUI,
  automatic1111,
  googleGemini,
  auto,
}

/// Operational status of a provider.
enum ProviderStatus {
  green,
  yellow,
  red,
  gray,
}

/// Configuration for a single AI image-generation provider.
class ProviderConfig {
  final ProviderId id;
  final String name;
  final String category;
  final String endpoint;
  final bool available;
  final String usageText;
  final ProviderStatus status;

  const ProviderConfig({
    required this.id,
    required this.name,
    required this.category,
    required this.endpoint,
    required this.available,
    required this.usageText,
    required this.status,
  });

  @override
  String toString() => 'ProviderConfig($name, $status)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is ProviderConfig && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
