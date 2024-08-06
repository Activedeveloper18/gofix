// To parse this JSON data, do
//
//     final homePageModel = homePageModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

HomePageModel homePageModelFromJson(String str) =>
    HomePageModel.fromJson(json.decode(str));

String homePageModelToJson(HomePageModel data) => json.encode(data.toJson());

class HomePageModel {
  HomePageModel({
     this.response,
  });

  Response? response;

  factory HomePageModel.fromJson(Map<String, dynamic> json) => HomePageModel(
        response: Response.fromJson(json["response"]),
      );

  Map<String, dynamic> toJson() => {
        "response": response!.toJson(),
      };
}

class Response {
  Response({
    this.status,
    this.result,
  });

  int? status;
  Result? result;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        status: json["status"],
        result: Result.fromJson(json["result"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "result": result!.toJson(),
      };
}

class Result {
  Result({
    this.data,
  });

  List<HomeItem>? data;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        data:
            List<HomeItem>.from(json["data"].map((x) => HomeItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class HomeItem {
  HomeItem({
    this.aId,
    this.aDt,
    this.aType,
    this.aImg,
    this.aLink,
    this.aNote,
    this.aTitle,
    this.aDescription,
    this.aPrice,
    this.aStat,
    this.aExDt,
    this.sectionText,
    this.sectionImg,
    this.verticalSqid,
    this.horizontalSqid,
    this.dataId,
    this.atypeId,
    this.atypeName,
    this.atypeRefnum,
    this.atypeHeight,
    this.atypeWidth,
    this.atypeCreated,
  });

  String? aId;
  DateTime? aDt;
  String? aType;
  String? aImg;
  String? aLink;
  String? aNote;
  String? aTitle;
  String? aDescription;
  String? aPrice;
  String? aStat;
  String? aExDt;
  String? sectionText;
  String? sectionImg;
  String? verticalSqid;
  String? horizontalSqid;
  String? dataId;
  String? atypeId;
  String? atypeName;
  String? atypeRefnum;
  String? atypeHeight;
  String? atypeWidth;
  DateTime? atypeCreated;

  factory HomeItem.fromJson(Map<String, dynamic> json) => HomeItem(
        aId: json["a_id"],
        aDt: DateTime.parse(json["a_dt"]),
        aType: json["a_type"],
        aImg: json["a_img"],
        aLink: json["a_link"],
        aNote: json["a_note"],
        aTitle: json["a_title"],
        aDescription: json["a_description"],
        aPrice: json["a_price"],
        aStat: json["a_stat"],
        aExDt: json["a_ex_dt"],
        sectionText: json["section_text"],
        sectionImg: json["section_img"],
        verticalSqid: json["vertical_sqid"],
        horizontalSqid: json["horizontal_sqid"],
        dataId: json["data_id"],
        atypeId: json["atype_id"],
        atypeName: json["atype_name"],
        atypeRefnum: json["atype_refnum"],
        atypeHeight: json["atype_height"],
        atypeWidth: json["atype_width"],
        atypeCreated: DateTime.parse(json["atype_created"]),
      );

  Map<String, dynamic> toJson() => {
        "a_id": aId,
        "a_dt": aDt?.toIso8601String(),
        "a_type": aType,
        "a_img": aImg,
        "a_link": aLink,
        "a_note": aNote,
        "a_title": aTitle,
        "a_description": aDescription,
        "a_price": aPrice,
        "a_stat": aStat,
        "a_ex_dt": aExDt,
        "section_text": sectionText,
        "section_img": sectionImg,
        "vertical_sqid": verticalSqid,
        "horizontal_sqid": horizontalSqid,
        "data_id": dataId,
        "atype_id": atypeId,
        "atype_name": atypeName,
        "atype_refnum": atypeRefnum,
        "atype_height": atypeHeight,
        "atype_width": atypeWidth,
        "atype_created": atypeCreated!.toIso8601String(),
      };
}
