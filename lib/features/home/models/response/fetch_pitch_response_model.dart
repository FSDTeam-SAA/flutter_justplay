class FetchPitchResponseModel {
  final List<Pitch> pitches;

  FetchPitchResponseModel({required this.pitches});

  /// Because API returns a LIST directly
  factory FetchPitchResponseModel.fromJson(List<dynamic> json) {
    return FetchPitchResponseModel(
      pitches: json.map((e) => Pitch.fromJson(e)).toList(),
    );
  }

  List<Map<String, dynamic>> toJson() {
    return pitches.map((pitch) => pitch.toJson()).toList();
  }
}


class PitchOpeningHour {
  final int dayOfWeek;
  final String label;
  final bool enabled;
  final String opensAt;
  final String closesAt;

  PitchOpeningHour({
    required this.dayOfWeek,
    required this.label,
    required this.enabled,
    required this.opensAt,
    required this.closesAt,
  });

  factory PitchOpeningHour.fromJson(Map<String, dynamic> json) {
    return PitchOpeningHour(
      dayOfWeek: json['dayOfWeek'] ?? 0,
      label: json['label'] ?? '',
      enabled: json['enabled'] ?? true,
      opensAt: json['opensAt'] ?? '09:00',
      closesAt: json['closesAt'] ?? '23:00',
    );
  }
}

class Pitch {
  final String id;
  final String name;
  final PitchImage image;
  final String city;   // extracted from city.name
  final String sport;  // extracted from sport.name
  final String location;
  final int price;
  final String currency;
  final String createdAt;
  final String updatedAt;
  final String status; // active | maintenance | inactive
  final String bookingAvailability; // accepting | not_accepting
  final double? lat;
  final double? lng;
  final double? distanceKm;
  final List<PitchOpeningHour> openingHours;
  final List<String> closedDates; // yyyy-MM-dd

  Pitch({
    required this.id,
    required this.name,
    required this.image,
    required this.city,
    required this.sport,
    required this.location,
    required this.price,
    required this.currency,
    required this.createdAt,
    required this.updatedAt,
    this.status = 'active',
    this.bookingAvailability = 'accepting',
    this.lat,
    this.lng,
    this.distanceKm,
    this.openingHours = const [],
    this.closedDates = const [],
  });

  bool get isBookable => status == 'active' && bookingAvailability == 'accepting';

  factory Pitch.fromJson(Map<String, dynamic> json) {
    final coordinates = json['coordinates'] as Map<String, dynamic>?;
    return Pitch(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      image: PitchImage.fromJson(json['image'] ?? {}),
      city: json['city']?['name'] ?? '',
      sport: json['sport']?['name'] ?? '',
      location: json['location'] ?? '',
      price: json['price'] ?? 0,
      currency: json['currency'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      status: json['status'] ?? 'active',
      bookingAvailability: json['bookingAvailability'] ?? 'accepting',
      lat: (coordinates?['lat'] as num?)?.toDouble(),
      lng: (coordinates?['lng'] as num?)?.toDouble(),
      distanceKm: (json['distanceKm'] as num?)?.toDouble(),
      openingHours: (json['openingHours'] as List<dynamic>? ?? [])
          .map((e) => PitchOpeningHour.fromJson(e as Map<String, dynamic>))
          .toList(),
      closedDates: (json['closedDates'] as List<dynamic>? ?? [])
          .map((e) => e.toString().split('T').first)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'image': image.toJson(),
      'city': city,
      'sport': sport,
      'location': location,
      'price': price,
      'currency': currency,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'status': status,
      'bookingAvailability': bookingAvailability,
    };
  }
}


class PitchImage {
  final String url;
  final String publicId;

  PitchImage({
    required this.url,
    required this.publicId,
  });

  factory PitchImage.fromJson(Map<String, dynamic> json) {
    return PitchImage(
      url: json['url'] ?? '',
      publicId: json['public_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'public_id': publicId,
    };
  }
}


