// To parse this JSON data, do
//
//     final locModel = locModelFromJson(jsonString);

import 'dart:convert';

List<LocModel> locModelFromJson(String str) => List<LocModel>.from(json.decode(str).map((x) => LocModel.fromJson(x)));

String locModelToJson(List<LocModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LocModel {
    LocModel({
        this.locId,
        this.locName,
        this.locCityid,
        this.locAstat,
    });

    String? locId;
    String? locName;
    String? locCityid;
    String? locAstat;

    factory LocModel.fromJson(Map<String, dynamic> json) => LocModel(
        locId: json["loc_id"],
        locName: json["loc_name"],
        locCityid: json["loc_cityid"],
        locAstat: json["loc_astat"],
    );

    Map<String, dynamic> toJson() => {
        "loc_id": locId,
        "loc_name": locName,
        "loc_cityid": locCityid,
        "loc_astat": locAstat,
    };
}
