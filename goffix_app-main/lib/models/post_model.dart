// To parse this JSON data, do
//
//     final postModel = postModelFromJson(jsonString);

import 'dart:convert';

List<PostModel> postModelFromJson(String str) =>
    List<PostModel>.from(json.decode(str).map((x) => PostModel.fromJson(x)));

String postModelToJson(List<PostModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PostModel {
  PostModel({
    this.pDt,
    this.pId,
    this.pTit,
    this.pPriority,
    this.pCtyp,
    this.uId,
    this.uNm,
    this.uPhn,
    this.uImg,
    this.uGender,
    this.usTyp,
    this.catName,
    this.locName,
    this.pJd,
    this.reportCount,
    this.issaved,
  });

  DateTime? pDt;
  String? pId;
  String? pTit;
  String? pPriority;
  String? pCtyp;
  String? uId;
  String? uNm;
  String? uPhn;
  String? uImg;
  String? uGender;
  String? usTyp;
  String? catName;
  String? locName;
  String? pJd;
  String? reportCount;
  String? issaved;

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
        pDt: DateTime.parse(json["p_dt"]),
        pId: json["p_id"],
        pTit: json["p_tit"],
        pPriority: json["p_priority"],
        pCtyp: json["p_ctyp"],
        uId: json["u_id"],
        uNm: json["u_nm"],
        uPhn: json["u_phn"],
        uImg: json["u_img"],
        uGender: json["u_gender"],
        usTyp: json["us_typ"],
        catName: json["cat_name"],
        locName: json["loc_name"],
        pJd: json["p_jd"],
        reportCount: json["report_count"],
        issaved: json["issaved"],
      );

  Map<String, dynamic> toJson() => {
        "p_dt": pDt?.toIso8601String(),
        "p_id": pId,
        "p_tit": pTit,
        "p_priority": pPriority,
        "p_ctyp": pCtyp,
        "u_id": uId,
        "u_nm": uNm,
        "u_phn": uPhn,
        "u_img": uImg,
        "u_gender": uGender,
        "us_typ": usTyp,
        "cat_name": catName,
        "loc_name": locName,
        "p_jd": pJd,
        "report_count": reportCount,
        "issaved": issaved,
      };
}
