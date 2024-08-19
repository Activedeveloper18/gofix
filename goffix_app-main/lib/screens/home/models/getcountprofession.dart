// To parse this JSON data, do
//
//     final getCountProfession = getCountProfessionFromJson(jsonString);

import 'dart:convert';

List<GetCountProfession> getCountProfessionFromJson(String str) => List<GetCountProfession>.from(json.decode(str).map((x) => GetCountProfession.fromJson(x)));

String getCountProfessionToJson(List<GetCountProfession> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetCountProfession {
  final String? profession;
  final int? count;

  GetCountProfession({
    this.profession,
    this.count,
  });

  factory GetCountProfession.fromJson(Map<String, dynamic> json) => GetCountProfession(
    profession: json["profession"],
    count: json["count"],
  );

  Map<String, dynamic> toJson() => {
    "profession": profession,
    "count": count,
  };
}
