// To parse this JSON data, do
//
//     final bookingServiceModel = bookingServiceModelFromJson(jsonString);

import 'dart:convert';

BookingServiceModel bookingServiceModelFromJson(String str) => BookingServiceModel.fromJson(json.decode(str));

String bookingServiceModelToJson(BookingServiceModel data) => json.encode(data.toJson());

class BookingServiceModel {
  final String? servicetype;
  final String? date;
  final String? month;

  BookingServiceModel({
    this.servicetype,
    this.date,
    this.month,
  });

  factory BookingServiceModel.fromJson(Map<String, dynamic> json) => BookingServiceModel(
    servicetype: json["servicetype"],
    date: json["Date"],
    month: json["Month"],
  );

  Map<String, dynamic> toJson() => {
    "servicetype": servicetype,
    "Date": date,
    "Month": month,
  };
}
