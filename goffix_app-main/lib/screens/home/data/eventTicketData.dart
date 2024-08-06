import 'dart:convert';

import 'package:http/http.dart' as http;

class EventTicketData {
  static Future getEventTickets(String id) async {
    var headers = {
      'Authorization':
          'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE2NzYwOTQ3NDgsImlzcyI6ImxvY2FsaG9zdCIsImV4cCI6MTY3ODY4Njc0OCwidXNlcklkIjoiMTMwNSJ9.nSdjrANhvyQmsY61Hn0YF8YdxtHbKmotT-OjDluDG6w',
      'Content-Type': 'text/plain'
    };
    var request = http.Request('POST', Uri.parse('http://api.goffix.com/api/'));
    request.body = '''{"service_name":"EventTickets","param":{"u_id":$id}}''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      // print(await response.stream.bytesToString());
      String jsonString = await response.stream.bytesToString();
      return jsonString;
    } else {
      // print(response.reasonPhrase);
      String jsonString = await response.stream.bytesToString();
      return jsonString;
    }
  }
}
