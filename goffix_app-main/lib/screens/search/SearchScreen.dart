import 'dart:convert';
import 'dart:async';
import 'dart:io';
// import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:goffix/screens/login/login.dart';
import 'package:goffix/screens/search/BookService.dart';
import 'package:goffix/screens/search/BookingStatus.dart';
import 'package:goffix/screens/search/list_fixer_screen.dart';
import 'package:goffix/screens/search/searchResult.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../../constants.dart';
import '../../models/getbyprofessiontype.dart';
import '../CauroselDemo.dart';

class SearchScreen extends StatefulWidget {
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

class _HomeScreenState extends State<SearchScreen> {
  List? listOfUsers;
  bool _proValError = false;
  final TextEditingController _categoryController = new TextEditingController();
  List<catName>? listOfCat;
  List<catName>? filteredCat;
  int? _catTextFeild;
  String userName = "";
  String mobile = "";

  Future _getUsersCount() async {
    String? token = await User().getToken();
    var requestBody = {
      "service_name": "fixerCategoriesWithCountWise",
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
            listOfUsers = jsonResponse['response']['result']['data'];
          });
        }
        // return listOfUsers;
      } else if (jsonResponse["response"]["status"] == 108) {
        // _showMyDialog("Error", "Username/Password not found", "login");
        print("Users not found");
      } else {
        print("Something Went Wrong");
      }
    }
  }

  //
  // static List<catName> parseCat(responseBody) {
  //   return responseBody.map<catName>((json) => catName.fromJson(json)).toList();
  // }

  //Username and Mobile
  // Future<dynamic> getUserName() async {
  //   String token = await User().getToken();
  //   int uid = await User().getUID();
  //   var requestBody = {
  //     "service_name": "userNm",
  //     "param": {
  //       "uid": uid,
  //     }
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
  //       if (this.mounted) {
  //         setState(() {
  //           userName = jsonResponse['response']['result']['data']['u_nm'];
  //           mobile = jsonResponse['response']['result']['data']['u_phn'];
  //         });
  //       }
  //     } else if (jsonResponse["response"]["status"] == 108) {
  //       // _showMyDialog("Error", "Username/Password not found", "login");
  //       print("Something went wrong");
  //     } else {
  //       print("Something Went Wrong");
  //     }
  //   }
  //   // return null;
  // }

  @override
  void initState() {
    super.initState();
    this._getUsersCount();
    // this._getCat();
    // this.getUserName();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(

        backgroundColor: Colors.white,
        elevation: 30,
        bottomOpacity: 0.8,
        toolbarHeight: 60,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'assets/images/logo.png',
              fit: BoxFit.contain,
              height: 45,
            ),
          ],
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          SingleChildScrollView(
            child: SafeArea(
              // padding: const EdgeInsets.all(0.0),
              child: Container(
                width: double.infinity,
                // height: 2000.0,
                child: Column(
                  children: <Widget>[
                    //Search Text feild
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 20.0, top: 20, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        // crossAxisAlignment: CrossAxisAlignment.s,
                        children: [
                          Text(
                            "Book Service",
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
                                    builder: (context) =>
                                        BookingStatusScreen()),
                              );

                            },
                            child: Icon(
                              CupertinoIcons.calendar_today,
                              size: 30,
                              color: mainBlue,
                            ),
                          )
                        ],
                      ),
                    ),
                    // Proffession
                    // Padding(
                    //   padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                    //   child: Container(
                    //     decoration: BoxDecoration(
                    //         boxShadow: [
                    //           BoxShadow(
                    //             color: Color(0xFFAAAAAA).withOpacity(0.8),
                    //             blurRadius: 20.0, // soften the shadow
                    //             spreadRadius: 3, //extend the shadow
                    //             offset: Offset(
                    //               0.0, // Move to right 10  horizontally
                    //               10.0, // Move to bottom 10 Vertically
                    //             ),
                    //           ),
                    //         ],
                    //         borderRadius: BorderRadius.circular(5.0),
                    //         color: Colors.grey[300]),
                    //     margin: EdgeInsets.all(8),
                    //     child: TypeAheadFormField(
                    //       autovalidateMode: AutovalidateMode.disabled,
                    //       textFieldConfiguration: TextFieldConfiguration(
                    //         controller: _categoryController,
                    //         decoration: InputDecoration(
                    //           border: InputBorder.none,
                    //           focusedBorder: OutlineInputBorder(
                    //               borderSide: BorderSide(
                    //                   color: Colors.grey.shade300, width: 32.0),
                    //               borderRadius: BorderRadius.circular(5.0)),
                    //           contentPadding:
                    //               EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 8.0),
                    //           focusColor: Colors.green,
                    //           fillColor: Colors.grey,
                    //           labelText: 'Search',
                    //           prefixIcon: Icon(Icons.search),
                    //         ),
                    //       ),
                    //       // name: 'Profession',
                    //       // onChanged: _onChanged,
                    //       itemBuilder: (context,String country) {
                    //         return ListTile(
                    //           title: Text(country),
                    //         );
                    //       },
                    //       // controller: TextEditingController(text: ''),
                    //
                    //       // initialValue: '',
                    //       onSuggestionSelected: (String id) {
                    //         if (this.mounted) {
                    //           setState(() {
                    //             _proValError = false;
                    //           });
                    //         }
                    //         // print(id);
                    //         print(_categoryController.text);
                    //         var lowercaseQuery = id!;
                    //         filteredCat = listOfCat!.where((country) {
                    //           return country.cat_name!
                    //               .toLowerCase()
                    //               .contains(lowercaseQuery);
                    //         }).toList();
                    //         print(_catTextFeild);
                    //         // print(filteredCat[0].cat_id);
                    //         if (this.mounted) {
                    //           setState(() {
                    //             _catTextFeild =
                    //                 int.parse(filteredCat![0].cat_id!);
                    //           });
                    //         }
                    //         Navigator.push(
                    //           context,
                    //           MaterialPageRoute(
                    //               builder: (context) => SearchResultScreen(
                    //                     cid: _catTextFeild,
                    //                   )),
                    //         );
                    //         print(_catTextFeild);
                    //       },
                    //       suggestionsCallback: (query) {
                    //         var category = listOfCat!
                    //             .map((cat) => "${cat.cat_name}")
                    //             .toList(growable: false);
                    //         if (query.isNotEmpty) {
                    //           var lowercaseQuery = query.toLowerCase();
                    //           var filCat = category.where((country) {
                    //             return country
                    //                 .toLowerCase()
                    //                 .contains(lowercaseQuery);
                    //           }).toList(growable: false);
                    //           if (filCat.isEmpty) {
                    //             if (this.mounted) {
                    //               setState(() {
                    //                 _proValError = true;
                    //               });
                    //             }
                    //             print("empty $lowercaseQuery");
                    //             return filCat;
                    //           } else {
                    //             if (this.mounted) {
                    //               setState(() {
                    //                 _proValError = false;
                    //               });
                    //             }
                    //             return filCat;
                    //           }
                    //         } else {
                    //           return category;
                    //         }
                    //       },
                    //     ),
                    //   ),
                    // ),
                    SizedBox(
                      height: 10,
                    ),
                    //Suggestions
                    Container(
                      margin: EdgeInsets.only(left: 20),
                      decoration: BoxDecoration(
                          // s
                          ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "HOME MAINTAINCE",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Wrap(
                            runSpacing: 10,
                            // child: Row(
                            children: [
                              _SeachIcon(
                                  "assets/ser/ac.ico", "Ac Service", "166"),
                              _SeachIcon("assets/ser/Electrician.ico",
                                  "Electrician", "267"),

                              _SeachIcon("assets/ser/cctv.ico", "Cctv", "34"),
                              _SeachIcon(
                                  "assets/ser/painter.ico", "Painter", "4"),
                              _SeachIcon(
                                  "assets/ser/plumber.ico", "Plumber", "4"),
                              _SeachIcon("assets/ser/pest control.ico",
                                  "Pest Control", "4"),
                              _SeachIcon(
                                  "assets/ser/ceiling.ico", "Ceiling", "4"),
                              _SeachIcon("assets/ser/packers.ico",
                                  "Packers & Movers", "16"),

                              _SeachIcon(
                                  "assets/ser/welder.ico", "Fabricator", "3"),

                              _SeachIcon("assets/ser/renovation.ico",
                                  "Renovation", "2"),
                              _SeachIcon("assets/ser/interior designer.ico",
                                  "Interior Designer", "2"),
                              _SeachIcon("assets/ser/curtains.ico",
                                  "Curtains / Blinds", "2"),
                              // _SeachIcon(
                              //     "assets/ser/veg.ico", "Vegetables", "2"),
                            ],
                            // ),
                          ),
                          Container(
                            height: 1,
                            color: Colors.black,
                            margin: EdgeInsets.only(right: 20),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "HOME APPLIANCE REPAIR",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Wrap(
                            runSpacing: 10,
                            // child: Row(
                            children: [
                              _SeachIcon(
                                  "assets/ser/ac.ico", "Ac Service", "166"),

                              _SeachIcon("assets/ser/tv repair m.ico",
                                  "Tv Repair", "166"),

                              _SeachIcon("assets/ser/washing.ico",
                                  "Washing Machine", "1"),
                              _SeachIcon("assets/ser/water puri.ico",
                                  "Water Purifier", "2"),
                              _SeachIcon(
                                  "assets/ser/micro.ico", "Micro Oven", "2"),
                              _SeachIcon("assets/ser/stove repair.ico",
                                  "Gas Stove", "2"),

                              // _SeachIcon(
                              //     "assets/ser/veg.ico", "Vegetables", "2"),
                            ],
                            // ),
                          ),
                          Container(
                            height: 1,
                            color: Colors.black,
                            margin: EdgeInsets.only(right: 20),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "BEAUTY CARE",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Wrap(
                            runSpacing: 10,
                            // child: Row(
                            children: [
                              _SeachIcon(
                                  "assets/ser/make up.ico", "Make Up", "166"),

                              _SeachIcon("assets/ser/hair cutt.ico", "Hair Cut",
                                  "166"),

                              _SeachIcon("assets/ser/salon servicee.ico",
                                  "Saloon Service", "1"),
                              _SeachIcon("assets/ser/hair caree.ico",
                                  "Hair Care", "2"),
                              _SeachIcon("assets/ser/skin caree.ico",
                                  "Skin Care", "2"),
                              _SeachIcon(
                                  "assets/ser/spaa.ico", "Spa Service", "2"),

                              // _SeachIcon(
                              //     "assets/ser/veg.ico", "Vegetables", "2"),
                            ],
                            // ),
                          ),
                          Container(
                            height: 1,
                            color: Colors.black,
                            margin: EdgeInsets.only(right: 20),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "LAUNDRY SERVICE",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Wrap(
                            runSpacing: 10,
                            // child: Row(
                            children: [
                              _SeachIcon("assets/ser/wash & fold d.ico",
                                  "Wash & Fold", "166"),
                              _SeachIcon("assets/ser/wash & ironn.ico",
                                  "Wash & Iron", "166"),

                              _SeachIcon("assets/ser/steam ironn.ico",
                                  "Steam & Iron", "166"),
                              _SeachIcon("assets/ser/curtain wash.ico",
                                  "Curtain Wash", "166"),

                              _SeachIcon("assets/ser/dry cleaning.ico",
                                  "Dry Cleaning", "166"),

                              // _SeachIcon(
                              //     "assets/ser/veg.ico", "Vegetables", "2"),
                            ],
                            // ),
                          ),
                          Container(
                            height: 1,
                            color: Colors.black,
                            margin: EdgeInsets.only(right: 20),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "EVENTS & PARTIES",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Wrap(
                            runSpacing: 10,
                            // child: Row(
                            children: [
                              _SeachIcon("assets/ser/photographer.ico",
                                  "Photography", "166"),
                              _SeachIcon(
                                  "assets/ser/bouquet.ico", "Bouquet", "166"),

                              _SeachIcon("assets/ser/chef.ico", "Chef", "166"),
                              _SeachIcon("assets/ser/catering.ico",
                                  "Food Catering", "166"),

                              _SeachIcon("assets/ser/stage dec.ico",
                                  "Stage Decoration", "166"),

                              // _SeachIcon(
                              //     "assets/ser/veg.ico", "Vegetables", "2"),
                            ],
                            // ),
                          ),
                          Container(
                            height: 1,
                            color: Colors.black,
                            margin: EdgeInsets.only(right: 20),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "CLEANING SERVICES",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Wrap(
                            runSpacing: 10,
                            // child: Row(
                            children: [
                              _SeachIcon("assets/ser/deep cleaningg.ico",
                                  "Deep Cleaning", "166"),
                              _SeachIcon(
                                  "assets/ser/bath.ico", "Bathroom", "166"),

                              _SeachIcon(
                                  "assets/ser/kitchen.ico", "Kitchen", "166"),
                              _SeachIcon("assets/ser/sofaa.ico", "Sofa", "166"),

                              _SeachIcon("assets/ser/carpet clean.ico",
                                  "Carpet", "166"),
                              _SeachIcon(
                                  "assets/ser/tank.ico", "Water Tank", "166"),
                              _SeachIcon("assets/ser/home sanit.ico",
                                  "Home Sanitization", "166"),

                              // _SeachIcon(
                              //     "assets/ser/veg.ico", "Vegetables", "2"),
                            ],
                            // ),
                          ),
                          Container(
                            height: 1,
                            color: Colors.black,
                            margin: EdgeInsets.only(right: 20),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "ELECTRONICS REPAIR",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Wrap(
                            runSpacing: 10,
                            // child: Row(
                            children: [
                              _SeachIcon("assets/ser/mobile repair.ico",
                                  "Mobile Repair", "166"),
                              _SeachIcon("assets/ser/laptop ico.ico",
                                  "Laptop Repair", "166"),

                              _SeachIcon("assets/ser/desktop repr.ico",
                                  "Desktop Repair", "166"),
                              _SeachIcon("assets/ser/printr repair.ico",
                                  "Printer Repair", "166"),

                              // _SeachIcon(
                              //     "assets/ser/veg.ico", "Vegetables", "2"),
                            ],
                            // ),
                          ),
                          Container(
                            height: 1,
                            color: Colors.black,
                            margin: EdgeInsets.only(right: 20),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "DELIVERY SERVICE",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Wrap(
                            runSpacing: 10,
                            // child: Row(
                            children: [
                              _SeachIcon("assets/ser/packers.ico",
                                  "Packers & Movers", "166"),
                              _SeachIcon(
                                  "assets/ser/driver.ico", "Driver", "166"),

                              _SeachIcon("assets/ser/cake delivr.ico",
                                  "Cake Delivery", "166"),
                              _SeachIcon("assets/ser/taxi ser.ico",
                                  "Taxi Service", "166"),
                              _SeachIcon("assets/ser/bouq del.ico",
                                  "Bouquet Delivery", "166"),
                              _SeachIcon("assets/ser/pick up delivery.ico",
                                  "Pickup & Delivery", "166"),

                              // _SeachIcon(
                              //     "assets/ser/veg.ico", "Vegetables", "2"),
                            ],
                            // ),
                          ),
                          Container(
                            height: 1,
                            color: Colors.black,
                            margin: EdgeInsets.only(right: 20),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "HEALTH & FITNESS",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Wrap(
                            runSpacing: 10,
                            // child: Row(
                            children: [
                              _SeachIcon(
                                  "assets/ser/fitness.ico", "Fitness", "166"),
                              _SeachIcon("assets/ser/yogaa.ico", "Yoga", "166"),

                              _SeachIcon("assets/ser/physio.ico",
                                  "Physiotherapy", "166"),
                              _SeachIcon("assets/ser/parental care.ico",
                                  "Parental Care", "166"),

                              // _SeachIcon(
                              //     "assets/ser/veg.ico", "Vegetables", "2"),
                            ],
                            // ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(
                      height: 20,
                    ),
                    // Ads
                    // _searchAdd(size: size),
                    // CarouselWithIndicatorDemo(
                    //   Screen: "search",
                    // ),
                    // SizedBox(
                    //   height: 20,
                    // ),
                    // SizedBox(
                    //   height: 30,
                    // ),
                    // Image.asset(
                    //   'assets/images/Goffix_dail.png',
                    //   height: 80,
                    // ),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    // Container(
                    //   decoration: BoxDecoration(
                    //       border: Border(
                    //           top: BorderSide(
                    //               width: 1.0,
                    //               color: mainBlue.withOpacity(0.3)))),
                    //   child: listOfUsers == null
                    //       ?
                    //       // Center(
                    //       //     child: CircularProgressIndicator(),
                    //       //   )
                    //       Center(
                    //           // child: CircularProgressIndicator(),
                    //           child: Column(
                    //               // height: MediaQuery.of(context).size.height,
                    //               // width: MediaQuery.of(context).size.width,
                    //               // mainAxisAlignment: MainAxisAlignment.center,
                    //               crossAxisAlignment: CrossAxisAlignment.center,
                    //               children: [
                    //                 Image.asset("assets/images/page_load.gif",
                    //                     height: 50)
                    //               ]),
                    //         )
                    //       : ListView.builder(
                    //           shrinkWrap: true,
                    //           physics: NeverScrollableScrollPhysics(),
                    //           padding: const EdgeInsets.all(0),
                    //           // physics: NeverScrollableScrollPhysics(),
                    //           itemCount: listOfUsers!.length,
                    //           itemBuilder: (context, index) {
                    //             return _listCat(
                    //               name: listOfUsers![index]['cat_name'],
                    //               count: listOfUsers![index]['fixers_count'],
                    //               catid:
                    //                   int.parse(listOfUsers![index]['cat_id']),
                    //             );
                    //           },
                    //         ),
                    // ),
                    SizedBox(
                      height: 60,
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _SeachIcon(String img, String nm, String link) {
    return InkWell(
      onTap: () {
        // launch(link);
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //       builder: (context) =>
        //           BookServiceScreen(catid: int.parse(link), cname: nm)),
        // );
        print("cname  $nm");
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ListFixerScreen(
                professionType: "Engineer",
              )),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon(CupertinoIcons.paintbrush_fill, color: mainBlue),
            Image.asset(
              img,
              height: 70,
              width: 70,
            ),
            SizedBox(
              width: 60,
              child: Text(
                nm,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _fetchUsers() {
    return FutureBuilder(
        future: _getUsersCount(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return _listCat(
                  name: snapshot.data[index].cat_name,
                  count: snapshot.data[index].fixers_count,
                  catid: snapshot.data[index].cat_id,
                );
              },
            );
          }
        });
  }
}

class _listCat extends StatelessWidget {
  final String? name;
  final String? count;
  final int? catid;
  @override
  const _listCat({Key? key, this.name, this.count, this.catid})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SearchResultScreen(
                    cid: catid,
                  )),
        );
      },
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 1.0, color: mainBlue.withOpacity(0.3)),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  this.name!,
                  style: TextStyle(color: mainBlue, fontSize: 18),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          // border: Border.all(color: mainBlue),
                          color: mainBlue),
                      child: Text(
                        this.count!,
                        style: TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    ),
                    Icon(Icons.arrow_right)
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _searchAdd extends StatelessWidget {
  const _searchAdd({
    Key? key,
    @required this.size,
  }) : super(key: key);

  final Size? size;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color(0xFFAAAAAA),
              blurRadius: 30.0, // soften the shadow
              spreadRadius: 3, //extend the shadow
              offset: Offset(
                0.0, // Move to right 10  horizontally
                10.0, // Move to bottom 10 Vertically
              ),
            ),
          ],
        ),
        // child: SizedBox(
        //     height: size!.height * .30,
        //     width: size!.width,
        //     child: Carousel(
        //       images: [
        //         ExactAssetImage("assets/images/ad_1.png"),
        //         ExactAssetImage("assets/images/ad_2.png"),
        //         ExactAssetImage("assets/images/ad_3.png"),
        //         ExactAssetImage("assets/images/ad_4.png"),
        //         ExactAssetImage("assets/images/ad_5.png"),
        //       ],
        //       boxFit: BoxFit.fill,
        //       animationCurve: Curves.fastOutSlowIn,
        //       animationDuration: Duration(milliseconds: 1000),
        //       dotSize: 4.0,
        //       dotSpacing: 15.0,
        //       dotBgColor: Colors.transparent,
        //       indicatorBgPadding: 5.0,
        //       borderRadius: true,
        //       radius: Radius.circular(5),
        //     )),
      ),
    );
  }
}
