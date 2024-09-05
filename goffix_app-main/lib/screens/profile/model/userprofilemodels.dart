// To parse this JSON data, do
//
//     final userProfileModel = userProfileModelFromJson(jsonString);

import 'dart:convert';

UserProfileModel userProfileModelFromJson(String str) => UserProfileModel.fromJson(json.decode(str));

String userProfileModelToJson(UserProfileModel data) => json.encode(data.toJson());

class UserProfileModel {
  final String? name;
  final String? email;
  final String? mobileNumber;
  final String? typeEmployee;
  final String? employeeId;
  final String? employeeImage;

  UserProfileModel({
    this.name,
    this.email,
    this.mobileNumber,
    this.typeEmployee,
    this.employeeId,
    this.employeeImage,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) => UserProfileModel(
    name: json["name"],
    email: json["email"],
    mobileNumber: json["mobileNumber"],
    typeEmployee: json["typeEmployee"],
    employeeId: json["employeeID"],
    employeeImage: json["employeeImage"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "mobileNumber": mobileNumber,
    "typeEmployee": typeEmployee,
    "employeeID": employeeId,
    "employeeImage": employeeImage,
  };
}
