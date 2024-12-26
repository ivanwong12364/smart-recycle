class RecyclingPoint {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String type;
  final String? contact;
  final String? openingHours;

  RecyclingPoint({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.type,
    this.contact,
    this.openingHours,
  });
} 