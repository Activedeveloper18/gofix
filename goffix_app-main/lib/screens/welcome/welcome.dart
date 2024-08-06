import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goffix/constants.dart';
import 'package:goffix/screens/layout/layout.dart';
import 'package:goffix/screens/login/login.dart';
import 'package:goffix/screens/onboarding/onbarding.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScrenState createState() => _WelcomeScrenState();
}

class _WelcomeScrenState extends State<WelcomeScreen> {
  // String token;
  Future<dynamic> param() async {
    await Future.delayed(const Duration(seconds: 3));

    String? _token = await User().getToken();
    int? uid = await User().getUID();
    if (_token == null || _token == "" || uid == null || uid == "") {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => OnBoardingPage()));
    } else {
      // String token = await User().getToken();

      // int uid = 25;
      // if (uid == null || uid == "") {
      //   Navigator.pushReplacement(
      //       context, MaterialPageRoute(builder: (context) => LoginOtpScreen()));
      // }

      print(_token);
      var requestBody = {
        "service_name": "checkNewMsgs",
        "param": {
          "u_id": uid,
        }
      };

      var jsonRequest = json.encode(requestBody);
      print(jsonRequest);
      var response = await http.post(baseUrl,
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $_token',
          },
          body: jsonRequest);
      var jsonResponse = null;
      if (response.statusCode == 200) {
        jsonResponse = json.decode(response.body);
        if (jsonResponse["response"]["status"] == 200) {
          print("200");
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Layout()));
        } else if (jsonResponse["error"]["status"] == 302) {
          print("token expired");
          final pref = await SharedPreferences.getInstance();
          await pref.clear();
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => LoginOtpScreen()));
        } else {
          print("Something Went Wrong");
          final pref = await SharedPreferences.getInstance();
          await pref.clear();
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => LoginOtpScreen()));
        }
      } else {
        final pref = await SharedPreferences.getInstance();
        await pref.clear();
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginOtpScreen()));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    this.param();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Image.asset(
        "assets/images/loader.gif",
        height: 450,
      ),
    ));
  }
}
