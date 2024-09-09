import 'dart:convert';
import 'dart:typed_data';

// import 'package:carousel_pro/carousel_pro.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:goffix/models/location_model.dart';
import 'package:goffix/providers/location_provider.dart';
import 'package:goffix/screens/login/login.dart';
import 'package:goffix/screens/search/SearchScreen.dart';
import 'package:horizontal_calendar/horizontal_calendar.dart';
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
import '../../models/bookingservicemodel.dart';
import '../../utils/const_list.dart';

List<BookingServiceModel> bookingServiceList = [];

class BookServiceScreen extends StatefulWidget {
  // final int cid;
  // final String username;
  final String? cname;
  final int? catid;
  @override
  const BookServiceScreen({Key? key, this.catid, this.cname}) : super(key: key);
  _BookServiceScreenState createState() => _BookServiceScreenState();
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

class _BookServiceScreenState extends State<BookServiceScreen> {
  @override
  late List listOfFixers;
  // String Fixers = this.cname;
  bool _locValError = false;
  late int _locTextFeild;
  late List<locName> filteredLoc;
  late List listOfLoc;
  final TextEditingController _locationController = new TextEditingController();
  final TextEditingController _nameController = new TextEditingController();
  final TextEditingController __addressController = new TextEditingController();
  final TextEditingController _mobileController = new TextEditingController();
  final TextEditingController _DescController = new TextEditingController();
  late int _timePTextFeild;
  var _location = ['Vizag', 'Vijayawada'];
  String finalDate = '';
  String finalMonth = '';
  String finalYear = '';
  bool isPosted = false;
  String? subService;
  bool IsPosting = false;
  DatePickerController _datePickerController = DatePickerController();
  late DateTime _selectedValue;

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

  static List<locName> parseLoc(responseBody) {
    return responseBody.map<locName>((json) => locName.fromJson(json)).toList();
  }

