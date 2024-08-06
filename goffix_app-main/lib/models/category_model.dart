// To parse this JSON data, do
//
//     final catModel = catModelFromJson(jsonString);

import 'dart:convert';

List<CatModel> catModelFromJson(String str) =>
    List<CatModel>.from(json.decode(str).map((x) => CatModel.fromJson(x)));

String catModelToJson(List<CatModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CatModel {
  CatModel({
    this.catId,
    this.catName,
    this.catAstat,
  });

  String? catId;
  String? catName;
  String? catAstat;

  factory CatModel.fromJson(Map<String, dynamic> json) => CatModel(
        catId: json["cat_id"],
        catName: json["cat_name"],
        catAstat: json["cat_astat"],
      );

  Map<String, dynamic> toJson() => {
        "cat_id": catId,
        "cat_name": catName,
        "cat_astat": catAstat,
      };
}
