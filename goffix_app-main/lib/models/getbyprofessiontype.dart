// To parse this JSON data, do
//
//     final getByProfessionTypeModel = getByProfessionTypeModelFromJson(jsonString);

import 'dart:convert';

List<GetByProfessionTypeModel> getByProfessionTypeModelFromJson(String str) => List<GetByProfessionTypeModel>.from(json.decode(str).map((x) => GetByProfessionTypeModel.fromJson(x)));

String getByProfessionTypeModelToJson(List<GetByProfessionTypeModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetByProfessionTypeModel {
  final int? userid;
  final String? email;
  final dynamic password;
  final String? role;
  final int? gender;
  final String? phnumber;
  final String? usname;
  final dynamic uslocation;
  final String? usaddress;
  final String? profession;
  final String? usstatus;
  final dynamic usdescription;
  final int? ustype;
  final bool? enabled;
  final String? phNumber;
  final bool? accountNonExpired;
  final bool? accountNonLocked;
  final bool? credentialsNonExpired;
  final List<Authority>? authorities;
  final String? username;

  GetByProfessionTypeModel({
    this.userid,
    this.email,
    this.password,
    this.role,
    this.gender,
    this.phnumber,
    this.usname,
    this.uslocation,
    this.usaddress,
    this.profession,
    this.usstatus,
    this.usdescription,
    this.ustype,
    this.enabled,
    this.phNumber,
    this.accountNonExpired,
    this.accountNonLocked,
    this.credentialsNonExpired,
    this.authorities,
    this.username,
  });

  factory GetByProfessionTypeModel.fromJson(Map<String, dynamic> json) => GetByProfessionTypeModel(
    userid: json["userid"],
    email: json["email"],
    password: json["password"],
    role: json["role"],
    gender: json["gender"],
    phnumber: json["phnumber"],
    usname: json["usname"],
    uslocation: json["uslocation"],
    usaddress: json["usaddress"],
    profession: json["profession"],
    usstatus: json["usstatus"],
    usdescription: json["usdescription"],
    ustype: json["ustype"],
    enabled: json["enabled"],
    phNumber: json["ph_number"],
    accountNonExpired: json["accountNonExpired"],
    accountNonLocked: json["accountNonLocked"],
    credentialsNonExpired: json["credentialsNonExpired"],
    authorities: json["authorities"] == null ? [] : List<Authority>.from(json["authorities"]!.map((x) => Authority.fromJson(x))),
    username: json["username"],
  );

  Map<String, dynamic> toJson() => {
    "userid": userid,
    "email": email,
    "password": password,
    "role": role,
    "gender": gender,
    "phnumber": phnumber,
    "usname": usname,
    "uslocation": uslocation,
    "usaddress": usaddress,
    "profession": profession,
    "usstatus": usstatus,
    "usdescription": usdescription,
    "ustype": ustype,
    "enabled": enabled,
    "ph_number": phNumber,
    "accountNonExpired": accountNonExpired,
    "accountNonLocked": accountNonLocked,
    "credentialsNonExpired": credentialsNonExpired,
    "authorities": authorities == null ? [] : List<dynamic>.from(authorities!.map((x) => x.toJson())),
    "username": username,
  };
}

class Authority {
  final String? authority;

  Authority({
    this.authority,
  });

  factory Authority.fromJson(Map<String, dynamic> json) => Authority(
    authority: json["authority"],
  );

  Map<String, dynamic> toJson() => {
    "authority": authority,
  };
}
