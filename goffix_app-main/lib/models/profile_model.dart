// To parse this JSON data, do
//
//     final userProfile = userProfileFromJson(jsonString);

import 'dart:convert';

UserProfile userProfileFromJson(String str) =>
    UserProfile.fromJson(json.decode(str));

String userProfileToJson(UserProfile data) => json.encode(data.toJson());

class UserProfile {
  UserProfile({
    this.profile,
    this.userJobsWorksRating,
  });

  Profile? profile;
  UserJobsWorksRating? userJobsWorksRating;

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        profile: Profile.fromJson(json["profile"]),
        userJobsWorksRating:
            UserJobsWorksRating.fromJson(json["user_jobs_works_rating"]),
      );

  Map<String, dynamic> toJson() => {
        "profile": profile!.toJson(),
        "user_jobs_works_rating": userJobsWorksRating!.toJson(),
      };
}

class Profile {
  Profile({
    this.uId,
    this.uNm,
    this.uGender,
    this.uImg,
    this.uPfn,
    this.uDesc,
    this.usTyp,
    this.catName,
    this.uEmail,
    this.uPwd,
  });

  String? uId;
  String? uNm;
  String? uGender;
  String? uImg;
  String? uPfn;
  String? uDesc;
  String? usTyp;
  String? catName;
  String? uEmail;
  String? uPwd;

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        uId: json["u_id"],
        uNm: json["u_nm"],
        uGender: json["u_gender"],
        uImg: json["u_img"],
        uPfn: json["u_pfn"],
        uDesc: json["u_desc"],
        usTyp: json["us_typ"],
        catName: json["cat_name"],
        uEmail: json["u_email"],
        uPwd: json["u_pwd"],
      );

  Map<String, dynamic> toJson() => {
        "u_id": uId,
        "u_nm": uNm,
        "u_gender": uGender,
        "u_img": uImg,
        "u_pfn": uPfn,
        "u_desc": uDesc,
        "us_typ": usTyp,
        "cat_name": catName,
        "u_email": uEmail,
        "u_pwd": uPwd,
      };
}

class UserJobsWorksRating {
  UserJobsWorksRating({
    this.jobs,
    this.works,
    this.rating,
  });

  String? jobs;
  String? works;
  String? rating;

  factory UserJobsWorksRating.fromJson(Map<String, dynamic> json) =>
      UserJobsWorksRating(
        jobs: json["jobs"],
        works: json["works"],
        rating: json["rating"],
      );

  Map<String, dynamic> toJson() => {
        "jobs": jobs,
        "works": works,
        "rating": rating,
      };
}
