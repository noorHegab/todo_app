class UserModel {
  String email;
  String name;
  String id;
  String phone;
  UserModel({
    required this.email,
    required this.name,
    required this.id,
    required this.phone,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        email: json["email"],
        name: json["name"],
        id: json["id"],
        phone: json["phone"]);
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "name": name, "email": email, "phone": phone};
  }
}
