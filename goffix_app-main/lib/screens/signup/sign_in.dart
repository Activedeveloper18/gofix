import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:goffix/constants.dart';
import 'package:goffix/screens/signup/signup.dart';
import 'package:http/http.dart' as http;

import '../custom_widegt/popmessager.dart';
import '../otp/otpScreen.dart';
// import 'package:goffix/screens/add/AddScreen.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class catName {
  String? cat_id;
  String? cat_name;
  // String cat_astat;

  catName({this.cat_id, this.cat_name});

  factory catName.fromJson(Map<String, dynamic> json) {
    return catName(
      cat_id: json["cat_id"] as String,
      cat_name: json["cat_name"] as String,
    );
  }
}

class locName {
  String? loc_id;
  String? loc_name;
  String? loc_astat;
  String? loc_cityid;

  locName({this.loc_id, this.loc_name, this.loc_cityid, this.loc_astat});

  factory locName.fromJson(Map<String, dynamic> json) {
    return locName(
      loc_id: json["loc_id"] as String,
      loc_name: json["loc_name"] as String,
      loc_cityid: json['loc_cityid'] as String,
      loc_astat: json["loc_astat"] as String,
    );
  }
}

class _SignInScreenState extends State<SignInScreen> {
  //validators

  //Values

  var _location = ['Vizag', 'Vijayawada'];
  int? _locTextFeild;
  bool _locValError = false;
  final TextEditingController _mobileController = new TextEditingController();
// Get Proffession test

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
                } else if (route == "UserExists") {
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

//Signup

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return new Scaffold(
      body: SafeArea(
        child: Stack(
            fit: StackFit.expand,
            // height: ,
            children: [
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 20),
                      child: Image.asset(
                        "assets/images/gf.gif",
                        width: 200,
                      ),
                    ),
                    Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                              padding: EdgeInsets.only(left: 10.0, right: 10.0),
                              width: double.infinity,
                              // height: 650,
                              child: Form(
                                child: Column(
                                  children: [
                                    // Name

                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            border: Border.all(
                                                color: Colors.black, width: 1),
                                            color: Colors.white),
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 2),
                                        child: FormBuilderDropdown<String>(
                                          // autovalidate: true,
                                          name: 'Location',
                                          decoration: InputDecoration(
                                            // isDense: true,   // isDense: true,
                                            border: InputBorder.none,
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.white,
                                                    width: 2.0),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.0)),
                                            contentPadding:
                                                EdgeInsets.only(left: 20.0),
                                            focusColor: Colors.green,
                                            fillColor: Colors.white,
                                            hintText: 'Select Location',
                                            // suffix: _timePriorityError
                                            //     ? const Icon(Icons.error)
                                            //     : const Icon(Icons.check),
                                          ),
                                          // initialValue: 'Male',
                                          // allowClear: true,
                                          // hint: Text('Select Gender'),
                                          // validator: FormBuilderValidators.compose(
                                          //     [FormBuilderValidators.required(context)]),
                                          items: _location
                                              .map((location) =>
                                                  DropdownMenuItem(
                                                    value: location,
                                                    child: Text(location),
                                                  ))
                                              .toList(),
                                          onChanged: (val) {
                                            setState(() {
                                              _locValError = false;
                                            });
                                            print(val);
                                            if (val == "Vizag") {
                                              setState(() {
                                                _locTextFeild = 0;
                                              });
                                            } else if (val == "Vijayawada") {
                                              setState(() {
                                                _locTextFeild = 1;
                                              });
                                            }
                                            print(_locTextFeild);
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      child: TextField(
                                        // maxLength: 10,
                                        keyboardType: TextInputType.number,
                                        controller: _mobileController,

                                        decoration: InputDecoration(
                                            prefixIcon: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text('+91'),
                                                  Icon(Icons
                                                      .keyboard_arrow_down_rounded),
                                                ],
                                              ),
                                            ),
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.grey.shade300,
                                                    width: 3.0),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.0)),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.grey.shade300,
                                                    width: 1.0),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.0)),
                                            contentPadding: EdgeInsets.fromLTRB(
                                                20.0, 15.0, 20.0, 10.0),
                                            hintText: "Mobile No",
                                            focusColor: Colors.grey,
                                            fillColor: Colors.white),
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
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      mainBlue)),
                                          // shape: RoundedRectangleBorder(
                                          //   borderRadius: BorderRadius.circular(25.0),
                                          // ),
                                          // elevation: 10,
                                          // textColor: Colors.white,
                                          onPressed: () {
                                            if(_mobileController.text.length==10){
                                            otpGenarate(_mobileController.text);}
                                            else{
                                              popMessage(context, "Please enter a valid mobile number");
                                            }
                                            // Navigator.push(
                                            //     context,
                                            //     MaterialPageRoute(
                                            //         builder: (context) =>
                                            //             SignupScreen()));
                                          },
                                          /*{
                                            _checkUsr(_mobileController.text)
                                          },*/

                                          child: Text(
                                            "Continue",
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(top: 20),
                                      child: Image.asset(
                                        "assets/images/sign.jpg",
                                        width: double.infinity,
                                      ),
                                    ),
                                    // Password

                                    // Gender

                                    // Proffession

                                    // Signup Button
                                  ],
                                ),
                              )),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ]),
      ),
    );
  }

  Future<dynamic> otpGenarate(String phn) async {
    //Check mobile
    var requestBody = {};
    var jsonRequest = json.encode(requestBody);
    print(jsonRequest);
    Uri url = Uri.parse(otpUrl + "phnumber=${phn}");
    print(url);
    var response = await http.get(url, headers: {
      'Accept': 'application/json',
    });
    String jsonResponse = "";
    print("Status code");
    print(response.statusCode);
    if (response.statusCode == 200) {
      jsonResponse = response.body;
      String otp = jsonResponse.substring(5);
      print("body ${jsonResponse.substring(5)}");
      print("body$otp");
      // Navigator.of(context).push(
      //   MaterialPageRoute(builder: (_) => SignupScreen()),
      // );
      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (_) => OtpScreenMobile(
                  uid: '',
                  otp: otp,
                  phn: phn,
                  oTyp: "1",
                  screen: "signup",
                )),
      );

      print(jsonResponse);
    } else if (response.statusCode == 202) {
      print("Status code 202");
    } else {
      print("User not Created");
      _showMyDialog("Error", "Mobile no. Already Exists", "UserExists");
    }
  }
}
