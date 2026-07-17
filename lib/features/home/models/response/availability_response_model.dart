class BookedSlot {
  final String timeSlot;
  final String status;
  final DateTime? reservationExpiresAt;

  BookedSlot({
    required this.timeSlot,
    required this.status,
    this.reservationExpiresAt,
  });

  factory BookedSlot.fromJson(Map<String, dynamic> json) {
    return BookedSlot(
      timeSlot: json['timeSlot'] ?? '',
      status: json['status'] ?? '',
      reservationExpiresAt: json['reservationExpiresAt'] != null
          ? DateTime.tryParse(json['reservationExpiresAt'])
          : null,
    );
  }
}

class PitchOpeningHourWindow {
  final int dayOfWeek;
  final bool enabled;
  final String opensAt;
  final String closesAt;

  PitchOpeningHourWindow({
    required this.dayOfWeek,
    required this.enabled,
    required this.opensAt,
    required this.closesAt,
  });

  factory PitchOpeningHourWindow.fromJson(Map<String, dynamic> json) {
    return PitchOpeningHourWindow(
      dayOfWeek: json['dayOfWeek'] ?? 0,
      enabled: json['enabled'] ?? true,
      opensAt: json['opensAt'] ?? '09:00',
      closesAt: json['closesAt'] ?? '23:00',
    );
  }
}

class AvailabilityResponseModel {
  final String pitchStatus;
  final String bookingAvailability;
  final List<String> closedDates;
  final List<PitchOpeningHourWindow> openingHours;
  final List<BookedSlot> bookedSlots;

  AvailabilityResponseModel({
    required this.pitchStatus,
    required this.bookingAvailability,
    required this.closedDates,
    required this.openingHours,
    required this.bookedSlots,
  });

  bool get isPitchBookable =>
      pitchStatus == 'active' && bookingAvailability == 'accepting';

  factory AvailabilityResponseModel.fromJson(Map<String, dynamic> json) {
    return AvailabilityResponseModel(
      pitchStatus: json['pitchStatus'] ?? 'active',
      bookingAvailability: json['bookingAvailability'] ?? 'accepting',
      closedDates: (json['closedDates'] as List<dynamic>? ?? [])
          .map((e) => e.toString().split('T').first)
          .toList(),
      openingHours: (json['openingHours'] as List<dynamic>? ?? [])
          .map((e) => PitchOpeningHourWindow.fromJson(e as Map<String, dynamic>))
          .toList(),
      bookedSlots: (json['bookedSlots'] as List<dynamic>? ?? [])
          .map((e) => BookedSlot.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
