// To parse this JSON data, do
//
//     final getCountByProfession = getCountByProfessionFromJson(jsonString);

import 'dart:convert';

List<GetCountByProfession> getCountByProfessionFromJson(String str) => List<GetCountByProfession>.from(json.decode(str).map((x) => GetCountByProfession.fromJson(x)));

String getCountByProfessionToJson(List<GetCountByProfession> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetCountByProfession {
  final String? profession;
  final int? count;

  GetCountByProfession({
    this.profession,
    this.count,
  });

  factory GetCountByProfession.fromJson(Map<String, dynamic> json) => GetCountByProfession(
    profession: json["profession"],
    count: json["count"],
  );

  Map<String, dynamic> toJson() => {
    "profession": profession,
    "count": count,
  };
}
