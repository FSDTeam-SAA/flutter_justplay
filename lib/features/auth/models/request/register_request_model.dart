class RegisterRequestModel {
  final String name;
  final String phone;

  RegisterRequestModel({
    required this.name,
    required this.phone,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "phone": phone,
    };
  }
}
