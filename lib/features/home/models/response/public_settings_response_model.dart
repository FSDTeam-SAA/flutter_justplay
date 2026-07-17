class PublicSettingsResponseModel {
  final String appName;
  final String supportEmail;
  final String supportPhone;
  final String defaultCurrency;
  final double platformFeePercent;
  final double cancellationWindowHours;
  final bool lateCancellationAllowed;
  final int reservationHoldMinutes;
  final int bookingReminderMinutes;
  final bool emergencyLocked;
  final String emergencyMessage;

  PublicSettingsResponseModel({
    required this.appName,
    required this.supportEmail,
    required this.supportPhone,
    required this.defaultCurrency,
    required this.platformFeePercent,
    required this.cancellationWindowHours,
    required this.lateCancellationAllowed,
    required this.reservationHoldMinutes,
    required this.bookingReminderMinutes,
    required this.emergencyLocked,
    required this.emergencyMessage,
  });

  factory PublicSettingsResponseModel.fromJson(Map<String, dynamic> json) {
    return PublicSettingsResponseModel(
      appName: json['appName'] ?? 'JustPlay',
      supportEmail: json['supportEmail'] ?? '',
      supportPhone: json['supportPhone'] ?? '',
      defaultCurrency: json['defaultCurrency'] ?? 'IQD',
      platformFeePercent: (json['platformFeePercent'] as num?)?.toDouble() ?? 5,
      cancellationWindowHours:
          (json['cancellationWindowHours'] as num?)?.toDouble() ?? 6,
      lateCancellationAllowed: json['lateCancellationAllowed'] ?? false,
      reservationHoldMinutes: json['reservationHoldMinutes'] ?? 5,
      bookingReminderMinutes: json['bookingReminderMinutes'] ?? 30,
      emergencyLocked: json['emergencyLocked'] ?? false,
      emergencyMessage: json['emergencyMessage'] ?? '',
    );
  }
}
