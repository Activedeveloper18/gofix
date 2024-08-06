import 'dart:convert';
import 'dart:ui';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:goffix/screens/otp/otpScreen.dart';
import 'package:goffix/screens/signup/signup.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:goffix/constants.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
// import 'package:goffix/screens/add/AddScreen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _mobileController = new TextEditingController();
  Future<bool?> _forgotPassword(String mobile) async {
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

  @override
  void initState() {
    super.initState();
    // this._getCat();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return new Scaffold(
      body: Center(
        heightFactor: size.height * 1,
        widthFactor: size.width * 1,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.only(top: 50),
              child: Image.asset(
                "assets/images/main_logo.png",
                height: 180,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              child: Column(
                children: <Widget>[
                  Container(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25.0),
                          color: Colors.grey[300]),
                      margin: EdgeInsets.all(8),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: _mobileController,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.phone_android),
                            border: InputBorder.none,
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.grey.shade300, width: 32.0),
                                borderRadius: BorderRadius.circular(25.0)),
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 10.0),
                            hintText: "Mobile No",
                            focusColor: Colors.green,
                            fillColor: Colors.grey),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 50,
                      width: 150,
                      child: ElevatedButton(
                        // shape: RoundedRectangleBorder(
                        //   borderRadius: BorderRadius.circular(25.0),
                        // ),
                        // elevation: 10,
                        // textColor: Colors.white,
                        onPressed: () => {
                          _forgotPassword(_mobileController.text)
                          // logIn(
                          //     _mobileController.text, _passwordController.text),
                          // Navigator.pushReplacement(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) =>
                          //         // HomeScreen(uid: uid, username: username),
                          //         Layout(),
                          //   ),
                          // ),
                        },
                        // color: mainBlue,
                        // splashColor: mainBlue,
                        // padding: EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          // Replace with a Row for horizontal icon + text
                          children: <Widget>[Text("Send OTP")],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
