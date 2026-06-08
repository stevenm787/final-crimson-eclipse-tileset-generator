/// Represents a location in the Crimson Eclipse world that can have
/// tilesets generated for it.
class Location {
  final String id;
  final String name;
  final String category;
  final String? culturalInspiration;
  final String? element;
  final String? sin;
  final String? chakra;
  final String? theme;
  final String? visualMotifs;

  const Location({
    required this.id,
    required this.name,
    required this.category,
    this.culturalInspiration,
    this.element,
    this.sin,
    this.chakra,
    this.theme,
    this.visualMotifs,
  });

  @override
  String toString() => 'Location($id: $name)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Location && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
