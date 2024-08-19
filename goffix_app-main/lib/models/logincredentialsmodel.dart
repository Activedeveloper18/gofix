// To parse this JSON data, do
//
//     final loginCredentialsModel = loginCredentialsModelFromJson(jsonString);

import 'dart:convert';

LoginCredentialsModel loginCredentialsModelFromJson(String str) => LoginCredentialsModel.fromJson(json.decode(str));

String loginCredentialsModelToJson(LoginCredentialsModel data) => json.encode(data.toJson());

class LoginCredentialsModel {
  final int? statusCode;
  final String? message;
  final String? token;
  final String? refreshToken;
  final String? expirationTime;
  final String? email;
  final String? role;
  final String? phnumber;
  final String? usname;
  final int? ustype;
  final String? profession;
  final String? usName;

  LoginCredentialsModel({
    this.statusCode,
    this.message,
    this.token,
    this.refreshToken,
    this.expirationTime,
    this.email,
    this.role,
    this.phnumber,
    this.usname,
    this.ustype,
    this.profession,
    this.usName,
  });

  factory LoginCredentialsModel.fromJson(Map<String, dynamic> json) => LoginCredentialsModel(
    statusCode: json["statusCode"],
    message: json["message"],
    token: json["token"],
    refreshToken: json["refreshToken"],
    expirationTime: json["expirationTime"],
    email: json["email"],
    role: json["role"],
    phnumber: json["phnumber"],
    usname: json["usname"],
    ustype: json["ustype"],
    profession: json["profession"],
    usName: json["us_name"],
  );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "message": message,
    "token": token,
    "refreshToken": refreshToken,
    "expirationTime": expirationTime,
    "email": email,
    "role": role,
    "phnumber": phnumber,
    "usname": usname,
    "ustype": ustype,
    "profession": profession,
    "us_name": usName,
  };
}
