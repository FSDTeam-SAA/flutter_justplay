class GetAllBookingResponseModel {
  final List<Booking> bookings;

  GetAllBookingResponseModel({required this.bookings});

  factory GetAllBookingResponseModel.fromJson(Map<String, dynamic> json) {
    return GetAllBookingResponseModel(
      bookings: (json['bookings'] as List)
          .map((e) => Booking.fromJson(e))
          .toList(),
    );
  }
}

class Booking {
  final String id;
  final String user;
  final City city;
  final Sport sport;
  final Pitch? pitch; // 🔑 nullable
  final DateTime date;
  final String timeSlot;
  final int price;
  final String currency;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Booking({
    required this.id,
    required this.user,
    required this.city,
    required this.sport,
    this.pitch,
    required this.date,
    required this.timeSlot,
    required this.price,
    required this.currency,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['_id'] ?? '',
      user: json['user'] ?? '',
      city: City.fromJson(json['city']),
      sport: Sport.fromJson(json['sport']),
      pitch: json['pitch'] != null ? Pitch.fromJson(json['pitch']) : null,
      date: DateTime.parse(json['date']),
      timeSlot: json['timeSlot'] ?? '',
      price: json['price'] ?? 0,
      currency: json['currency'] ?? '',
      status: json['status'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}


class City {
  final String id;
  final String name;

  City({
    required this.id,
    required this.name,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

class Sport {
  final String id;
  final String name;

  Sport({
    required this.id,
    required this.name,
  });

  factory Sport.fromJson(Map<String, dynamic> json) {
    return Sport(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

class Pitch {
  final String id;
  final String name;
  final String location;

  Pitch({
    required this.id,
    required this.name,
    required this.location,
  });

  factory Pitch.fromJson(Map<String, dynamic> json) {
    return Pitch(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      location: json['location'] ?? '',
    );
  }
}


