import 'dart:convert';

class SignInResponse {
  final int statusCode;
  final String message;
  final String token;
  final String refreshToken;
  final String expirationTime;
  final String email;
  final String role;
  final String phnumber;
  final String usname;
  final int ustype;
  final String profession;
  final String usName;

  SignInResponse({
    required this.statusCode,
    required this.message,
    required this.token,
    required this.refreshToken,
    required this.expirationTime,
    required this.email,
    required this.role,
    required this.phnumber,
    required this.usname,
    required this.ustype,
    required this.profession,
    required this.usName,
  });

  factory SignInResponse.fromJson(Map<String, dynamic> json) {
    return SignInResponse(
      statusCode: json['statusCode'],
      message: json['message'],
      token: json['token'],
      refreshToken: json['refreshToken'],
      expirationTime: json['expirationTime'],
      email: json['email'],
      role: json['role'],
      phnumber: json['phnumber'],
      usname: json['usname'],
      ustype: json['ustype'],
      profession: json['profession'],
      usName: json['us_name'], // Adjust field name if needed
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'message': message,
      'token': token,
      'refreshToken': refreshToken,
      'expirationTime': expirationTime,
      'email': email,
      'role': role,
      'phnumber': phnumber,
      'usname': usname,
      'ustype': ustype,
      'profession': profession,
      'us_name': usName, // Adjust field name if needed
    };
  }
}
