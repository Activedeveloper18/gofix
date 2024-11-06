// Service model class to represent each sub-category
class Service {
  final int? sc_id;
  final String? sub_category;
  final int? sc_status;

  Service({
    this.sc_id,
    this.sub_category,
    this.sc_status,
  });

  // Factory constructor to create a Service instance from JSON
  factory Service.fromJson(Map<String, dynamic> json) => Service(
        sc_id: json["sc_id"],
        sub_category: json["sub_category"],
        sc_status: json["sc_status"],
      );

  // Convert a Service instance back to JSON
  Map<String, dynamic> toJson() => {
        "sc_id": sc_id,
        "sub_category": sub_category,
        "sc_status": sc_status,
      };
}

// Updated GetCountByProfessionModel class to include a list of services
class GetCountByProfessionModel {
  final String? profession;
  final int? count;
  final int? cat_id;
  final List<Service>? services;

  GetCountByProfessionModel({
    this.profession,
    this.count,
    this.cat_id,
    this.services,
  });

  // Factory constructor to create GetCountByProfessionModel instance from JSON
  factory GetCountByProfessionModel.fromJson(Map<String, dynamic> json) => GetCountByProfessionModel(
        profession: json["profession"],
        count: json["count"],
        cat_id: json["cat_id"],
        services: json["services"] != null
            ? List<Service>.from(json["services"].map((x) => Service.fromJson(x)))
            : null,
      );

  // Convert a GetCountByProfessionModel instance back to JSON
  Map<String, dynamic> toJson() => {
        "profession": profession,
        "count": count,
        "cat_id": cat_id,
        "services": services != null
            ? List<dynamic>.from(services!.map((x) => x.toJson()))
            : null,
      };
}
