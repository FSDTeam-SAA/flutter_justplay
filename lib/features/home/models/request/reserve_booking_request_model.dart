class ReserveBookingRequestModel {
  final String cityId;
  final String sportId;
  final String pitchId;
  final String date;
  final String timeSlot;
  final int price;
  final String currency;

  ReserveBookingRequestModel({
    required this.cityId,
    required this.sportId,
    required this.pitchId,
    required this.date,
    required this.timeSlot,
    required this.price,
    required this.currency,
  });

  Map<String, dynamic> toJson() => {
    "cityId": cityId,
    "sportId": sportId,
    "pitchId": pitchId,
    "date": date,
    "timeSlot": timeSlot,
    "price": price,
    "currency": currency,
  };
}
