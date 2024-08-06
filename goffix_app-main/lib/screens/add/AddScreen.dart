import 'dart:convert';
import 'dart:io' as Io;
import 'dart:async';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:goffix/screens/add/Del_post.dart';
import 'package:goffix/screens/home/homeScreen.dart';
import 'package:goffix/screens/layout/layout.dart';
import 'package:goffix/screens/search/BookingStatus.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:goffix/constants.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:goffix/models/location_model.dart';
import 'package:goffix/providers/location_provider.dart';
import 'package:goffix/screens/login/login.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:slider_button/slider_button.dart';
// import 'utils/validators.dart';

// import 'package:slider_button/slider_button.dart';

class AddScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class catName {
  String? cat_id;
  String? cat_name;
  String? cat_astat;

  catName({this.cat_id, this.cat_name, this.cat_astat});

  factory catName.fromJson(Map<String, dynamic> json) {
    return catName(
      cat_id: json["cat_id"] as String,
      cat_name: json["cat_name"] as String,
      cat_astat: json["cat_astat"] as String,
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

class _HomeScreenState extends State<AddScreen> {
  get value => null;
  bool select = true;
  final _formKey = GlobalKey<FormBuilderState>();
  var AllCategories = ['Plumber', 'Carpenter', 'Electrician'];
  var AllLoc = ['Akkayyapalem', 'NAD', 'Dondaparthi'];
  bool _timePriorityError = false;
  bool _contactType = false;
  var timePriority = ['One Day', 'One Week', 'One Month'];
  var contactType = ['Only Message', 'Call and Message'];
  bool isPosted = false;
  bool IsPosting = false;

  //validators
  bool _titValError = false;
  bool _descValError = false;
  bool _proValError = false;
  bool _locValError = false;
  bool _timValError = false;
  bool _ctypValError = false;

  final TextEditingController _categoryController = new TextEditingController();
  final TextEditingController _locationController = new TextEditingController();
  final TextEditingController _postTitle = new TextEditingController();
  final TextEditingController _professionController = new TextEditingController();
  final TextEditingController _postDesc = new TextEditingController();

  late int _catTextFeild;
  late int _locTextFeild;
  late int _conTypeTextFeild;
  late int _timePTextFeild;

  late List listOfLoc;
  late List<catName> listOfCat;
  late List<catName> filteredCat;
  late List<locName> filteredLoc;

  late Timer _timer;
  int _start = 10;

  // void startTimer() {
  //   const oneSec = const Duration(seconds: 1);
  //   _timer = new Timer.periodic(
  //     oneSec,
  //     (Timer timer) {
  //       if (_start == 0) {
  //         setState(() {
  //           timer.cancel();
  //         });
  //       } else {
  //         setState(() {
  //           _start--;
  //         });
  //       }
  //     },
  //   );
  // }

  Future<List<catName>?> _getCategory() async {
    String? token = await User().getToken();
    int? uid = await User().getUID();
    var requestBody = {
      "service_name": "getMastersDataOfAddPostForm",
      "param": {}
    };
    var jsonRequest = json.encode(requestBody);
    print(jsonRequest);
    var response = await http.post(baseUrl,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonRequest);
    var jsonResponse = null;
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse["response"]["status"] == 200) {
        List<catName> catList =
            parseCat(jsonResponse['response']['result']['categories']).cast();
        print(catList);
        return catList;
      } else if (jsonResponse["response"]["status"] == 108) {
        // _showMyDialog("Error", "Username/Password not found", "login");
        print("Locations not found");
      } else {
        print("Something Went Wrong");
      }


    }

  }

  Future<List<LocModel>?> _getLoc() async {
    // refreshPosts() {}
    // Future _getPosts() async {
    // _getPosts() async {
    String? token = await User().getToken();
    int? uid = await User().getUID();
    var requestBody = {
      "service_name": "getMastersDataOfAddPostForm",
      "param": {}
    };
    var jsonRequest = json.encode(requestBody);
    print(jsonRequest);
    var response = await http.post(baseUrl,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonRequest);
    var jsonResponse = null;
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse["response"]["status"] == 200) {
        if (this.mounted) {
          setState(() {
            listOfLoc = jsonResponse['response']['result']['locations'];
          });
        }
        print(listOfLoc);
        // LocProvider.db.deleteAllEmployees();
        // return (listOfLoc as List).map((loc) {
        //   print('Inserting $loc');
        //   LocProvider.db.createLocation(LocModel.fromJson(loc));
        // }).toList();

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

// https://www.coderzheaven.com/2019/05/29/filtering-a-listview-in-flutter-using-a-onchange-on-textfield-with-delay-in-flutter/
  Future<List<catName>?> _getCat() async {
    String? token = await User().getToken();
    int? uid = await User().getUID();
    var requestBody = {
      "service_name": "getMastersDataOfAddPostForm",
      "param": {}
    };
    var jsonRequest = json.encode(requestBody);
    print(jsonRequest);
    var response = await http.post(baseUrl,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonRequest);
    var jsonResponse = null;
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse["response"]["status"] == 200) {
        if (this.mounted) {
          setState(() {
            listOfCat =
                parseCat(jsonResponse['response']['result']['categories']);
            listOfLoc =
                parseLoc(jsonResponse['response']['result']['locations']);
            // .cast<catName>();
          });
        }

        print(listOfCat);
        print(listOfLoc);
        // return listOfCat;
        // LocProvider.db.deleteAllEmployees();
        // return (listOfLoc as List).map((loc) {
        //   print('Inserting $loc');
        //   LocProvider.db.createLocation(LocModel.fromJson(loc));
        // }).toList();

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

  Future<void> _showMyDialog() async {
    // var context;
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Job Post"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("Job Posted Successfully"),
                // Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Okay'),
              onPressed: () {
                // if (route == "home") {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (BuildContext context) => Layout()),
                );
                // } else if (route == "login") {
                //   Navigator.of(context).pop();
                // }
              },
            ),
          ],
        );
      },
    );
  }

  Future<dynamic> _addPost(String tit, String Desc) async {
    if (this.mounted) {
      setState(() {
        IsPosting = true;
      });
    }
    if (tit == "") {
      if (this.mounted) {
        setState(() {
          _titValError = true;
        });
      }
    }
    if (Desc == "") {
      if (this.mounted) {
        setState(() {
          _descValError = true;
        });
      }
    }
    if (_catTextFeild == null) {
      if (this.mounted) {
        setState(() {
          _proValError = true;
        });
      }
    }
    if (_locTextFeild == null) {
      if (this.mounted) {
        setState(() {
          _locValError = true;
        });
      }
    }
    if (_conTypeTextFeild == null) {
      if (this.mounted) {
        setState(() {
          _ctypValError = true;
        });
      }
    }
    if (_timePTextFeild == null) {
      if (this.mounted) {
        setState(() {
          _timValError = true;
        });
      }
    }

    String? token = await User().getToken();
    int? uid = await User().getUID();

    var requestBody = {
      "service_name": "addPost",
      "param": {
        "p_uid": uid,
        "p_tit": tit,
        "p_jd": Desc,
        "p_catid": _catTextFeild,
        "p_loc": _locTextFeild,
        "p_amt": "",
        "p_priority": _timePTextFeild,
        "p_ctyp": _conTypeTextFeild
      }
    };
    var jsonRequest = json.encode(requestBody);
    print(jsonRequest);
    var response = await http.post(baseUrl,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonRequest);
    var jsonResponse = null;

    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if (jsonResponse["response"]["status"] == 200) {
        if (this.mounted) {
          setState(() {
            isPosted = true;
            IsPosting = false;
          });
        }

        // _showMyDialog();
        // Navigator.of(context).pushReplacement(
        //   MaterialPageRoute(builder: (BuildContext context) => Layout()),
        // );
        //Post Success code
        // Alert(
        //   context: context,
        //   type: AlertType.success,
        //   title: "Job Post",
        //   desc: "Job Posted Successfully",
        //   buttons: [
        //     DialogButton(
        //       child: Text(
        //         "Okay",
        //         style: TextStyle(color: Colors.white, fontSize: 20),
        //       ),
        //       onPressed: () => Navigator.pop(context),
        //       width: 120,
        //     )
        //   ],
        // ).show().then((value) {
        //   print(value);
        //   Navigator.pushReplacement(
        //       context, MaterialPageRoute(builder: (context) => Layout()));
        // });
      } else {
        print("Post not posted");
      }
    }
  }

  static List<catName> parseCat(responseBody) {
    return responseBody.map<catName>((json) => catName.fromJson(json)).toList();
  }

  static List<locName> parseLoc(responseBody) {
    return responseBody.map<locName>((json) => locName.fromJson(json)).toList();
  }

  @override
  void initState() {
    super.initState();
    // this._getLoc();
    // this._getCat().then((catFromServer) {
    //   setState(() {
    //     listOfCat = catFromServer;
    //   });
    // });
    this._getCat();
    // this._getCategory().then((catFromServer) {
    //   setState(() {
    //     listOfCat = catFromServer;
    //   });
    // });
    // this.param();
    // _scrollController = new ScrollController();
  }

  @override
  void dispose() {
    // _timer.cancel();
    this._getCat();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        // appBar: AppBar(
        //   backgroundColor: Colors.white,
        //   elevation: 30,
        //   bottomOpacity: 0.8,
        //   toolbarHeight: 60,
        //   title: Row(
        //     mainAxisAlignment: MainAxisAlignment.start,
        //     children: [
        //       Image.asset(
        //         'assets/images/logo.png',
        //         fit: BoxFit.contain,
        //         height: 45,
        //       ),
        //     ],
        //   ),
        // ),
        body: SingleChildScrollView(
      child: SafeArea(
        // padding: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.only(top: 0),
          child: Container(
            padding: EdgeInsets.only(left: 0.0, right: 0.0),
            width: double.infinity,
            // height: 650,
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20.0, top: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Post a Job",
                          style: TextStyle(
                              fontSize: 30,
                              fontFamily: "Lato",
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DeletePostScreen()),
                            );
                          },
                          child: Icon(
                            Icons.delete,
                            size: 30,
                            color: mainBlue,
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  // Center(
                  //     child: Text(
                  //   "Post a Job",
                  //   style: TextStyle(
                  //       color: mainBlue,
                  //       fontFamily: "Lato",
                  //       fontSize: 20,
                  //       fontWeight: FontWeight.bold),
                  // )),
                  // Title
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      // maxLength: 10,
                      keyboardType: TextInputType.number,
                      controller: _postTitle,

                      decoration: InputDecoration(

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
                          hintText: "Post Title",
                          focusColor: Colors.grey,
                          fillColor: Colors.grey),
                    ),
                  ),

                  SizedBox(height: 10,),
                  // Title validation
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                     maxLines: 7,
                      // keyboardType: TextInputType.number,
                      controller: _postDesc,

                      decoration: InputDecoration(

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
                          hintText: "Post Descrption",
                          focusColor: Colors.grey,
                          fillColor: Colors.grey),
                    ),
                  ),
                  SizedBox(height: 10,),
                  // Description
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      // maxLength: 10,
                      keyboardType: TextInputType.number,
                      controller: _professionController,

                      decoration: InputDecoration(

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
                          hintText: "Profession",
                          focusColor: Colors.grey,
                          fillColor: Colors.grey),
                    ),
                  ),
                  SizedBox(height: 10,),
                  // Description validation
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
                        items: AllLoc
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
                  SizedBox(height: 10,),
                  // Proffession
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
                        name: 'OneDay',
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
                          hintText: 'OneDay',
                          // suffix: _timePriorityError
                          //     ? const Icon(Icons.error)
                          //     : const Icon(Icons.check),
                        ),
                        // initialValue: 'Male',
                        // allowClear: true,
                        // hint: Text('Select Gender'),
                        // validator: FormBuilderValidators.compose(
                        //     [FormBuilderValidators.required(context)]),
                        items:
                        timePriority.map((location) =>
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

                  SizedBox(height: 10,),
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
                        name: 'OneDay',
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
                          hintText: 'OnlyMessage',
                          // suffix: _timePriorityError
                          //     ? const Icon(Icons.error)
                          //     : const Icon(Icons.check),
                        ),
                        // initialValue: 'Male',
                        // allowClear: true,
                        // hint: Text('Select Gender'),
                        // validator: FormBuilderValidators.compose(
                        //     [FormBuilderValidators.required(context)]),
                        items:
                        contactType.map((location) =>
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
                  // Location




                  // Select Time Priority

                  //Error Time Priority

                  // Select Contact Type

                  //Error Contact Type

                  // Accept Terms and Conditons
                  Container(
                    margin: EdgeInsets.all(8),
                    child: FormBuilderCheckbox(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
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
                      // validator: FormBuilderValidators.equal(
                      //   context,
                      //   true,
                      //   errorText:
                      //       'You must accept terms and conditions to continue',
                      // ),

                      // validator: FormBuilderValidators.equal(
                      //   context,
                      //   true,
                      //   errorText:
                      //       'You must accept terms and conditions to continue',
                      // ),
                    ),
                  ),
                  // Post Job Button
                  // Container(
                  //   margin: EdgeInsets.all(8),
                  //   child: Padding(
                  //     padding: const EdgeInsets.all(0.0),
                  //     child: Row(
                  //         mainAxisAlignment: MainAxisAlignment.start,
                  //         children: [
                  //           Container(
                  //             child: RaisedButton(
                  //               shape: RoundedRectangleBorder(
                  //                 borderRadius: BorderRadius.circular(18.0),
                  //               ),
                  //               elevation: 10,
                  //               textColor: Colors.white,
                  //               onPressed: () => {
                  //                 if (_titValError == false)
                  //                   {_addPost(_postTitle.text, _postDesc.text)}
                  //                 // _formKey.currentState.save(),
                  //                 // if (_formKey.currentState.validate())
                  //                 //   {
                  //                 // print(_formKey.currentState.value),
                  //                 // _addPost(_postTitle.text, _postDesc.text)
                  //                 //   }
                  //                 // else
                  //                 //   {
                  //                 //     print("validation failed"),
                  //                 //   }
                  //               },
                  //               color: mainOrange,
                  //               splashColor: mainBlue,
                  //               // padding: EdgeInsets.all(10.0),
                  //               child: Row(
                  //                 // Replace with a Row for horizontal icon + text
                  //                 children: <Widget>[
                  //                   Icon(Icons.add),
                  //                   Text("Post a Job")
                  //                 ],
                  //               ),
                  //             ),
                  //           ),
                  //         ]),
                  //   ),
                  // ),
                  // Center(
                  //   child: Text("$_start"),
                  // ),
                  Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                              child:
                                  // _start <= 9
                                  //     ? CircularProgressIndicator()
                                  //     :
                                  IsPosting
                                      ? CircularProgressIndicator()
                                      : !isPosted
                                          ? SliderButton(
                                              action: () {
                                                ///Do something here OnSlide
                                                print("Posting a Job");
                                                if (_titValError == false) {
                                                  // startTimer();
                                                  _addPost(_postTitle.text,
                                                      _postDesc.text);

                                                  Navigator.pushAndRemoveUntil(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          Layout(),
                                                    ),
                                                    (route) => false,
                                                  );
                                                }
                                              },

                                              ///Put label over here
                                              label: Text(
                                                "Slide to Post",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 17),
                                              ),
                                              icon: Center(
                                                  child: Icon(
                                                Icons.add,
                                                color: mainOrange,
                                                size: 40.0,
                                                semanticLabel:
                                                    'Text to announce in accessibility modes',
                                              )),

                                              //Put BoxShadow here
                                              boxShadow: BoxShadow(
                                                color: Colors.transparent
                                                    .withOpacity(.6),
                                                blurRadius: 1,
                                              ),

                                              //Adjust effects such as shimmer and flag vibration here
                                              shimmer: true,
                                              vibrationFlag: false,
                                              // dismissThresholds: 2.0,
                                              dismissible:
                                                  isPosted ? true : false,
                                              alignLabel: Alignment(0.0, 0),

                                              ///Change All the color and size from here.
                                              width: 300,
                                              radius: 20,
                                              buttonColor:
                                                  Colors.white.withOpacity(0.8),
                                              // buttonColor: Colors.transparent,
                                              backgroundColor: mainOrange,
                                              highlightedColor: mainBlue,
                                              baseColor: Colors.white,
                                            )
                                          : Container()),
                          isPosted
                              ? Container(
                                  height: 70,
                                  width: 300,
                                  decoration: BoxDecoration(
                                      color: mainOrange,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Center(
                                            child: Icon(
                                          Icons.check_circle,
                                          color: Colors.white,
                                          size: 25.0,
                                          semanticLabel:
                                              'Text to announce in accessibility modes',
                                        )),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Center(
                                            child: Text(
                                          "Posted Successfully",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 17),
                                        )),
                                      ]),
                                )
                              : Container(),
                          SizedBox(
                            height: 30,
                          ),
                        ]),
                  ),

                  SizedBox(
                    height: 80,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    ));
  }
}