  Future<dynamic> _bookService() async {
    int cid = widget.catid!;
    if (this.mounted) {
      setState(() {
        IsPosting = true;
      });
    }
    // if (_landmarkController.text == "") {
    //   if (this.mounted) {
    //     setState(() {
    //       _addValError = true;
    //     });
    //   }
    // }
    // if (Desc == "") {
    //   if (this.mounted) {
    //     setState(() {
    //       // _descValError = true;
    //     });
    //   }
    // }
    // if (_mobileController.text == "") {
    //   if (this.mounted) {
    //     setState(() {
    //       _mobValError = true;
    //     });
    //   }
    // }
    // if (_mobileController.text.length != 10) {

    // }
    if (_locTextFeild == null) {
      if (this.mounted) {
        setState(() {
          _locValError = true;
        });
      }
    }
    // if (_conTypeTextFeild == null) {
    //   if (this.mounted) {
    //     setState(() {
    //       _ctypValError = true;
    //     });
    //   }
    // }
    if (_timePTextFeild == null) {
      if (this.mounted) {
        setState(() {
          _timingsError = true;
        });
      }
    }
    if (_selectedDate == '') {
      if (this.mounted) {
        setState(() {
          _selectedDate = new DateTime.now().toString();
        });
      }
    }
    print(_selectedDate);

    // if (_mobileController.text.length == 10) {
    // if (mounted) {
    //   setState(() {
    //     _mobValError = false;
    //   });
    // }
    //  _mobValLenError = false;
    String? token = await User().getToken();
    int? uid = await User().getUID();

    if (_mobileController.text == "") {
      _mobileController.text = "0";
    }

    var requestBody = {
      "service_name": "bookservice",
      "param": {
        "bs_uid": uid,
        "bs_cid": cid,
        "bs_lid": _locTextFeild,
        // "bs_Loc": _landmarkController.text,
        "bs_dt": _selectedDate,
        "bs_time": _timePTextFeild,
        "bs_phn": _mobileController.text,
        "bs_isPrem": isPrem,
        "bs_desc": _DescController.text,
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
    } else {
      if (mounted) {
        setState(() {
          _mobValError = true;
        });
      }
    }
    // }
  }

  // _checkIsPosted() {
  //   if (_timePTextFeild != null &&
  //       _locTextFeild != null &&
  //       _landmarkController.text != "") {
  //     if (this.mounted) {
  //       setState(() {
  //         IsPosting = false;
  //       });
  //     }
  //   }
  // }

  @override
  void initState() {
    super.initState();
    this._getCat();
    // this.getCurrentDate();
    // this._getLoc();
    // this._getFixers();
  }

  Widget build(BuildContext context) {
    String Fixers = widget.cname!;
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
                child: Text(
                  Fixers,
                  style: TextStyle(color: mainBlue),
                ),
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
              padding: const EdgeInsets.only(
                  top: 10.0, bottom: 20, left: 10, right: 10),
              child: Container(
                  width: double.infinity,
                  padding:
                      EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
                  color: Colors.white,
                  child: Column(children: [
                    SizedBox(
                      height: 100,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DatePicker(
                          DateTime.now(),
                          initialSelectedDate: DateTime.now(),
                          selectionColor: Color(0xff9596C9),
                          locale: "en_US",
                          selectedTextColor: Colors.white,
                          monthTextStyle: TextStyle(
                            color: Color(0xff7A7C7E),
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                          ),
                          dayTextStyle: TextStyle(
                            color: Color(0xff343739),
                            fontWeight: FontWeight.w400,
                            fontSize: 10,
                          ),
                          dateTextStyle: TextStyle(
                            color: Color(0xff343739),
                            fontWeight: FontWeight.w400,
                            fontSize: 20,
                          ),
                          daysCount: 365,
                          onDateChange: (date) {
                            // New date selected
                            setState(() {
                              _selectedValue = date;
                              DateTime dateTime = date;

                              // Format the month and date
                              String month =
                                  DateFormat('MMM').format(dateTime); // "SEP"
                              String day =
                                  DateFormat('dd').format(dateTime); // "09"
                              finalDate = day;
                              finalMonth = month;
                              print('Month: $month'); // Output: Month: SEP
                              print('Day: $day'); // Output: Day: 09
                              print("dsffd");
                              print(_selectedValue);
                            });
                          },
                        ),
                      ),
                    ),
                    // Text("Timings"),
                    // Container(
                    //   height: 70,
                    //   width: MediaQuery.of(context).size.width * 0.9,
                    //   // color: Colors.indigo,
                    //   child: Expanded(
                    //     child:GridView.builder(
                    //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    //         crossAxisCount: 3, // Number of items per row
                    //         crossAxisSpacing: 10.0, // Spacing between columns
                    //         mainAxisSpacing: 10.0,  // Spacing between rows
                    //         childAspectRatio: 2, // Ratio of width to height of each grid item
                    //       ),
                    //       itemCount: Timings.length,
                    //       itemBuilder: (context, index) {
                    //         return Padding(
                    //           padding: const EdgeInsets.all(8.0),
                    //           child: Container(
                    //             height: 50,
                    //             width: 20,
                    //             alignment: Alignment.center,
                    //             decoration: BoxDecoration(
                    //               border: Border.all(color: Colors.indigo),
                    //               borderRadius: BorderRadius.circular(5)
                    //             ),
                    //             child: Text(Timings[index]),
                    //           ),
                    //         );
                    //       },
                    //     )
                    //
                    //   ),
                    // ),

                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 50,
                            width: 80,
                            padding: const EdgeInsets.only(left: 10.0),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.indigo),
                                borderRadius: BorderRadius.circular(5)),
                            child: Text(Timings[0]),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 50,
                            width: 80,
                            padding: const EdgeInsets.only(left: 10.0),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.indigo),
                                borderRadius: BorderRadius.circular(5)),
                            child: Text(Timings[1]),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 50,
                            width: 80,
                            padding: const EdgeInsets.only(left: 10.0),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.indigo),
                                borderRadius: BorderRadius.circular(5)),
                            child: Text(Timings[2]),
                          ),
                        ), Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 50,
                            width: 80,
                            padding: const EdgeInsets.only(left: 10.0),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.indigo),
                                borderRadius: BorderRadius.circular(5)),
                            child: Text(Timings[3]),
                          ),
                        ),
                      ],
                    ),

                    //       HorizontalCalendar(
                    //
                    //       date: DateTime.now(),
                    //         initialDate: DateTime.now(),
                    //   textColor: Colors.black45,
                    //   backgroundColor: Colors.white,
                    //   selectedColor: Colors.blue,
                    //   locale:    Locale('en', ''),
                    //   showMonth:true,
                    //   onDateSelected: (date) {
                    //     print(date.toString());
                    //   },
                    // ),

                    // Calendar
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: Container(
                    //     height: 200,
                    //     decoration: BoxDecoration(
                    //         color: Colors.grey[300],
                    //         // color: Colors.white,
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
                    //       showNavigationArrow: true,
                    //       monthViewSettings:
                    //           DateRangePickerMonthViewSettings(
                    //               numberOfWeeksInView: 3),
                    //       // DateRangePickerView:,
                    //       // view: CalendarView.week,
                    //       onSelectionChanged: _onSelectionChanged,
                    //       selectionColor: mainOrange,
                    //       selectionTextStyle: TextStyle(
                    //           fontFamily: "Lato",
                    //           fontSize: 16,
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
                    //           DateTime.now().day + 30),
                    //     ),
                    //   ),
                    // ),
                    // Timing
                    // Container(
                    //   decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(10.0),
                    //       border: Border.all(
                    //           color: Colors.grey.shade500, width: 1),
                    //       color: Colors.white),
                    //   padding: EdgeInsets.symmetric(horizontal: 2),
                    //   child: FormBuilderDropdown<String>(
                    //     // autovalidate: true,
                    //     name: 'Timengs',
                    //     decoration: InputDecoration(
                    //       border: InputBorder.none,
                    //       focusedBorder: OutlineInputBorder(
                    //           borderSide:
                    //               BorderSide(color: Colors.white, width: 2.0),
                    //           borderRadius: BorderRadius.circular(10.0)),
                    //       contentPadding: EdgeInsets.only(left: 20.0),
                    //       focusColor: Colors.green,
                    //       fillColor: Colors.white,
                    //       hintText: 'Select Time',
                    //       // suffix: _timePriorityError
                    //       //     ? const Icon(Icons.error)
                    //       //     : const Icon(Icons.check),
                    //     ),
                    //     // initialValue: 'Male',
                    //     // allowClear: true,
                    //     // hint: Text('Select Gender'),
                    //     // validator: FormBuilderValidators.compose(
                    //     //     [FormBuilderValidators.required(context)]),
                    //     items: Timings.map((location) => DropdownMenuItem(
                    //           value: location,
                    //           child: Text(location),
                    //         )).toList(),
                    //     onChanged: (val) {
                    //       setState(() {
                    //         _locValError = false;
                    //       });
                    //       print(val);
                    //       if (val == "Male") {
                    //         setState(() {
                    //           _locTextFeild = 0;
                    //         });
                    //       } else if (val == "Female") {
                    //         setState(() {
                    //           _locTextFeild = 1;
                    //         });
                    //       }
                    //       print(_locTextFeild);
                    //     },
                    //   ),
                    // ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(color: Colors.black, width: 1),
                          color: Colors.white),
                      padding: EdgeInsets.symmetric(horizontal: 2),
                      child: FormBuilderDropdown<String>(
                        // autovalidate: true,
                        name: 'Location',
                        decoration: InputDecoration(
                          // isDense: true,   // isDense: true,
                          border: InputBorder.none,
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2.0),
                              borderRadius: BorderRadius.circular(10.0)),
                          contentPadding: EdgeInsets.only(left: 20.0),
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
                    //Error timing
                    SizedBox(
                      height: 20,
                    ),
                    // Location

                    new TextField(
                      controller: _nameController,
                      maxLines: 4,
                      decoration: InputDecoration(

                          // suffixIcon: Icon(CupertinoIcons.eye),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey.shade300, width: 1.0),
                              borderRadius: BorderRadius.circular(10.0)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey.shade300, width: 1.0),
                              borderRadius: BorderRadius.circular(10.0)),
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 10.0),
                          hintText: "Enter Address",
                          focusColor: Colors.green,
                          fillColor: Colors.grey),
                    ),
                    // Address
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.black),
                      ),
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: DropdownButton<String>(
                          value: subService, // Set the selected value here
                          borderRadius: BorderRadius.circular(10),
                          underline: SizedBox(),
                          isExpanded:
                              true, // Ensure dropdown takes the full width of the container
                          items: <String>[
                            'Service 1',
                            'Service 2',
                            'Service 3',
                            'Service 4',
                          ].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              print(newValue);
                              setState(() {
                                subService = newValue;
                              });
                            }
                          },
                        ),
                      ),
                    ),

                    10.verticalSpace,
                    // Address validation
                    new TextField(
                      controller: _nameController,
                      decoration: InputDecoration(

                          // suffixIcon: Icon(CupertinoIcons.eye),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey.shade300, width: 1.0),
                              borderRadius: BorderRadius.circular(10.0)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey.shade300, width: 1.0),
                              borderRadius: BorderRadius.circular(10.0)),
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 10.0),
                          hintText: "Enter Mobile No (optional)",
                          focusColor: Colors.green,
                          fillColor: Colors.grey),
                    ),

                    // Mobile Number

                    // Mobile Number validation
                    // Container(
                    //   padding: EdgeInsets.only(left: 20),
                    //   child: _mobValError
                    //       ? Row(children: [
                    //           Text(
                    //             "Please enter valid Mobile No",
                    //             style: TextStyle(color: Colors.red),
                    //           ),
                    //         ])
                    //       : Row(),
                    // ),
                    // Description
                    SizedBox(
                      height: 20,
                    ),
                    new TextField(
                      controller: _nameController,
                      maxLines: 4,
                      decoration: InputDecoration(

                          // suffixIcon: Icon(CupertinoIcons.eye),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey.shade300, width: 1.0),
                              borderRadius: BorderRadius.circular(10.0)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey.shade300, width: 1.0),
                              borderRadius: BorderRadius.circular(10.0)),
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 10.0),
                          hintText: "Additional Details",
                          focusColor: Colors.green,
                          fillColor: Colors.grey),
                    ),
                    // Description validation
                    // Container(
                    //   padding: EdgeInsets.only(left: 20),
                    //   child: _descValError
                    //       ? Row(children: [
                    //           Text(
                    //             "Please enter post Description",
                    //             style: TextStyle(color: Colors.red),
                    //           ),
                    //         ])
                    //       : Row(),
                    // ),

                    // date Picker
                    // Date Picker
                    Container(
                        padding: EdgeInsets.all(20),
                        child: Row(
                          children: [
                            RoundCheckBox(
                              size: 27,
                              onTap: (selected) {
                                print(selected);
                                selected! ? isPrem = 1 : isPrem = 0;
                                print(isPrem);
                                // setState(() {
                                //   _isSelected = selected;
                                // });
                                // print(_isSelected);
                              },
                              checkedWidget:
                                  Icon(Icons.check, color: Colors.white),
                              uncheckedWidget:
                                  Icon(Icons.check, color: Colors.white),
                              isChecked: false,
                              animationDuration: Duration(
                                seconds: 0,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Image.asset(
                              'assets/icons/premium_crown.png',
                              fit: BoxFit.contain,
                              height: 40,
                            )
                          ],
                        )),
                    // // Is premium
                    // // Accept Terms and Conditons
                    // Container(
                    //   margin: EdgeInsets.all(8),
                    //   child: FormBuilderCheckbox(
                    //     decoration: InputDecoration(
                    //       border: InputBorder.none,
                    //     ),
                    //     name: 'accept_terms',
                    //     initialValue: false,
                    //     // onChanged: _onChanged,
                    //     title: RichText(
                    //       text: TextSpan(
                    //         children: [
                    //           TextSpan(
                    //             text: 'Check for Premium Service ',
                    //             style: TextStyle(color: Colors.black),
                    //           ),
                    //           // TextSpan(
                    //           //   text: 'Terms and Conditions',
                    //           //   style: TextStyle(color: Colors.blue),
                    //           // ),
                    //         ],
                    //       ),
                    //     ),
                    //     // validator: FormBuilderValidators.equal(
                    //     //   context,
                    //     //   true,
                    //     //   errorText:
                    //     //       'You must accept terms and conditions to continue',
                    //     // ),

                    //     // validator: FormBuilderValidators.equal(
                    //     //   context,
                    //     //   true,
                    //     //   errorText:
                    //     //       'You must accept terms and conditions to continue',
                    //     // ),
                    //   ),
                    // ),
                    Container(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Icon(CupertinoIcons.calendar_badge_plus,
                                size: 30, color: Colors.grey),
                            Text(
                              "On Demand / \n Scheduled",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            Icon(
                                CupertinoIcons
                                    .person_crop_circle_badge_checkmark,
                                size: 30,
                                color: Colors.grey),
                            Text(
                              "Verified \n Partners",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            Icon(CupertinoIcons.checkmark_shield_fill,
                                size: 30, color: Colors.grey),
                            Text(
                              "Service \n Warranty",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            Icon(CupertinoIcons.tag_solid,
                                size: 30, color: Colors.grey),
                            Text(
                              "Transparent \n Pricing",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey),
                            )
                          ],
                        ),
                      ],
                    )),
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Text(
                        "* Our Partner will give you a detailed quote for any additional requirement. Work will commence on approval of cost",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    SizedBox(height: 20),
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
                                                action: () async {
                                                  ///Do something here OnSlide
                                                  print("Posting a Job");
                                                  // if (_titValError == false) {
                                                  //   // startTimer();
                                                  bookingServiceList.add(
                                                      BookingServiceModel(
                                                          servicetype:
                                                              widget.cname!,
                                                          date: finalDate,
                                                          month: finalMonth));
                                                  print(bookingServiceList);
                                                  isPosted = true;
                                                  setState(() {});
                                                  //   _addPost(
                                                  //       _postTitle.text,
                                                  //       _postDesc.text,
                                                  //       _professionController
                                                  //           .text,
                                                  //       _locationController.text);

                                                  // Navigator.pushAndRemoveUntil(
                                                  //   context,
                                                  //   MaterialPageRoute(
                                                  //     builder: (BuildContext
                                                  //             context) =>
                                                  //         Layout(),
                                                  //   ),
                                                  //   (route) => false,
                                                  // );
                                                  // }
                                                },

                                                ///Put label over here
                                                label: Text(
                                                  "Slide to Post",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w500,
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
                                                dismissThresholds: 0.0,
                                                dismissible:
                                                    isPosted ? true : false,
                                                alignLabel: Alignment(0.0, 0),

                                                ///Change All the color and size from here.
                                                width: 300,
                                                radius: 20,
                                                buttonColor: Colors.white
                                                    .withOpacity(0.8),
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
                  ])),
            ),
          ),
        ],
      ),
    );
  }
}
