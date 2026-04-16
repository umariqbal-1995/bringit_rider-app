class RiderModel {
  final String id;
  final String name;
  final String phone;
  final bool isAvailable;
  final double? lat;
  final double? lng;
  final String? photoUrl;

  RiderModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.isAvailable,
    this.lat,
    this.lng,
    this.photoUrl,
  });

  factory RiderModel.fromJson(Map<String, dynamic> json) => RiderModel(
        id: json['_id'] ?? json['id'] ?? '',
        name: json['name'] ?? '',
        phone: json['phone'] ?? '',
        isAvailable: json['isAvailable'] ?? false,
        lat: (json['lat'] as num?)?.toDouble(),
        lng: (json['lng'] as num?)?.toDouble(),
        photoUrl: json['photoUrl'],
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'phone': phone,
        'isAvailable': isAvailable,
        'lat': lat,
        'lng': lng,
        'photoUrl': photoUrl,
      };
}
