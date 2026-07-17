class LoginResponseModel {
  final String accessToken;
  final String refreshToken;
  final String role;
  final String id;
  final User user;

  LoginResponseModel({
    required this.accessToken,
    required this.refreshToken,
    required this.role,
    required this.id,
    required this.user,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      role: json['role'],
      id: json['_id'],
      user: User.fromJson(json['user']),
    );
  }
}

class User {
  final String id;
  final String name;
  final String phone;

  User({
    required this.id,
    required this.name,
    required this.phone,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      name: json['name'],
      phone: json['phone'],
    );
  }
}
