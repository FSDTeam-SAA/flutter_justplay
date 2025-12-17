class UpdateProfileResponseModel {
  final String id;
  final String name;
  final String phone;
  final String city;


  UpdateProfileResponseModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.city,
  });

  factory UpdateProfileResponseModel.fromJson(Map<String, dynamic> json) {
    return UpdateProfileResponseModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      city: json['city'] ?? '',
    );
  }
}
