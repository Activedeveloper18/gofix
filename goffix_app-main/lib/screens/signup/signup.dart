import 'package:flutter_svg/flutter_svg.dart';
import 'dart:convert';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:goffix/screens/home/homeScreen.dart';
import 'package:goffix/screens/otp/otpScreen.dart';
import 'package:goffix/screens/signup/fixture.dart';
import 'package:goffix/screens/signup/sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:goffix/constants.dart';

import '../custom_widegt/popmessager.dart';
import '../layout/layout.dart';
// import 'package:goffix/screens/add/AddScreen.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
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

class _SignupScreenState extends State<SignupScreen> {
  //validators
  bool _nmValError = false;
  bool _phnValError = false;
  bool _emValError = false;
  bool _pwdValError = false;
  bool _genValError = false;
  bool _locValError = false;
  bool _proValError = false;

  //Values
  int? _genTextFeild;
  var _gender = ['Male', 'Female'];
  var _finder = ['Finder', 'Fixture'];
  int? _catTextFeild;
  int? gendervlue;
  int? usertype_value;
  List? listOfLoc;
  List<catName>? listOfCat;
  List<catName>? filteredCat;
  List<locName>? filteredLoc;

//Controllers
  final TextEditingController _categoryController = new TextEditingController();
  final TextEditingController _mobileController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
  final TextEditingController _nameController = new TextEditingController();
  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _proController = new TextEditingController();
  final TextEditingController _catController = new TextEditingController();
// Get Proffession test
  Future<List<catName>?> _getCat() async {
    var requestBody = {
      "service_name": "getMastersDataOfAddPostForm",
      "param": {}
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
      if (jsonResponse["response"]["status"] == 200) {
        setState(() {
          listOfCat =
              parseCat(jsonResponse['response']['result']['categories']);
          listOfLoc = parseLoc(jsonResponse['response']['result']['locations']);
          // .cast<catName>();
        });
        print("nmnjnnbjnj");
        print(listOfCat);
        print(listOfLoc);

        // await Future.delayed(const Duration(seconds: 2));
      } else if (jsonResponse["response"]["status"] == 108) {
        // _showMyDialog("Error", "Username/Password not found", "login");
        print("Locations not found");
      } else {
        print("Something Went Wrong");
      }
    }
    return null;
    // return null;
  }

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

//Get Proffession and Location

  static List<catName> parseCat(responseBody) {
    return responseBody.map<catName>((json) => catName.fromJson(json)).toList();
  }

