// Model class
class GetCountByProfessionModel {
  final String? profession;
  final int? count;

  GetCountByProfessionModel({
    this.profession,
    this.count,
  });

  factory GetCountByProfessionModel.fromJson(Map<String, dynamic> json) => GetCountByProfessionModel(
    profession: json["profession"],
    count: json["count"],
  );

  Map<String, dynamic> toJson() => {
    "profession": profession,
    "count": count,
  };
}