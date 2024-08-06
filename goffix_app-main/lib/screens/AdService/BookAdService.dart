import 'dart:convert';
import 'dart:typed_data';
// import 'package:form_builder_validators/form_builder_validators.dart';
// import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:goffix/models/location_model.dart';
import 'package:goffix/providers/location_provider.dart';
import 'package:goffix/screens/home/models/homePageModel.dart';
import 'package:goffix/screens/login/login.dart';
import 'package:goffix/screens/search/SearchScreen.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
// import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:roundcheckbox/roundcheckbox.dart';
import 'package:slider_button/slider_button.dart';

// import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter/cupertino.dart';
import '../../constants.dart';

class BookAdServiceScreen extends StatefulWidget {
  // final int cid;
  // final String username;
  // final String cname;
  // final int catid;
  // final String name;
  // final int phn;
  final int? a_id;
  HomeItem? aId;

  @override
  BookAdServiceScreen({Key? key, this.aId, this.a_id}) : super(key: key);
  _BookAdServiceScreenState createState() => _BookAdServiceScreenState();
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

class _BookAdServiceScreenState extends State<BookAdServiceScreen> {
  @override
  late List listOfFixers;
  // String Fixers = this.cname;
  bool _locValError = false;
  late int _locTextFeild;
  late List<locName> filteredLoc;
  late List listOfLoc;
  final TextEditingController _locationController = new TextEditingController();
  final TextEditingController _landmarkController = new TextEditingController();
  final TextEditingController _mobileController = new TextEditingController();
  final TextEditingController _DescController = new TextEditingController();
  late int _timePTextFeild;
  var Timings = ['9am - 1pm', '2pm - 9pm'];
  String finalDate = '';
  String finalMonth = '';
  String finalYear = '';
  bool isPosted = false;
  bool IsPosting = false;

  //validations
  bool _timingsError = false;
  bool _addValError = false;
  bool _mobValError = false;
  // bool _mobValLenError = false;

  String _selectedDate = '';
  String _dateCount = '';
  String _range = '';
  String _rangeCount = '';
  int isPrem = 0;
  late bool _isSelected;
  String userName = '';
  // String mobile = '';

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        _range =
            DateFormat('yyyy-MM-dd').format(args.value.startDate).toString() +
                ' - ' +
                DateFormat('yyyy-MM-dd')
                    .format(args.value.endDate ?? args.value.startDate)
                    .toString();
      } else if (args.value is DateTime) {
        _selectedDate = args.value.toString();
      } else if (args.value is List<DateTime>) {
        _dateCount = args.value.length.toString();
      } else {
        _rangeCount = args.value.length.toString();
      }
    });
    print(_selectedDate);
  }

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
            // listOfCat =
            //     parseCat(jsonResponse['response']['result']['categories']);
            listOfLoc =
                parseLoc(jsonResponse['response']['result']['locations']);
            // .cast<catName>();
          });
        }

        // print(listOfCat);
        // print(listOfLoc);
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

  static List<locName> parseLoc(responseBody) {
    return responseBody.map<locName>((json) => locName.fromJson(json)).toList();
  }