  static List<locName> parseLoc(responseBody) {
    return responseBody.map<locName>((json) => locName.fromJson(json)).toList();
  }

//Signup
  Future<dynamic> _checkUsr(
      String nm, String em, String pwd, String phn) async {
    if (nm == "") {
      setState(() {
        _nmValError = true;
      });
    }
    if (phn == "") {
      setState(() {
        _phnValError = true;
      });
    }
    if (em == "") {
      setState(() {
        _emValError = true;
      });
    }
    if (pwd == "") {
      setState(() {
        _pwdValError = true;
      });
    }
    if (_genTextFeild == null) {
      setState(() {
        _genValError = true;
      });
    }
    if (_catTextFeild == null) {
      setState(() {
        _proValError = true;
      });
    }
    if (gendervlue == null) {
      setState(() {
        _locValError = true;
      });
    }
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
        if (_emValError == false &&
            _pwdValError == false &&
            _nmValError == false &&
            _phnValError == false &&
            _genValError == false &&
            _proValError == false &&
            _locValError == false) {
          _signup(nm, em, pwd, phn);
        } else {
          _showMyDialog("Error", "Please Enter Details", "UserExists");
        }
      } else {
        print("User not Created");
        _showMyDialog("Error", "Mobile no. Already Exists", "UserExists");
      }
    }
  }

  Future<dynamic> _signup(String nm, String em, String pwd, String phn) async {
    //Check mobile
    var requestBody = {
      "service_name": "register",
      "param": {
        "u_nm": nm,
        "u_phn": phn,
        "u_email": em,
        "u_pwd": pwd,
        "u_city": gendervlue.toString(),
        "u_pfn": _catTextFeild.toString(),
        "u_gender": _genTextFeild.toString()
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

  @override
  void initState() {
    super.initState();
    this._getCat();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "SIGN UP",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => Layout()),
                          );
                        },
                        child: Text("Skip"))
                  ],
                ),
              ),
              Center(
                child: Container(
                  child: Image.asset(
                    "assets/images/pro.png",
                    height: 180,
                    width: 150,
                  ),
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
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: TextField(
                                  maxLength: 10,
                                  keyboardType: TextInputType.phone,
                                  controller: _mobileController,
                                  decoration: InputDecoration(
                                      counterText: "",
                                      prefixIcon: Padding(
                                        padding: const EdgeInsets.all(8.0),
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
                                              width: 1.0),
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey.shade300,
                                              width: 1.0),
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      contentPadding: EdgeInsets.fromLTRB(
                                          20.0, 15.0, 20.0, 10.0),
                                      hintText: "Mobile No",
                                      focusColor: Colors.grey,
                                      fillColor: Colors.white),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: new TextField(
                                  maxLength: 6,
                                  controller: _passwordController,
                                  decoration: InputDecoration(
                                      counterText: "",
                                      // suffixIcon: Icon(CupertinoIcons.eye),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey.shade300,
                                              width: 1.0),
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey.shade300,
                                              width: 1.0),
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      contentPadding: EdgeInsets.fromLTRB(
                                          20.0, 15.0, 20.0, 10.0),
                                      hintText: "Enter One Time Password",
                                      focusColor: Colors.green,
                                      fillColor: Colors.grey),
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.only(
                                    right: 20, top: 10, bottom: 10),
                                child: Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          // Navigator.push(
                                          //     context,
                                          //     MaterialPageRoute(
                                          //         builder: (context) =>
                                          //             ForgotPasswordScreen()));
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
                                height: 10,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: new TextField(
                                  controller: _nameController,
                                  decoration: InputDecoration(

                                      // suffixIcon: Icon(CupertinoIcons.eye),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey.shade300,
                                              width: 1.0),
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey.shade300,
                                              width: 1.0),
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      contentPadding: EdgeInsets.fromLTRB(
                                          20.0, 15.0, 20.0, 10.0),
                                      hintText: "Name",
                                      focusColor: Colors.green,
                                      fillColor: Colors.grey),
                                ),
                              ),

                              SizedBox(
                                height: 10,
                              ),
                              // gender
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20.0, right: 20, top: 10, bottom: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        gendervlue = 1;
                                        setState(() {});
                                      },
                                      child: Container(
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            boxShadow: [
                                              gendervlue == 1
                                                  ? BoxShadow(
                                                      color: Colors.blue,
                                                      spreadRadius: 5,
                                                      blurRadius: 5)
                                                  : BoxShadow()
                                            ]),
                                        child: SvgPicture.asset(
                                            "assets/icons/man-user-circle-icon.svg",
                                            semanticsLabel: 'Acme Logo'),
                                      ),
                                    ),
                                    // Text("MALE"),
                                    InkWell(
                                      onTap: () {
                                        gendervlue = 0;
                                        setState(() {});
                                      },
                                      child: Container(
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            boxShadow: [
                                              gendervlue == 0
                                                  ? BoxShadow(
                                                      color: Colors.pinkAccent,
                                                      spreadRadius: 5,
                                                      blurRadius: 5)
                                                  : BoxShadow()
                                            ]),
                                        child: SvgPicture.asset(
                                            "assets/icons/woman-user-circle-icon.svg",
                                            semanticsLabel: 'Acme Logo'),
                                      ),
                                    ),
                                    // Text("FEMALE"),
                                    //
                                  ],
                                ),
                              ),
                              // Padding(
                              //   padding:
                              //       const EdgeInsets.symmetric(horizontal: 16),
                              //   child: Container(
                              //     decoration: BoxDecoration(
                              //         borderRadius: BorderRadius.circular(10.0),
                              //         border: Border.all(
                              //             color: Colors.grey.shade500,
                              //             width: 1),
                              //         color: Colors.white),
                              //     padding: EdgeInsets.symmetric(horizontal: 2),
                              //     child:
                              //       // gender dropdown
                              //     // FormBuilderDropdown<String>(
                              //     //   // autovalidate: true,
                              //     //   name: 'Gender',
                              //     //   decoration: InputDecoration(
                              //     //     border: InputBorder.none,
                              //     //     focusedBorder: OutlineInputBorder(
                              //     //         borderSide: BorderSide(
                              //     //             color: Colors.white, width: 2.0),
                              //     //         borderRadius:
                              //     //             BorderRadius.circular(10.0)),
                              //     //     contentPadding:
                              //     //         EdgeInsets.only(left: 20.0),
                              //     //     focusColor: Colors.green,
                              //     //     fillColor: Colors.white,
                              //     //     hintText: 'Select Gender',
                              //     //     // suffix: _timePriorityError
                              //     //     //     ? const Icon(Icons.error)
                              //     //     //     : const Icon(Icons.check),
                              //     //   ),
                              //     //   // initialValue: 'Male',
                              //     //   // allowClear: true,
                              //     //   // hint: Text('Select Gender'),
                              //     //   // validator: FormBuilderValidators.compose(
                              //     //   //     [FormBuilderValidators.required(context)]),
                              //     //   items: _gender
                              //     //       .map((location) => DropdownMenuItem(
                              //     //             value: location,
                              //     //             child: Text(location),
                              //     //           ))
                              //     //       .toList(),
                              //     //   onChanged: (val) {
                              //     //     setState(() {
                              //     //       _locValError = false;
                              //     //     });
                              //     //     print(val);
                              //     //     if (val == "Male") {
                              //     //       setState(() {
                              //     //         gendervlue = 0;
                              //     //       });
                              //     //     } else if (val == "Female") {
                              //     //       setState(() {
                              //     //         gendervlue = 1;
                              //     //       });
                              //     //     }
                              //     //     print(gendervlue);
                              //     //   },
                              //     // ),
                              //   ),
                              // ),

                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: new TextField(
                                  controller: _emailController,
                                  decoration: InputDecoration(

                                      // suffixIcon: Icon(CupertinoIcons.eye),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey.shade300,
                                              width: 1.0),
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey.shade300,
                                              width: 1.0),
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      contentPadding: EdgeInsets.fromLTRB(
                                          20.0, 15.0, 20.0, 10.0),
                                      hintText: "Email",
                                      focusColor: Colors.green,
                                      fillColor: Colors.grey),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: new TextField(
                                  controller: _proController,
                                  decoration: InputDecoration(

                                      // suffixIcon: Icon(CupertinoIcons.eye),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey.shade300,
                                              width: 1.0),
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey.shade300,
                                              width: 1.0),
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      contentPadding: EdgeInsets.fromLTRB(
                                          20.0, 15.0, 20.0, 10.0),
                                      hintText: "Profession",
                                      focusColor: Colors.green,
                                      fillColor: Colors.grey),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      border: Border.all(
                                          color: Colors.grey.shade500,
                                          width: 1),
                                      color: Colors.white),
                                  padding: EdgeInsets.symmetric(horizontal: 2),
                                  child: FormBuilderDropdown<String>(
                                    // autovalidate: true,
                                    name: 'Finder/Fixture',
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey.shade300,
                                              width: 1.0),
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      contentPadding:
                                          EdgeInsets.only(left: 20.0),
                                      focusColor: Colors.green,
                                      fillColor: Colors.white,
                                      hintText: 'Finder / Fixture',
                                    ),

                                    items: _finder
                                        .map((location) => DropdownMenuItem(
                                              value: location,
                                              child: Text(location),
                                            ))
                                        .toList(),
                                    onChanged: (val) {
                                      setState(() {
                                        _locValError = false;
                                      });
                                      print(val);
                                      if (val == "Finder") {
                                        setState(() {
                                          usertype_value = 0;
                                        });
                                      } else if (val == "Fixture") {
                                        setState(() {
                                          usertype_value = 1;
                                        });
                                      }
                                      print(usertype_value);
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),

                              Container(
                                margin: EdgeInsets.all(5),
                                child: FormBuilderCheckbox(
                                  name: 'accept_terms',
                                  initialValue: false,
                                  // onChanged: _onChanged,
                                  title: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'I have read and agree to the ',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        TextSpan(
                                          text: 'Terms and Conditions',
                                          style: TextStyle(color: Colors.blue),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              // Signup Button
                              Container(
                                margin: EdgeInsets.all(5),
                                child: Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: Container(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                          shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(18.0),
                                            ),
                                          ),
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  mainBlue)),
                                      //
                                      // elevation: 10,
                                      // textColor: Colors.white,
                                      // materialTapTargetSize: ,
                                      onPressed: () {
                                        print("continue cliked");
                                        print("continue $gendervlue");
                                        print("continue $_catTextFeild");
                                        print("continue cliked");
                                        UserPost(
                                            email: _emailController.text,
                                            phonenumber: _mobileController.text,
                                            username: _nameController.text,
                                            gender: gendervlue,
                                            profession: _proController.text,
                                            user_type: usertype_value);
                                        // {
                                        //   print('Finder and fixture    9'),
                                        //   print(gendervlue),
                                        //   gendervlue == 1
                                        //       ? Navigator.of(context)
                                        //           .push(
                                        //           MaterialPageRoute(
                                        //               builder: (_) =>
                                        //                   FixtureScreen()),
                                        //         )
                                        //       : Navigator.of(context)
                                        //           .push(
                                        //           MaterialPageRoute(
                                        //               builder: (_) =>
                                        //                   Layout()),
                                        //         )
                                        //   // _checkUsr(
                                        //   //     _nameController
                                        //   //         .text,
                                        //   //     _emailController
                                        //   //         .text
                                        //   //     // // _pwdController.text,
                                        //   //     // _phnController.text
                                        //   //
                                        //   // );
                                        // }
                                      },
                                      // color: mainOrange,
                                      // splashColor: mainBlue,
                                      // padding: EdgeInsets.all(10.0),
                                      child: Text(
                                        "   Continue   ",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> UserPost({
    required String email,
    required String phonenumber,
    String? user_address,
    String? profession,
    required String username,
    required int? user_type,
    int? gender,
  }) async {
    try {
      var json = jsonEncode({
        "email": email,
        "phnumber": phonenumber,
        "role": "ROLE_USER",
        "usaddress": user_address,
        "gender": gender,
        "usname": username,
        "profession": profession,
        "ustype": user_type,
        "usstatus": "Active"
      });
      var header = {"Content-Type": "application/json"};
      Uri url = Uri.parse(
          "http://ec2-16-171-139-167.eu-north-1.compute.amazonaws.com:5000/auth/signupwithotp");
      //
      print(json);
      final response = await http.post(url, headers: header, body: json);
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        popMessage(context, jsonDecode(response.body)['message']);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignInScreen()));
      }
      {
        popMessage(context, jsonDecode(response.body)['message']);
      }
    } catch (e) {
      print(e);
    }
  }
}
