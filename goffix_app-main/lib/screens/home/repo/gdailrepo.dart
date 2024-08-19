import 'package:goffix/models/getbyprofessiontype.dart';
import 'package:goffix/models/getcountbyprofession.dart';
import 'package:goffix/screens/home/models/getcountprofession.dart';
import 'package:goffix/screens/login/utils/helpers.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../constants.dart';

class GdailRepo {
  List<GetCountByProfessionModel> getCountProfessionModel =
      <GetCountByProfessionModel>[];

  Future<List<GetCountByProfessionModel>?> getCountProfession() async {
    try {
      print("object");
      final resp =
          await http.get(Uri.parse(getCountProfessionUrl), headers: headers);
      print(resp.statusCode);
      print(resp.body.runtimeType);

      if (resp.statusCode == 200 || resp.statusCode == 201) {
        List<dynamic> jsonData = jsonDecode(resp.body);
        print(jsonData.runtimeType);

        // Convert mapped iterable to a list
        getCountProfessionModel =
            jsonData.map((e) => GetCountByProfessionModel.fromJson(e)).toList();

        return getCountProfessionModel;
      } else {
        // Handle error, maybe return null or an empty list
        return null;
      }
    } catch (e) {
      print(e.toString());
      log(e.toString());
    }
  }
}
