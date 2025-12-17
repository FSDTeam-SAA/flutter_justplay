class FetchProfileResponseModel {
  final User user;

  FetchProfileResponseModel({required this.user});

  factory FetchProfileResponseModel.fromJson(Map<String, dynamic> json) {
    return FetchProfileResponseModel(
      user: User.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
    };
  }
}

class User {
  final String id;
  final String name;
  final String phone;
  final String role;
  final String currentPlan;
  final bool enableNotifications;
  final bool dnd;
  final bool verified;
  final String city;
  final String createdAt;
  final String updatedAt;

  User({
    required this.id,
    required this.name,
    required this.phone,
    required this.role,
    required this.currentPlan,
    required this.enableNotifications,
    required this.dnd,
    required this.verified,
    required this.city,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      name: json['name'],
      phone: json['phone'],
      role: json['role'],
      currentPlan: json['currentPlan'],
      enableNotifications: json['enableNotifications'],
      dnd: json['dnd'],
      verified: json['verificationInfo']['verified'],
      city: json['city'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'phone': phone,
      'role': role,
      'currentPlan': currentPlan,
      'enableNotifications': enableNotifications,
      'dnd': dnd,
      'verificationInfo': {
        'verified': verified,
      },
      'city': city,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
