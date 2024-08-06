import 'dart:convert';
import 'dart:ui';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:goffix/screens/login/login.dart';
import 'package:goffix/screens/otp/otpScreen.dart';
import 'package:goffix/screens/signup/signup.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:goffix/constants.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
// import 'package:goffix/screens/add/AddScreen.dart';

class ChangePasswordScreen extends StatefulWidget {
  final String? uid;
  final String? otp;
  final String? oTyp;
  @override
  const ChangePasswordScreen({Key? key, this.uid, this.otp, this.oTyp})
      : super(key: key);
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _pwdController = new TextEditingController();
  final TextEditingController _verifyController = new TextEditingController();
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
                  // Navigator.of(context).pushReplacement(
                  //   MaterialPageRoute(
                  //       builder: (BuildContext context) => Layout()),
                  // );
                } else if (route == "password") {
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool?> _changePassword(String pwd, String Vpwd) async {
    if (pwd != Vpwd) {
      _showMyDialog("Error", "Password didn't Matched", "password");
      // Alert(
      //   context: context,
      //   type: AlertType.error,
      //   title: "Password didn't Matched",
      //   buttons: [
      //     DialogButton(
      //       child: Text(
      //         "Retry",
      //         style: TextStyle(color: Colors.white, fontSize: 20),
      //       ),
      //       onPressed: () => Navigator.pop(context),
      //       width: 120,
      //     )
      //   ],
      // ).show();
      // return null;

    } else {
      var requestBody = {
        "service_name": "resetpassword",
        "param": {
          "u_id": widget.uid,
          "u_pwd": pwd,
          "u_cpwd": Vpwd,
          "otp_res": widget.otp,
          "otp_type": widget.oTyp
        }
      };
      print(requestBody);
      var jsonRequest = json.encode(requestBody);
      print(jsonRequest);
      var response = await http.post(baseUrl,
          headers: {'Accept': 'application/json'}, body: jsonRequest);
      var jsonResponse = null;
      if (response.statusCode == 200) {
        jsonResponse = json.decode(response.body);
        if (jsonResponse["response"]["status"] == 200) {
          print(jsonResponse['response']);
          Alert(
            context: context,
            type: AlertType.success,
            title: "Password Changed Successfully",
            buttons: [
              DialogButton(
                child: Text(
                  "Done",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () async {
                  // Navigator.pop(context);

                  // Navigator.pushReplacement(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => LoginOtpScreen()));
                  // Navigator.pop(context);
                  Navigator.of(context, rootNavigator: true).pop();
                  await Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LoginOtpScreen()));
                },
                width: 120,
              )
            ],
          ).show();
        } else if (jsonResponse["response"]["status"] == 108) {
          // _showMyDialog("Error", "Username/Password not found", "login");
          // print("Username/Password not found");
        }
      } else {
        print("Something Went Wrong");
      }
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
                        controller: _pwdController,
                        decoration: InputDecoration(
                            // prefixIcon: Icon(Icons.phone_android),
                            border: InputBorder.none,
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.grey.shade300, width: 32.0),
                                borderRadius: BorderRadius.circular(25.0)),
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 10.0),
                            hintText: "Enter Password",
                            focusColor: Colors.green,
                            fillColor: Colors.grey),
                      ),
                    ),
                  ),
                  Container(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25.0),
                          color: Colors.grey[300]),
                      margin: EdgeInsets.all(8),
                      child: TextField(
                        obscureText: _obscureText,
                        controller: _verifyController,
                        decoration: InputDecoration(
                            // prefixIcon: Icon(Icons.phone_android),
                            border: InputBorder.none,
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.grey.shade300, width: 32.0),
                                borderRadius: BorderRadius.circular(25.0)),
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 10.0),
                            hintText: "Verify Password",
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
                      width: 200,
                      child: ElevatedButton(
                        // shape: RoundedRectangleBorder(
                        //   borderRadius: BorderRadius.circular(25.0),
                        // ),
                        // elevation: 10,
                        // textColor: Colors.white,
                        onPressed: () => {
                          _changePassword(
                              _pwdController.text, _verifyController.text)
                          // _forgotPassword(_mobileController.text)
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
                          children: <Widget>[Text("Change Password")],
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
