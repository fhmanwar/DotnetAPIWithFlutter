class JWTModel {
  // int userId;
  String userId;
  String name;
  String email;

  JWTModel({this.userId, this.name, this.email});

  factory JWTModel.fromJson(Map<String, dynamic> json) {
    return JWTModel(
      userId: json['Id'],
      name: json['Name'],
      email: json['Email'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['Name'] = this.name;
    data['Email'] = this.email;
    return data;
  }
}
