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
    this.uId,
    this.pTit,
    this.uNm,
    this.uImg,
  });

  String? uId;
  String? pTit;
  String? uNm;
  String? uImg;

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
        uId: json["u_id"],
        pTit: json["p_tit"],
        uNm: json["u_nm"],
        uImg: json["u_img"],
      );

  Map<String, dynamic> toJson() => {
        "u_id": uId,
        "p_tit": pTit,
        "u_nm": uNm,
        "u_img": uImg,
      };
}
