// To parse this JSON data, do
//
//     final userProfilePosts = userProfilePostsFromJson(jsonString);

import 'dart:convert';

List<UserProfilePosts> userProfilePostsFromJson(String str) =>
    List<UserProfilePosts>.from(
        json.decode(str).map((x) => UserProfilePosts.fromJson(x)));

String userProfilePostsToJson(List<UserProfilePosts> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserProfilePosts {
  UserProfilePosts({
    this.pId,
    this.pDt,
    this.pUid,
    this.pTit,
    this.pJd,
    this.pPriority,
    this.catName,
    this.locName,
    this.uNm,
    this.uImg,
    this.uPhn,
    this.issaved,
  });

  String? pId;
  DateTime? pDt;
  String? pUid;
  String? pTit;
  String? pJd;
  String? pPriority;
  String? catName;
  String? locName;
  String? uNm;
  String? uImg;
  String? uPhn;
  String? issaved;

  factory UserProfilePosts.fromJson(Map<String, dynamic> json) =>
      UserProfilePosts(
        pId: json["p_id"],
        pDt: DateTime.parse(json["p_dt"]),
        pUid: json["p_uid"],
        pTit: json["p_tit"],
        pJd: json["p_jd"],
        pPriority: json["p_priority"],
        catName: json["cat_name"],
        locName: json["loc_name"],
        uNm: json["u_nm"],
        uImg: json["u_img"],
        uPhn: json["u_phn"],
        issaved: json["issaved"],
      );

  Map<String, dynamic> toJson() => {
        "p_id": pId,
        "p_dt": pDt?.toIso8601String(),
        "p_uid": pUid,
        "p_tit": pTit,
        "p_jd": pJd,
        "p_priority": pPriority,
        "cat_name": catName,
        "loc_name": locName,
        "u_nm": uNm,
        "u_img": uImg,
        "u_phn": uPhn,
        "issaved": issaved,
      };
}
