class UserModel {
  String createdAt;
  String fullName;
  String email;
  String password;

  UserModel({
    this.createdAt,
    this.fullName,
    this.email,
    this.password,
  });

  UserModel.fromMap(Map<String, dynamic> map){
    createdAt = map['createdAt'];
    fullName = map["fullName"];
    email = map["email"];
    password = map["password"];
  }

  Map<String, dynamic> toMap() {
    return {
      "createdAt": createdAt,
      "fullName": fullName,
      "email": email,
      "password": password,
    };
  }
}