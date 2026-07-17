class FetchProfileResponseModel {
  final User user;

  FetchProfileResponseModel({required this.user});

  factory FetchProfileResponseModel.fromJson(Map<String, dynamic> json) {
    return FetchProfileResponseModel(
      user: User.fromJson(json['user']),
    );
  }
}

class User {
  final String id;
  final String name;
  final String phone;
  final String? city;

  User({
    required this.id,
    required this.name,
    required this.phone,
    this.city,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      city: json['city'], // may be null or missing
    );
  }
}

