import 'dart:convert';
import 'dart:ui';
import 'package:goffix/screens/image/image_upload.dart';
import 'package:goffix/screens/login/login.dart';
import 'package:goffix/screens/otp/otpScreen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:goffix/constants.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
// import 'package:goffix/screens/add/AddScreen.dart';

class ConfigScreen extends StatefulWidget {
  final String? uid;
  @override
  const ConfigScreen({Key? key, this.uid}) : super(key: key);
  _ConfigScreenState createState() => _ConfigScreenState();
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

class _ConfigScreenState extends State<ConfigScreen> {
  //validators
  bool _nmValError = false;
  bool _phnValError = false;
  bool _emValError = false;
  bool _pwdValError = false;
  bool _utypValError = false;
  bool _langValError = false;
  bool _descValError = false;
  bool _locValError = false;
  bool _proValError = false;

  //Values
  late int _utypTextFeild;
 late int _langTextFeild;
  late String _expTextFeild;
  late int _prfTextFeild;
  var _prf = ['Aaadhar Card', 'PAN Card', 'Votar ID Card'];
  var _utyp = ['Finder', 'Fixer'];
  var _lang = ['English'];
  var _exp = ['1-5', '5-9', '10+'];
  var ui_intr = ["Painter", "WireMan", "Plumber"];
  late int _catTextFeild;
 late int _locTextFeild;
 late List listOfLoc;
 late List<catName> listOfCat;
 late List<catName> filteredCat;
 late List<locName> filteredLoc;

//Controllers
  final TextEditingController _descController = new TextEditingController();
  // final TextEditingController _locationController = new TextEditingController();
  final TextEditingController _prfidController = new TextEditingController();
  // final TextEditingController _emailController = new TextEditingController();
  // final TextEditingController _pwdController = new TextEditingController();
  // final TextEditingController _phnController = new TextEditingController();
// Get Proffession test
  Future<List<catName>?> _getCat() async {
    var requestBody = {
      "service_name": "getMastersDataOfAddPostForm",
      "param": {}
    };
    var jsonRequest = json.encode(requestBody);
    print(jsonRequest);
    var url = Uri.parse("http://goffix.com/goffix/restapi/api/");
    var response = await http.post(url,
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
    // return null;
  }

//Get Proffession and Location
  Future<List<catName>?> _getCategory() async {
    // String token = await User().getToken();
    // int uid = await User().getUID();
    var requestBody = {
      "service_name": "categoryNamesByKeyWord",
      "param": {"key_word": ""}
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
        List<catName> catList =
            parseCat(jsonResponse['response']['result']['data']).cast();
        print(catList);
        setState(() {
          listOfCat = catList;
        });
        // return catList;
      } else if (jsonResponse["response"]["status"] == 108) {
        // _showMyDialog("Error", "Username/Password not found", "login");
        print("Categories not found");
      } else {
        print("Something Went Wrong");
      }
    }
  }

  static List<catName> parseCat(responseBody) {
    return responseBody.map<catName>((json) => catName.fromJson(json)).toList();
  }

