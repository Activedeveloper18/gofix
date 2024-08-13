import "dart:convert";
import "dart:developer";

import "package:goffix/constants.dart";
import "package:http/http.dart" as http;

import "../models/getbyprofessiontype.dart";
import "../models/getcountbyprofession.dart";


class UserRepo{
  List<GetCountByProfessionModel> getCountByProfessionList = [];
  List<GetByProfessionTypeModel> getByProfessionTypeList = [];

  Future<void> getCountByProfession() async {
    print("-----------------------");
    Uri url = Uri.parse(
        "http://ec2-16-171-139-167.eu-north-1.compute.amazonaws.com:5000/gdial/users/count-by-profession");
    print(url);
    final response = await http.get(url, headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json', // Add this header
      'Authorization': "Bearer $bearerToken"
    });
    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = jsonDecode(response.body);

      getCountByProfessionList =
      List<GetCountByProfessionModel>.from(data.map((e) => GetCountByProfessionModel.fromJson(e)));
    } else {
      // Handle error response here
      print("Failed to load data");
    }
  }
  Future<void> getByProfessionType() async {
    print("-----------------------");
    Uri url = Uri.parse(getAllUserByProfession+"profession=Engineer");
    print(url);
    final response = await http.get(url, headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json', // Add this header
      'Authorization': "Bearer $bearerToken"
    });
    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = jsonDecode(response.body);

      getByProfessionTypeList =
      List<GetByProfessionTypeModel>.from(data.map((e) => GetByProfessionTypeModel.fromJson(e)));
    } else {
      // Handle error response here
      print("Failed to load data");
    }
  }

}