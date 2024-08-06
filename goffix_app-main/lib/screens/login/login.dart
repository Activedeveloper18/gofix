import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:goffix/constants.dart';
import 'package:goffix/screens/ForgotPassword/forgotPassword.dart';
import 'package:goffix/screens/layout/layout.dart';
import 'package:goffix/screens/signup/signup.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../otp/otpScreen.dart';

class LoginOtpScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class User {
  Future<bool> setToken(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('token', value);
  }

  Future<bool> setUID(int value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setInt('uid', value);
  }

  Future<bool> setNoti(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('msg', value);
  }

  Future<int?> getUID() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('uid');
  }

  Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}

class _HomeScreenState extends State<LoginOtpScreen> {
  late bool _isLoading;
  bool _obscureText = true;
  Future<void> _showMyDialog(String res, String msg, String route) async {
    // var context;
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(res),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(msg),
                // Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                if (route == "home") {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (BuildContext context) => Layout()),
                  );
                } else if (route == "login") {
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool> logIn(String mobile, String password) async {
    var requestBody = {
      "service_name": "login",
      "param": {"u_phn": mobile, "u_pwd": password}
    };
    var jsonRequest = json.encode(requestBody);
    print(jsonRequest);
    var response = await http.post(baseUrl,
        headers: {'Accept': 'application/json'}, body: jsonRequest);
    var jsonResponse = null;
    print("king ${response.body}");
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);

      if (jsonResponse["response"]["status"] == 200) {
        // _showMyDialog("Success", "User Login Success", "home");
        print("Logged in");
        String token = jsonResponse['response']['result']['token'].toString();
        User().setToken(token);
        String uid = jsonResponse['response']['result']['u_id'].toString();
        int u_id = int.parse(uid);
        User().setUID(u_id);
        // Navigator.of(context).pop();
        // Navigator.of(context).pushReplacement(
        //     new MaterialPageRoute(builder: (context) => Layout()));
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => Layout(),
          ),
          (route) => false,
        );
      } else if (jsonResponse["response"]["status"] == 108) {
        _showMyDialog("Error", "Username/Password not found", "login");
        print("Username/Password not found");
      }
    } else {
      print("Something Went Wrong");
    }
    return false;
  }

  final TextEditingController _mobileController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return new Scaffold(
      body: Center(
        heightFactor: size.height * 1,
        widthFactor: size.width * 1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "SIGN IN",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Center(
              child: Container(
                padding: EdgeInsets.only(top: 50),
                child: Image.asset(
                  "assets/images/pro.png",
                  height: 180,
                  width: 150,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    // maxLength: 10,
                    keyboardType: TextInputType.number,
                    controller: _mobileController,

                    decoration: InputDecoration(
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('+91'),
                              Icon(Icons.keyboard_arrow_down_rounded),
                            ],
                          ),
                        ),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.grey.shade300, width: 3.0),
                            borderRadius: BorderRadius.circular(10.0)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.grey.shade300, width: 3.0),
                            borderRadius: BorderRadius.circular(10.0)),
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 10.0),
                        hintText: "Mobile No",
                        focusColor: Colors.grey,
                        fillColor: Colors.grey),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: new TextField(
                    obscureText: _obscureText,
                    controller: _passwordController,
                    decoration: InputDecoration(

                        // suffixIcon: Icon(CupertinoIcons.eye),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.grey.shade300, width: 3.0),
                            borderRadius: BorderRadius.circular(10.0)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.grey.shade300, width: 3.0),
                            borderRadius: BorderRadius.circular(10.0)),
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 10.0),
                        hintText: "Enter One Time Password",
                        focusColor: Colors.green,
                        fillColor: Colors.grey),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(right: 20, top: 10, bottom: 10),
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ForgotPasswordScreen()));
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.arrow_back,
                                color: Colors.grey,
                              ),
                              Text(
                                "Resend OTP",
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontFamily: "Lato",
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 28),
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(mainBlue)),
                      // shape: RoundedRectangleBorder(
                      //   borderRadius: BorderRadius.circular(25.0),
                      // ),
                      // elevation: 10,
                      // textColor: Colors.white,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignupScreen()));
                      },
                      // {
                      //   _checkUsr(_mobileController.text)
                      //  },

                      child: Text(
                        "Continue",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> _signup(String nm, String em, String pwd, String phn) async {
    //Check mobile
    var requestBody = {
      "service_name": "register",
      "param": {
        "u_nm": _mobileController.text,
        "u_phn": phn,
        "u_email": em,
        "u_pwd": pwd,
      }
    };
    var jsonRequest = json.encode(requestBody);
    print(jsonRequest);
    var response = await http.post(baseUrl,
        headers: {
          'Accept': 'application/json',
        },
        body: jsonRequest);
    var jsonResponse = null;

    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if (jsonResponse["response"]["status"] == 200) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OtpScreenMobile(
                    uid: jsonResponse["response"]["result"]['data'],
                    otp: jsonResponse["response"]["result"]['otp'],
                    phn: phn,
                    oTyp: "1",
                    screen: "signup")));

        // Alert(title: "Success",)
        // otp response
//         {
//     "response": {
//         "status": 200,
//         "result": {
//             "otp": "067d40152f03259370a6",
//             "data": "1297"
//         }
//     }
// }
        print("success");
      } else {
        print("Post not posted");
      }
    }
  }

  Future<bool?> _forgotPassword(String? mobile) async {
    var requestBody = {
      "service_name": "forgotpassword",
      "param": {"u_phn": mobile}
    };
    var jsonRequest = json.encode(requestBody);
    print(jsonRequest);
    var response = await http.post(baseUrl,
        headers: {'Accept': 'application/json'}, body: jsonRequest);
    var jsonResponse = null;
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse["response"]["status"] == 200) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OtpScreenMobile(
                      uid: jsonResponse['response']['result']['data'],
                      otp: jsonResponse['response']['result']['otp'],
                      oTyp: "2",
                      phn: mobile,
                      screen: "forgotpassword",
                    )));
        print(jsonResponse['response']);
      } else if (jsonResponse["response"]["status"] == 108) {
        // _showMyDialog("Error", "Username/Password not found", "login");
        // print("Username/Password not found");
      }
    } else {
      print("Something Went Wrong");
    }
  }

  Future<dynamic> _checkUsr(String phn) async {
    //Check mobile
    var requestBody = {
      "service_name": "uniqueMobileNumberValidation",
      "param": {"u_phn": phn}
    };
    var jsonRequest = json.encode(requestBody);
    print(jsonRequest);
    var response = await http.post(baseUrl,
        headers: {
          'Accept': 'application/json',
        },
        body: jsonRequest);
    var jsonResponse = null;

    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);

      print(jsonResponse);
      if (jsonResponse["response"]["status"] == 202) {
        // _signup( phn);
      } else {
        _showMyDialog("Error", "Please Enter Details", "UserExists");
      }
    } else {
      print("User not Created");
      _showMyDialog("Error", "Mobile no. Already Exists", "UserExists");
    }
  }
}
