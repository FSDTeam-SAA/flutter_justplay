class RegisterResponseModel {
  final String id;
  final String name;
  final String phone;
  // final String role;
  // final bool enableNotifications;
  // final bool dnd;
  // final String currentPlan;
  final String accessToken;
  final String refreshToken;
  final DateTime createdAt;
  final DateTime updatedAt;

  RegisterResponseModel({
    required this.id,
    required this.name,
    required this.phone,
    // required this.role,
    // required this.enableNotifications,
    // required this.dnd,
    // required this.currentPlan,
    required this.accessToken,
    required this.refreshToken,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterResponseModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      // role: json['role'] ?? '',
      // enableNotifications: json['enableNotifications'] ?? false,
      // dnd: json['dnd'] ?? false,
      // currentPlan: json['currentPlan'] ?? '',
      accessToken: json['accessToken'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
