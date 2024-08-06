import 'package:http/http.dart' as http;

import '../../login/login.dart';

class HomeData {
  static Future<String> getHomeData() async {
    String? token = await User().getToken();
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'text/plain'
    };
    var request = http.Request('POST', Uri.parse('http://api.goffix.com/api/'));
    request.body = '''{"service_name":"Adds","param":{}}''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      // print(await response.stream.bytesToString());
      String jsonString = await response.stream.bytesToString();
      return jsonString;
    } else {
      print(response.reasonPhrase);
      String jsonString = await response.stream.bytesToString();
      return jsonString;
    }
  }
}
