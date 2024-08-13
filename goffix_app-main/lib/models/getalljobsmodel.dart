// To parse this JSON data, do
//
//     final getAllJobModel = getAllJobModelFromJson(jsonString);

import 'dart:convert';

List<GetAllJobModel> getAllJobModelFromJson(String str) => List<GetAllJobModel>.from(json.decode(str).map((x) => GetAllJobModel.fromJson(x)));

String getAllJobModelToJson(List<GetAllJobModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetAllJobModel {
  final int? jobid;
  final String? jobtitle;
  final String? jobdescription;
  final String? jbprofession;
  final String? jblocation;
  final String? jobtype;
  final String? jbmobileNumber;
  final String? priority;
  final User? user;

  GetAllJobModel({
    this.jobid,
    this.jobtitle,
    this.jobdescription,
    this.jbprofession,
    this.jblocation,
    this.jobtype,
    this.jbmobileNumber,
    this.priority,
    this.user,
  });

  factory GetAllJobModel.fromJson(Map<String, dynamic> json) => GetAllJobModel(
    jobid: json["jobid"],
    jobtitle: json["jobtitle"],
    jobdescription: json["jobdescription"],
    jbprofession: json["jbprofession"],
    jblocation: json["jblocation"],
    jobtype: json["jobtype"],
    jbmobileNumber: json["jbmobileNumber"],
    priority: json["priority"],
    user: json["user"] == null ? null : User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "jobid": jobid,
    "jobtitle": jobtitle,
    "jobdescription": jobdescription,
    "jbprofession": jbprofession,
    "jblocation": jblocation,
    "jobtype": jobtype,
    "jbmobileNumber": jbmobileNumber,
    "priority": priority,
    "user": user?.toJson(),
  };
}

class User {
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
  final List<Authority>? authorities;
  final String? phNumber;
  final String? username;
  final bool? accountNonExpired;
  final bool? accountNonLocked;
  final bool? credentialsNonExpired;

  User({
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
    this.authorities,
    this.phNumber,
    this.username,
    this.accountNonExpired,
    this.accountNonLocked,
    this.credentialsNonExpired,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
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
    authorities: json["authorities"] == null ? [] : List<Authority>.from(json["authorities"]!.map((x) => Authority.fromJson(x))),
    phNumber: json["ph_number"],
    username: json["username"],
    accountNonExpired: json["accountNonExpired"],
    accountNonLocked: json["accountNonLocked"],
    credentialsNonExpired: json["credentialsNonExpired"],
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
    "authorities": authorities == null ? [] : List<dynamic>.from(authorities!.map((x) => x.toJson())),
    "ph_number": phNumber,
    "username": username,
    "accountNonExpired": accountNonExpired,
    "accountNonLocked": accountNonLocked,
    "credentialsNonExpired": credentialsNonExpired,
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