//Username and Mobile

  // Future<dynamic> _getUserName() async {
  //   String token = await User().getToken();
  //   int uid = await User().getUID();
  //   var requestBody = {
  //     "service_name": "userNm",
  //     "param": {"uid": uid}
  //   };
  //   var jsonRequest = json.encode(requestBody);
  //   print(jsonRequest);

  //   var response = await http.post(baseUrl,
  //       headers: {
  //         'Accept': 'application/json',
  //         'Authorization': 'Bearer $token',
  //       },
  //       body: jsonRequest);
  //   var jsonResponse = null;
  //   if (response.statusCode == 200) {
  //     jsonResponse = json.decode(response.body);
  //     if (jsonResponse["response"]["status"] == 200) {
  //       if (mounted) {
  //         setState(() {
  //           userName = jsonResponse['response']['result']['data']['u_nm'];
  //         });
  //       }
  //       print(userName);
  //     }
  //   } else {
  //     print("Something Went Wrong");
  //   }
  // }

  Future<dynamic> _bookAdService() async {
    // int cid = widget.catid;
    int? a_id = widget.a_id;
    // HomeItem a_id = widget.aId;

    String dt = DateTime.now().toString();
    if (this.mounted) {
      setState(() {
        IsPosting = true;
      });
    }
    if (_landmarkController.text == "") {
      if (this.mounted) {
        setState(() {
          _addValError = true;
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

    String? token = await User().getToken();
    int? uid = await User().getUID();
    int mbNo;
    if (_mobileController.text == null || _mobileController.text == "") {
      mbNo = 0;
    } else {
      mbNo = int.parse(_mobileController.text);
    }
    var requestBody = {
      "service_name": "bookadservice",
      "param": {
        "ba_uid": uid,
        "ba_aid": a_id,
        "ba_lid": _locTextFeild,
        "ba_Loc": _landmarkController.text,
        "ba_dt": dt,
        "ba_time": "0",
        "ba_phn": mbNo,
        "ba_desc": _DescController.text
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
        print("Success");
      } else {
        print("Post not posted");
      }
      // } else {
      //   if (mounted) {
      //     setState(() {
      //       _mobValError = true;
      //     });
      //   }
      // }
    }
  }

  _checkIsPosted() {
    if (_locTextFeild != null && _landmarkController.text != "") {
      if (this.mounted) {
        setState(() {
          IsPosting = false;
        });
      }
    }
  }

  _removeDataUrl(String url) {
    if (url != null) {
      List img = url.split(",");
      return img[1];
    }
  }

  image_64(String _img64) {
    if (_img64 != null) {
      // List img = _img64.split(",");
      Uint8List _bytesImage;
      _bytesImage = Base64Decoder().convert(_img64);
      // return Image.memory(_bytesImage);
      return _bytesImage;
    }
  }

  @override
  void initState() {
    super.initState();
    this._getCat();
    // this._getUserName();
    // this.getCurrentDate();
    // this._getLoc();
    // this._getFixers();
  }

  Widget build(BuildContext context) {
    // String Fixers = widget.cname;
    // String no = "+918019510486";
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: mainBlue, //change your color here
        ),
        elevation: 30,
        bottomOpacity: 0.8,
        toolbarHeight: 60,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              child: Center(
                child:
                    //  Text(
                    //   Fixers,
                    //   style: TextStyle(color: mainBlue),
                    // ),
                    Image.asset("assets/images/go_del.png", height: 60),
              ),
            )
          ],
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Container(
                  color: Colors.white,
                  width: double.infinity,
                  child: Center(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
                            width: MediaQuery.of(context).size.width,
                            height: double.parse(widget.aId!.atypeHeight!),
                            child: Image.memory(
                              image_64(_removeDataUrl(widget.aId!.aImg!)),
                              fit: BoxFit.fill,
                              // height: double.parse(i.atypeHeight),
                            ),
                          ),
                          // Calendar
                          // Padding(
                          //   padding: const EdgeInsets.all(8.0),
                          //   child: Container(
                          //     // height: 500,
                          //     decoration: BoxDecoration(
                          //         color: Colors.grey[300],
                          //         // border: Border.all(),
                          //         borderRadius: BorderRadius.circular(30)),
                          //     child: SfDateRangePicker(
                          //       headerStyle: DateRangePickerHeaderStyle(
                          //         textAlign: TextAlign.center,
                          //         textStyle: TextStyle(
                          //             fontFamily: "Lato",
                          //             fontSize: 20,
                          //             fontWeight: FontWeight.bold,
                          //             color: mainOrange),
                          //       ),
                          //       // confirmText: 'OK',
                          //       onSelectionChanged: _onSelectionChanged,
                          //       selectionColor: mainOrange,
                          //       selectionTextStyle: TextStyle(
                          //           fontFamily: "Lato",
                          //           fontSize: 20,
                          //           fontWeight: FontWeight.bold,
                          //           color: Colors.white),
                          //       rangeSelectionColor: mainOrange,
                          //       yearCellStyle: DateRangePickerYearCellStyle(
                          //         leadingDatesDecoration: BoxDecoration(
                          //             color: mainOrange,
                          //             border: Border.all(
                          //                 color: mainOrange, width: 1),
                          //             shape: BoxShape.circle),
                          //         todayCellDecoration: BoxDecoration(
                          //             // color: const Color(0xFFDFDFDF),
                          //             color: mainOrange,
                          //             border: Border.all(
                          //                 color: mainOrange, width: 5),
                          //             shape: BoxShape.rectangle),
                          //         todayTextStyle:
                          //             const TextStyle(color: Colors.purple),
                          //       ),
                          //       monthCellStyle: DateRangePickerMonthCellStyle(
                          //         todayCellDecoration: BoxDecoration(
                          //             // color: const Color(0xFFDFDFDF),
                          //             color: mainOrange,
                          //             border: Border.all(
                          //                 color: mainOrange, width: 5),
                          //             shape: BoxShape.circle),
                          //         todayTextStyle:
                          //             const TextStyle(color: Colors.black),
                          //       ),
                          //       selectionMode:
                          //           DateRangePickerSelectionMode.single,
                          //       minDate: DateTime(DateTime.now().year,
                          //           DateTime.now().month, DateTime.now().day),
                          //       maxDate: DateTime(
                          //           DateTime.now().year,
                          //           DateTime.now().month,
                          //           DateTime.now().day + 10),
                          //     ),
                          //   ),
                          // ),
                          // // // Timing
                          // Container(
                          //   decoration: BoxDecoration(
                          //       borderRadius: BorderRadius.circular(30.0),
                          //       border: _timingsError == true
                          //           ? Border.all(color: Colors.red, width: 1)
                          //           : Border.all(color: Colors.transparent),
                          //       color: Colors.grey[300]),
                          //   margin: EdgeInsets.all(8),
                          //   child: FormBuilderDropdown<String>(
                          //     // autovalidate: true,
                          //     name: 'Time',
                          //     decoration: InputDecoration(
                          //       border: InputBorder.none,
                          //       focusedBorder: OutlineInputBorder(
                          //           borderSide: BorderSide(
                          //               color: Colors.grey[300], width: 32.0),
                          //           borderRadius: BorderRadius.circular(25.0)),
                          //       contentPadding:
                          //           EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 10.0),
                          //       focusColor: Colors.green,
                          //       fillColor: Colors.grey,
                          //       labelText: 'Select Timings',
                          //       // suffix: !_timingsError
                          //       //     ? const Icon(Icons.error)
                          //       //     : const Icon(Icons.check),
                          //     ),
                          //     // initialValue: 'Male',
                          //     allowClear: true,
                          //     // hint: Text('Select Timings '),
                          //     // validator: FormBuilderValidators.compose(
                          //     //     [FormBuilderValidators.required(context)]),
                          //     items: Timings.map((gender) => DropdownMenuItem(
                          //           value: gender,
                          //           child: Text(gender),
                          //         )).toList(),
                          //     onChanged: (val) {
                          //       if (this.mounted) {
                          //         setState(() {
                          //           _timingsError = false;
                          //         });
                          //       }
                          //       print(val);
                          //       if (val == "9am - 1pm") {
                          //         if (this.mounted) {
                          //           setState(() {
                          //             _timePTextFeild = 0;
                          //           });
                          //         }
                          //       } else if (val == "2pm - 9pm") {
                          //         _timePTextFeild = 1;
                          //       }
                          //       _checkIsPosted();
                          //       // print(_conTypeTextFeild);
                          //       // setState(() {
                          //       //   _contactType = !_formKey
                          //       //       .currentState.fields['gender']
                          //       //       .validate();
                          //       // });
                          //     },
                          //   ),
                          // ),
                          // //Error timing
                          Container(
                            padding: EdgeInsets.only(left: 20),
                            child: _timingsError
                                ? Row(children: [
                                    Text(
                                      "Please Select Timing Type",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ])
                                : Row(),
                          ),
                          // Mobile Number
                          // Name
                          // Mobile Number
                          // Container(
                          //   child: Text("Hello",
                          //       style: TextStyle(
                          //           color: Colors.grey.shade400,
                          //           fontSize: 20,
                          //           fontFamily: "Titillium Web",
                          //           // fontFamily: "Lato",
                          //           fontWeight: FontWeight.bold)),
                          // ),

                          // Location
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.0),
                                border: _locValError == true
                                    ? Border.all(color: Colors.red, width: 1)
                                    : Border.all(color: Colors.transparent),
                                color: Colors.grey[300]),
                            margin: EdgeInsets.all(8),
                            child: TypeAheadFormField(
                              textFieldConfiguration: TextFieldConfiguration(
                                controller: _locationController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade300, width: 32.0),
                                      borderRadius:
                                          BorderRadius.circular(25.0)),
                                  contentPadding: EdgeInsets.fromLTRB(
                                      20.0, 15.0, 20.0, 10.0),
                                  focusColor: Colors.green,
                                  fillColor: Colors.grey,
                                  labelText: 'Location',
                                ),
                              ),
                              // name: 'Location',

                              // onChanged: _onChanged,
                              itemBuilder: (context,String country) {
                                return ListTile(
                                  title: Text(country),
                                );
                              },

                              // initialValue: '',
                              onSuggestionSelected: (String id) {
                                if (this.mounted) {
                                  setState(() {
                                    _locValError = false;
                                    _locationController.text = id;
                                  });
                                }
                                // print(id);
                                print(_locationController.text);
                                var lowercaseQuery = id.toLowerCase();
                                // filteredLoc = listOfLoc.where((country) {
                                //   return country.loc_name
                                //       .toLowerCase()
                                //       .contains(lowercaseQuery);
                                // }).toList();
                                print(_locTextFeild);
                                // print(filteredCat[0].cat_id);
                                if (this.mounted) {
                                  setState(() {
                                    _locTextFeild =
                                        int.parse(filteredLoc[0].loc_id!);
                                  });
                                }
                                print(_locTextFeild);
                                _checkIsPosted();
                              },
                              suggestionsCallback: (query) {
                                var locations = listOfLoc
                                    .map((loc) => "${loc.loc_name}")
                                    .toList(growable: false);
                                if (query.isNotEmpty) {
                                  var lowercaseQuery = query.toLowerCase();
                                  var loc = locations.where((country) {
                                    return country
                                        .toLowerCase()
                                        .contains(lowercaseQuery);
                                  }).toList(growable: false);
                                  if (loc.isEmpty) {
                                    if (this.mounted) {
                                      setState(() {
                                        _locValError = true;
                                      });
                                    }
                                    return loc;
                                  } else {
                                    if (this.mounted) {
                                      setState(() {
                                        _locValError = false;
                                      });
                                    }
                                    return loc;
                                  }
                                } else {
                                  return locations;
                                }
                              },
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 20),
                            child: Row(
                              children: [
                                Text(
                                  " If you didn't find your location or column is red \n please select vizag from dropdown",
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: Colors.grey),
                                )
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 20),
                            child: _locValError
                                ? Row(children: [
                                    Text(
                                      "Please Select Location",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ])
                                : Row(),
                          ),
                          // Address
                          Container(
                            height: 120,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.0),
                                border: _addValError == true
                                    ? Border.all(color: Colors.red, width: 1)
                                    : Border.all(color: Colors.transparent),
                                color: Colors.grey[300]),
                            margin: EdgeInsets.all(8),
                            child: FormBuilderTextField(
                              name: 'Desc',
                              onChanged: (String? val) {
                                if (val!.isNotEmpty) {
                                  if (this.mounted) {
                                    setState(() {
                                      _addValError = false;
                                    });
                                  }
                                }
                                _checkIsPosted();
                              },
                              controller: _landmarkController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade300, width: 32.0),
                                    borderRadius: BorderRadius.circular(25.0)),
                                contentPadding:
                                    EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 10.0),
                                focusColor: Colors.green,
                                fillColor: Colors.grey,
                                labelText: 'Enter Delivery Address',
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
                          // Address validation
                          Container(
                            padding: EdgeInsets.only(left: 20),
                            child: _addValError
                                ? Row(children: [
                                    Text(
                                      "Please enter Address",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ])
                                : Row(),
                          ),

                          // Description
                          Container(
                            height: 120,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.0),
                                border:
                                    // _descValError == true
                                    //     ? Border.all(color: Colors.red, width: 1)
                                    //     :
                                    Border.all(color: Colors.transparent),
                                color: Colors.grey[300]),
                            margin: EdgeInsets.all(8),
                            child: FormBuilderTextField(
                              name: 'Desc',
                              onChanged: (String? val) {
                                if (val!.isNotEmpty) {
                                  if (this.mounted) {
                                    // setState(() {
                                    //   _descValError = false;
                                    // });
                                  }
                                }
                              },
                              controller: _DescController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade300, width: 32.0),
                                    borderRadius: BorderRadius.circular(25.0)),
                                contentPadding:
                                    EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 10.0),
                                focusColor: Colors.green,
                                fillColor: Colors.grey,
                                labelText: 'Additional details, if any',
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
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.0),
                                border: _mobValError == true
                                    ? Border.all(color: Colors.red, width: 1)
                                    : Border.all(color: Colors.transparent),
                                color: Colors.grey[300]),
                            margin: EdgeInsets.all(8),
                            child: FormBuilderTextField(
                              // initialValue: "9515103611",
                              maxLength: 10,
                              onChanged: (String? val) {
                                // if (val.isNotEmpty) {
                                // if (val.length != 10) {
                                //   if (this.mounted) {
                                //     setState(() {
                                //       _mobValError = true;
                                //     });
                                //   }
                                // } else {
                                //   if (this.mounted)
                                //     setState(() {
                                //       _mobValError = false;
                                //     });
                                // }
                                _checkIsPosted();
                              },
                              // if (this.mounted) {
                              //   setState(() {
                              //     _mobValError = false;
                              //   });
                              // }
                              // },
                              name: 'Phone No',
                              controller: _mobileController,
                              decoration: InputDecoration(
                                counterText: "",
                                border: InputBorder.none,
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade300, width: 32.0),
                                    borderRadius: BorderRadius.circular(25.0)),
                                contentPadding:
                                    EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 10.0),
                                focusColor: Colors.green,
                                fillColor: Colors.grey,
                                labelText:
                                    'Enter Alternate Mobile No (optional)',
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 20),
                            child: _mobValError
                                ? Row(children: [
                                    Text(
                                      "Please enter valid Mobile No",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ])
                                : Row(),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  Icon(Icons.check_circle,
                                      size: 30, color: Colors.grey),
                                  Text(
                                    "Order \n Confirmed",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.grey),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  Icon(Icons.motorcycle,
                                      size: 30, color: Colors.grey),
                                  Text(
                                    "Started \n journey",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  Icon(CupertinoIcons.location_solid,
                                      size: 30, color: Colors.grey),
                                  Text(
                                    "Pro \n Reached",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.grey),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  Icon(Icons.money,
                                      size: 30, color: Colors.grey),
                                  Text(
                                    "Cash on \n Delivery",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.grey),
                                  )
                                ],
                              ),
                            ],
                          )),
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
                                                        print(
                                                            "Sliding Delivery");
                                                        // if (_titValError ==
                                                        //     false) {
                                                        //   // startTimer();
                                                        //   _addPost(
                                                        //       _postTitle.text,
                                                        //       _postDesc.text);
                                                        // }
                                                        _bookAdService();
                                                      },

                                                      ///Put label over here
                                                      label: Text(
                                                        "Slide to Book Delivery",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 16),
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
                                                        color: Colors
                                                            .transparent
                                                            .withOpacity(.6),
                                                        blurRadius: 10,
                                                      ),

                                                      //Adjust effects such as shimmer and flag vibration here
                                                      shimmer: true,
                                                      vibrationFlag: false,
                                                      // dismissThresholds: 2.0,
                                                      dismissible: isPosted
                                                          ? true
                                                          : false,
                                                      alignLabel:
                                                          Alignment(0.0, 0),

                                                      ///Change All the color and size from here.
                                                      width: 300,
                                                      radius: 20,
                                                      buttonColor: Colors.white
                                                          .withOpacity(0.8),
                                                      // buttonColor: Colors.transparent,
                                                      backgroundColor:
                                                          mainOrange,
                                                      highlightedColor:
                                                          mainBlue,
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
                                                  Radius.circular(30))),
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
                                                  "We are on our way...",
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
                        ]),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
