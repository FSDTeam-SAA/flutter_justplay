class BookingResponse {
  final Booking booking;

  BookingResponse({required this.booking});

  factory BookingResponse.fromJson(Map<String, dynamic> json) {
    return BookingResponse(
      booking: Booking.fromJson(json['booking']),
    );
  }
}

class Booking {
  final String id;
  final String user;
  final String city;
  final String sport;
  final String pitch;
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
    required this.pitch,
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
      id: json['_id'],
      user: json['user'],
      city: json['city'],
      sport: json['sport'],
      pitch: json['pitch'],
      date: DateTime.parse(json['date']),
      timeSlot: json['timeSlot'],
      price: json['price'],
      currency: json['currency'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
