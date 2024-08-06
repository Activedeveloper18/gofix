// To parse this JSON data, do
//
//     final eventTicketPageModel = eventTicketPageModelFromJson(jsonString);

import 'dart:convert';

EventTicketPageModel eventTicketPageModelFromJson(String str) =>
    EventTicketPageModel.fromJson(json.decode(str));

String eventTicketPageModelToJson(EventTicketPageModel data) =>
    json.encode(data.toJson());

class EventTicketPageModel {
  EventTicketPageModel({
    this.response,
  });

  Response? response;

  factory EventTicketPageModel.fromJson(Map<String, dynamic> json) =>
      EventTicketPageModel(
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

  List<EventTicketItem>? data;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        data: List<EventTicketItem>.from(
            json["data"].map((x) => EventTicketItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class EventTicketItem {
  EventTicketItem({
    this.etId,
    this.etAddsAId,
    this.ticketPrice,
    this.ticketPriceInfo,
    this.ticketCount,
    this.date,
  });

  String? etId;
  String? etAddsAId;
  String? ticketPrice;
  String? ticketPriceInfo;
  String? ticketCount;
  DateTime? date;

  factory EventTicketItem.fromJson(Map<String, dynamic> json) =>
      EventTicketItem(
        etId: json["et_id"],
        etAddsAId: json["et_adds_a_id"],
        ticketPrice: json["ticket_price"],
        ticketPriceInfo: json["ticket_price_info"],
        ticketCount: json["ticket_count"],
        date: DateTime.parse(json["date"]),
      );

  get counter => null;

  get isAdded => null;

  Map<String, dynamic> toJson() => {
        "et_id": etId,
        "et_adds_a_id": etAddsAId,
        "ticket_price": ticketPrice,
        "ticket_price_info": ticketPriceInfo,
        "ticket_count": ticketCount,
        "date": date!.toIso8601String(),
      };
}