  static List<locName> parseLoc(responseBody) {
    return responseBody.map<locName>((json) => locName.fromJson(json)).toList();
  }

//Signup
  Future<dynamic> _configUsr(String desc, String prfid) async {
    if (desc == "") {
      desc = "I Love Goffix";
    }
    if (_utypTextFeild == 0) {
      prfid = "0";
      _expTextFeild = "0";
      _prfTextFeild = int.parse("0");
    }
    var requestBody = {
      "service_name": "adduserconfig",
      "param": {
        "u_id": widget.uid,
        "u_desc": desc,
        "us_exp": _expTextFeild,
        "us_proof": _prfTextFeild,
        "us_prfid": prfid,
        "us_typ": _utypTextFeild,
        "us_lang": _langTextFeild,
        "ui_intr": ui_intr
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
                builder: (context) => CameraScreen(uid: widget.uid!)));
        // print("success");
      } else {
        print("User not Created");
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
    Size size = MediaQuery.of(context).size;
    return new Scaffold(
      body: SafeArea(
        child: Stack(fit: StackFit.expand,
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
                        "assets/images/logo_ls.png",
                        height: 50,
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
                                    // Usertype
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                          border: _utypValError == true
                                              ? Border.all(
                                                  color: Colors.red, width: 1)
                                              : Border.all(
                                                  color: Colors.transparent),
                                          color: Colors.grey[300]),
                                      margin: EdgeInsets.all(8),
                                      child: FormBuilderDropdown<String>(
                                        // autovalidate: true,
                                        name: 'User Type',
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey.shade300,
                                                  width: 32.0),
                                              borderRadius:
                                                  BorderRadius.circular(25.0)),
                                          contentPadding: EdgeInsets.fromLTRB(
                                              20.0, 5.0, 20.0, 5.0),
                                          focusColor: Colors.green,
                                          fillColor: Colors.grey,
                                          labelText: 'Select User Type',
                                          // suffix: _timePriorityError
                                          //     ? const Icon(Icons.error)
                                          //     : const Icon(Icons.check),
                                        ),
                                        // initialValue: 'Male',
                                        // allowClear: true,
                                        // hint: Text('Select User Type'),
                                        // validator: FormBuilderValidators.compose(
                                        //     [FormBuilderValidators.required(context)]),
                                        items: _utyp
                                            .map((gender) => DropdownMenuItem(
                                                  value: gender,
                                                  child: Text(gender),
                                                ))
                                            .toList(),
                                        onChanged: (val) {
                                          setState(() {
                                            _utypValError = false;
                                          });
                                          print(val);
                                          if (val == "Finder") {
                                            setState(() {
                                              _utypTextFeild = 0;
                                            });
                                          } else if (val == "Fixer") {
                                            setState(() {
                                              _utypTextFeild = 1;
                                            });
                                          }
                                          print(_utypTextFeild);
                                        },
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(left: 20),
                                      child: _utypValError
                                          ? Row(children: [
                                              Text(
                                                "Please User type",
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ),
                                            ])
                                          : Row(),
                                    ),
                                    //Usertype Desc
                                    Container(
                                      padding:
                                          EdgeInsets.only(left: 5, right: 5),
                                      child: Text(
                                          "Finder: Select if your searching for a service provider. "),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.only(left: 30, right: 5),
                                      child: Text(
                                          "Fixer: Select if your a professional in a field Eg: Electrician, plumber.. "),
                                    ),
                                    // Language
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                          border: _langValError == true
                                              ? Border.all(
                                                  color: Colors.red, width: 1)
                                              : Border.all(
                                                  color: Colors.transparent),
                                          color: Colors.grey[300]),
                                      margin: EdgeInsets.all(8),
                                      child: FormBuilderDropdown<String>(
                                        // autovalidate: true,
                                        name: 'Language',
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey.shade300,
                                                  width: 32.0),
                                              borderRadius:
                                                  BorderRadius.circular(25.0)),
                                          contentPadding: EdgeInsets.fromLTRB(
                                              20.0, 5.0, 20.0, 5.0),
                                          focusColor: Colors.green,
                                          fillColor: Colors.grey,
                                          labelText: 'Select Language',
                                          // suffix: _timePriorityError
                                          //     ? const Icon(Icons.error)
                                          //     : const Icon(Icons.check),
                                        ),
                                        // // initialValue: '',
                                        // allowClear: true,
                                        // hintText: Text('Select Language'),
                                        // validator: FormBuilderValidators.compose(
                                        //     [FormBuilderValidators.required(context)]),
                                        items: _lang
                                            .map((gender) => DropdownMenuItem(
                                                  value: gender,
                                                  child: Text(gender),
                                                ))
                                            .toList(),
                                        onChanged: (val) {
                                          setState(() {
                                            _langValError = false;
                                          });
                                          print(val);
                                          setState(() {
                                            _langTextFeild = 0;
                                          });

                                          print(_langTextFeild);
                                        },
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(left: 20),
                                      child: _langValError
                                          ? Row(children: [
                                              Text(
                                                "Please Select Lang",
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ),
                                            ])
                                          : Row(),
                                    ),

                                    // Description
                                    Container(
                                      height: 120,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                          border: _descValError == true
                                              ? Border.all(
                                                  color: Colors.red, width: 1)
                                              : Border.all(
                                                  color: Colors.transparent),
                                          color: Colors.grey[300]),
                                      margin: EdgeInsets.all(8),
                                      child: FormBuilderTextField(
                                        name: 'Desc',

                                        onChanged: (String? val) {
                                          if (val!.isNotEmpty) {
                                            setState(() {
                                              _descValError = false;
                                            });
                                          }
                                        },
                                        controller: _descController,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey.shade300,
                                                  width: 32.0),
                                              borderRadius:
                                                  BorderRadius.circular(25.0)),
                                          contentPadding: EdgeInsets.fromLTRB(
                                              20.0, 15.0, 20.0, 10.0),
                                          focusColor: Colors.green,
                                          fillColor: Colors.grey,
                                          labelText: 'Say about Youself',
                                        ),
                                        // onChanged: _onChanged,
                                        // valueTransformer: (text) => num.tryParse(text),
                                        // validator: FormBuilderValidators.compose([
                                        //   FormBuilderValidators.required(context),
                                        //   // FormBuilderValidators.numeric(context),
                                        //   FormBuilderValidators.max(context, 50),
                                        // ]),
                                        keyboardType: TextInputType.multiline,
                                        minLines: 1,
                                        maxLines: 5,
                                      ),
                                    ),
                                    //Fixer Columns
                                    _utypTextFeild == 1
                                        ? Container(
                                            child: Column(
                                              children: [
                                                //Select Exp
                                                Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30.0),
                                                      color: Colors.grey[300]),
                                                  margin: EdgeInsets.all(8),
                                                  child: FormBuilderDropdown<
                                                      String>(
                                                    // autovalidate: true,
                                                    name: 'Experience',
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  color:
                                                                      Colors.grey.shade300,
                                                                  width: 32.0),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          25.0)),
                                                      contentPadding:
                                                          EdgeInsets.fromLTRB(
                                                              20.0,
                                                              5.0,
                                                              20.0,
                                                              5.0),
                                                      focusColor: Colors.green,
                                                      fillColor: Colors.grey,
                                                      labelText:
                                                          'Select Experience',
                                                      // suffix: _timePriorityError
                                                      //     ? const Icon(Icons.error)
                                                      //     : const Icon(Icons.check),
                                                    ),
                                                    // initialValue: '',
                                                    // allowClear: true,
                                                    // hint: Text(
                                                    //     'Select Experience'),
                                                    // validator: FormBuilderValidators.compose(
                                                    //     [FormBuilderValidators.required(context)]),
                                                    items: _exp
                                                        .map((gender) =>
                                                            DropdownMenuItem(
                                                              value: gender,
                                                              child:
                                                                  Text(gender),
                                                            ))
                                                        .toList(),
                                                    onChanged: (val) {
                                                      print(val);
                                                      // if(val == "1-5" ){

                                                      // }
                                                      setState(() {
                                                        _expTextFeild = val!;
                                                      });

                                                      print(_expTextFeild);
                                                    },
                                                  ),
                                                ),

                                                //Select Proof
                                                Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30.0),
                                                      color: Colors.grey[300]),
                                                  margin: EdgeInsets.all(8),
                                                  child: FormBuilderDropdown<
                                                      String>(
                                                    // autovalidate: true,
                                                    name: 'Proof',
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  color:
                                                                      Colors.grey.shade300,
                                                                  width: 32.0),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          25.0)),
                                                      contentPadding:
                                                          EdgeInsets.fromLTRB(
                                                              20.0,
                                                              5.0,
                                                              20.0,
                                                              5.0),
                                                      focusColor: Colors.green,
                                                      fillColor: Colors.grey,
                                                      labelText: 'Select Proof',
                                                      // suffix: _timePriorityError
                                                      //     ? const Icon(Icons.error)
                                                      //     : const Icon(Icons.check),
                                                    ),
                                                    // initialValue: '',
                                                    // allowClear: true,
                                                    // hint: Text('Select Proof'),
                                                    // validator: FormBuilderValidators.compose(
                                                    //     [FormBuilderValidators.required(context)]),
                                                    items: _prf
                                                        .map((gender) =>
                                                            DropdownMenuItem(
                                                              value: gender,
                                                              child:
                                                                  Text(gender),
                                                            ))
                                                        .toList(),
                                                    onChanged: (val) {
                                                      // setState(() {
                                                      //   _langValError = false;
                                                      // });
                                                      print(val);
                                                      if (val ==
                                                          "Aaadhar Card") {
                                                        setState(() {
                                                          _prfTextFeild = 0;
                                                        });
                                                      } else if (val ==
                                                          "PAN Card") {
                                                        setState(() {
                                                          _prfTextFeild = 1;
                                                        });
                                                      } else if (val ==
                                                          "Votar ID Card") {
                                                        setState(() {
                                                          _prfTextFeild = 2;
                                                        });
                                                      }

                                                      print(_prfTextFeild);
                                                    },
                                                  ),
                                                ),

                                                // Proof id
                                                Container(
                                                  child: Column(children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      30.0),
                                                          color:
                                                              Colors.grey[300]),
                                                      margin: EdgeInsets.all(8),
                                                      child:
                                                          FormBuilderTextField(
                                                        onChanged:
                                                            (String? val) {
                                                          if (val!.isNotEmpty) {
                                                            setState(() {
                                                              _nmValError =
                                                                  false;
                                                            });
                                                          }
                                                        },
                                                        name: 'Name',
                                                        controller:
                                                            _prfidController,
                                                        decoration:
                                                            InputDecoration(
                                                          border:
                                                              InputBorder.none,
                                                          focusedBorder: OutlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  color: Colors
                                                                          .grey.shade300,
                                                                  width: 32.0),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          25.0)),
                                                          contentPadding:
                                                              EdgeInsets
                                                                  .fromLTRB(
                                                                      20.0,
                                                                      5.0,
                                                                      20.0,
                                                                      5.0),
                                                          focusColor:
                                                              Colors.green,
                                                          fillColor:
                                                              Colors.grey,
                                                          labelText:
                                                              'Enter Proof id',
                                                        ),
                                                      ),
                                                    ),
                                                    // Container(
                                                    //   padding:
                                                    //       EdgeInsets.only(left: 20),
                                                    //   child: _nmValError
                                                    //       ? Row(children: [
                                                    //           Text(
                                                    //             "Please enter Proof id",
                                                    //             style: TextStyle(
                                                    //                 color:
                                                    //                     Colors.red),
                                                    //           ),
                                                    //         ])
                                                    //       : Row(),
                                                    // ),
                                                  ]),
                                                ),
                                              ],
                                            ),
                                          )
                                        : Container(),
                                    // submit Button
                                    Container(
                                      margin: EdgeInsets.all(5),
                                      child: Padding(
                                        padding: const EdgeInsets.all(0.0),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Container(
                                                child: ElevatedButton(
                                                  // shape: RoundedRectangleBorder(
                                                  //   borderRadius:
                                                  //       BorderRadius.circular(
                                                  //           18.0),
                                                  // ),
                                                  // elevation: 10,
                                                  // textColor: Colors.white,
                                                  onPressed: () => {
                                                    _configUsr(
                                                        _descController.text,
                                                        _prfidController.text)
                                                    // _formKey.currentState.save(),
                                                    // if (_formKey.currentState.validate())
                                                    //   {
                                                    // print(_formKey.currentState.value),
                                                    // _addPost(_postTitle.text, _postDesc.text)
                                                    //   }
                                                    // else
                                                    //   {
                                                    //     print("validation failed"),
                                                    //   }
                                                  },
                                                  // color: mainOrange,
                                                  // splashColor: mainBlue,
                                                  // padding: EdgeInsets.all(10.0),
                                                  child: Row(
                                                    // Replace with a Row for horizontal icon + text
                                                    children: <Widget>[
                                                      // Icon(Icons.add),
                                                      Text("Next")
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ]),
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
            ]),
      ),
    );
  }
}
