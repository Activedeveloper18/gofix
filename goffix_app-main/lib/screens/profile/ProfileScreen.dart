// import 'dart:convert';
// import 'dart:typed_data';
// import 'dart:ui';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:goffix/constants.dart';
// import 'package:goffix/models/profile_posts_model.dart';
// import 'package:goffix/providers/db_provider.dart';
// import 'package:goffix/screens/home/components/popover_button.dart';
// import 'package:goffix/screens/login/login.dart';
// import 'package:goffix/screens/message/msg_body.dart';
// import 'package:goffix/screens/settings/settings.dart';
// import 'package:http/http.dart' as http;
//
//
// import 'package:url_launcher/url_launcher.dart';
//
// class ProfileScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<ProfileScreen> {
//    Map? userDetails;
//    Map? userWork;
//    List? listOfPostsProfile;
//    List? listOfActivty;
//    List? chkOff;
//    Widget? star;
//   var rating = 0.0;
//    int? uid;
//    String? token;
//   Future _chckOffline() async {
//     // List temp = DBProvider.db.getAllEmployees() as List;
//
//     // if (DBProvider.db.getAllEmployees() == null) {
//     //   _getPosts();
//     // }
//     DBProvider.db.getAllProfilePosts().then((chkOff) {
//       print(chkOff);
//       if (chkOff == null) {
//         _getPosts();
//       }
//     });
//   }
//
//   Future<dynamic> param() async {
//     int? _uid = await User().getUID();
//     String? _token = await User().getToken();
//     setState(() {
//       uid = _uid!;
//       token = _token!;
//     });
//   }
//
//   Future<dynamic> _callClick(pid, fxid, fdid, _uid, phn) async {
//     String? token = await User().getToken();
//     int? uid = await User().getUID();
//     if (fdid == fxid) {
//       print("Sorry it's your Post");
//     } else {
//       var requestBody = {
//         "service_name": "addCall",
//         "param": {
//           "pc_body": "Call was initiated",
//           "pc_pid": pid,
//           "pc_fxid": fxid,
//           "pc_fdid": fdid,
//           "uid": uid
//         }
//       };
//       print(requestBody);
//       var jsonRequest = json.encode(requestBody);
//       print(jsonRequest);
//       var response = await http.post(baseUrl,
//           headers: {
//             'Accept': 'application/json',
//             'Authorization': 'Bearer $token',
//           },
//           body: jsonRequest);
//       var jsonResponse = null;
//       if (response.statusCode == 200) {
//         jsonResponse = json.decode(response.body);
//         if (jsonResponse["response"]["status"] == 200) {
//           String Phn = "tel:+91" + phn;
//           launch(Phn.toString());
//         }
//       } else if (jsonResponse["response"]["status"] == 108) {
//         print("Sorry Couldn't Call");
//       } else {
//         print("Something Went Wrong");
//       }
//     }
//   }
//
//   //
// //_msgClick
//   Future<dynamic> _msgClick(fdid, uid, pid, uimg, unm) async {
//     String? token = await User().getToken();
//     int? uid = await User().getUID();
//     if (uid != fdid) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (context) =>
//               // HomeScreen(uid: uid, username: username),
//               MessageScreen(
//                   uid: uid!,
//                   fdid: fdid,
//                   pid: pid,
//                   userimage: uimg,
//                   username: unm),
//         ),
//       );
//     } else {
//       print("Its ur Post");
//     }
//   }
//
//   Future _getUserDetails() async {
//     int? uid = await User().getUID();
//     String? token = await User().getToken();
//     var requestBody = {
//       "service_name": "userProfileInfo",
//       "param": {"uid": uid, "utype": "1"}
//     };
//     var jsonRequest = json.encode(requestBody);
//     print(jsonRequest);
//     var response = await http.post(baseUrl,
//         headers: {
//           'Accept': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//         body: jsonRequest);
//     var jsonResponse = null;
//     if (response.statusCode == 200) {
//       jsonResponse = json.decode(response.body);
//       if (jsonResponse["response"]["status"] == 200) {
//         setState(() {
//           userDetails = jsonResponse['response']['result']['data']['profile'];
//           userWork = jsonResponse['response']['result']['data']
//               ['user_jobs_works_rating'];
//           rating = double.parse(userWork!['rating']);
//         });
//       } else if (jsonResponse["response"]["status"] == 108) {
//         // _showMyDialog("Error", "Username/Password not found", "login");
//         print("Users not found");
//       } else {
//         print("Something Went Wrong");
//       }
//     }
//   }
//
//   Future<dynamic> _getPosts() async {
//     int fxid = 25;
//     int? _uid = await User().getUID();
//     // int fxid = _uid;
//     String? _token = await User().getToken();
//     var requestBody = {
//       "service_name": "getUserPostedJobsByID",
//       "param": {
//         "sessionid": fxid,
//         "uid": _uid,
//         "startPost": "0",
//         "limitPost": "100"
//       }
//     };
//     var jsonRequest = json.encode(requestBody);
//     print(jsonRequest);
//     var response = await http.post(baseUrl,
//         headers: {
//           'Accept': 'application/json',
//           'Authorization': 'Bearer $_token',
//         },
//         body: jsonRequest);
//     var jsonResponse = null;
//     if (response.statusCode == 200) {
//       jsonResponse = json.decode(response.body);
//       if (jsonResponse["response"]["status"] == 200) {
//         setState(() {
//           listOfPostsProfile = jsonResponse['response']['result']['data'];
//         });
//         // DBProvider.db.deleteAllProfilePosts();
//         return (listOfPostsProfile as List).map((posts) {
//           print('Inserting $posts');
//           DBProvider.db.createProfilePosts(UserProfilePosts.fromJson(posts));
//         }).toList();
//
//         await Future.delayed(const Duration(seconds: 2));
//         // return listOfPostsProfile;
//       } else if (jsonResponse["response"]["status"] == 108) {
//         // _showMyDialog("Error", "Username/Password not found", "login");
//         print("No Message found");
//       } else {
//         print("Something Went Wrong");
//       }
//     }
//     // return null;
//   }
//
//   Future _getUserActivity() async {
//     int? uid = await User().getUID();
//     String? token = await User().getToken();
//     var requestBody = {
//       "service_name": "getPostedJobsActivitiesfromuid",
//       "param": {"uid": uid, "utyp": 1, "startPost": 0, "limitPost": 100}
//     };
//     var jsonRequest = json.encode(requestBody);
//     print(jsonRequest);
//     var response = await http.post(baseUrl,
//         headers: {
//           'Accept': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//         body: jsonRequest);
//     var jsonResponse = null;
//     if (response.statusCode == 200) {
//       jsonResponse = json.decode(response.body);
//       if (jsonResponse["response"]["status"] == 200) {
//         setState(() {
//           listOfActivty = jsonResponse['response']['result']['data'];
//         });
//       } else if (jsonResponse["response"]["status"] == 108) {
//         // _showMyDialog("Error", "Username/Password not found", "login");
//         print("Users not found");
//       } else {
//         print("Something Went Wrong");
//       }
//     }
//   }
//
//   image_64(String _img64) {
//     if (_img64 != null) {
//       List img = _img64.split(",");
//       Uint8List _bytesImage;
//       _bytesImage = Base64Decoder().convert(img[1]);
//       return _bytesImage;
//     }
//   }
//
//   late ScrollController scrollController;
// // typedef double GetOffsetMethod();
//
//   @override
//   void initState() {
//     super.initState();
//     this._getUserDetails();
//     // this._getPosts();
//     this.param();
//     this._getUserActivity();
//     this._chckOffline();
//   }
//
//   late TabController _controller;
//   late ScrollController _scrollController;
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//
//     return new Scaffold(
//       extendBodyBehindAppBar: true,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         bottomOpacity: 0.8,
//         toolbarHeight: 60,
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             GestureDetector(
//               onTap: () {
//                 print("testProfile");
//               },
//               child: Text(
//                 "Profile",
//                 style: TextStyle(
//                     fontFamily: "Lato",
//                     color: Colors.white,
//                     fontSize: 30,
//                     fontWeight: FontWeight.bold),
//               ),
//             ),
//             GestureDetector(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) =>
//                         // HomeScreen(uid: uid, username: username),
//                         SettingsScreen(),
//                   ),
//                 );
//                 print("test");
//               },
//               child: Image.asset("assets/icons/nav.png"),
//             )
//           ],
//         ),
//       ),
//       body: Stack(
//         fit: StackFit.expand,
//         children: [
//           Column(
//             children: [
//               Container(
//                 height: size.height * .70,
//                 // width: 350,
//                 decoration: BoxDecoration(
//                   image: DecorationImage(
//                     image: AssetImage("assets/images/bg.png"),
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 child: BackdropFilter(
//                   filter: ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0),
//                   child: Container(
//                     color: Color(0xFF241331).withOpacity(.7),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           Container(
//             child: Padding(
//               padding: EdgeInsets.only(top: 100, left: 10, right: 10),
//               child: Column(
//                 // mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   Padding(
//                     padding: const EdgeInsets.only(left: 10, right: 10),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: <Widget>[],
//                     ),
//                   ),
//                   SizedBox(
//                     height: 20,
//                   ),
//                   userDetails == null || userWork == null
//                       ? Center(
//                           child: CircularProgressIndicator(),
//                         )
//                       : Stack(children: [
//                           Padding(
//                             padding: const EdgeInsets.only(top: 30),
//                             child: Container(
//                               // height: 310,
//                               decoration: BoxDecoration(
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Colors.black.withOpacity(0.1),
//                                       blurRadius: 30.0, // soften the shadow
//                                       spreadRadius: 3, //extend the shadow
//                                       offset: Offset(
//                                         0.0, // Move to right 10  horizontally
//                                         0.0, // Move to bottom 10 Vertically
//                                       ),
//                                     ),
//                                   ],
//                                   color: Colors.white,
//                                   borderRadius: BorderRadius.circular(40)),
//                               child: Container(
//                                 child: Column(
//                                   children: <Widget>[
//                                     // Header
//                                     Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.center,
//                                       children: <Widget>[
//                                         // Stack(
//                                         //   children: [
//
//                                         Padding(
//                                           padding: const EdgeInsets.only(
//                                               left: 0, top: 50),
//                                           child: Column(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.center,
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.center,
//                                             children: [
//                                               Text(
//                                                 userDetails!['u_nm'],
//                                                 style: TextStyle(
//                                                     color: mainBlue,
//                                                     fontSize: 22,
//                                                     // fontFamily: "Titillium Web",
//                                                     fontFamily: "Lato",
//                                                     fontWeight:
//                                                         FontWeight.bold),
//                                               ),
//                                               Text(
//                                                 userDetails!['cat_name'],
//                                                 style: TextStyle(
//                                                     color: Colors.grey[600],
//                                                     fontSize: 16,
//                                                     // fontFamily: "Titillium Web",
//                                                     fontFamily: "Lato",
//                                                     fontWeight:
//                                                         FontWeight.bold),
//                                               ),
//                                             ],
//                                           ),
//                                         )
//                                         //   ],
//                                         // ),
//                                       ],
//                                     ),
//                                     // SizedBox(
//                                     //   height: 10,
//                                     // ),
//
//                                     Divider(
//                                       color: Colors.grey,
//                                     ),
//
//                                     // Body
//                                     Padding(
//                                       padding: const EdgeInsets.only(
//                                           top: 10, left: 10, right: 10),
//                                       child: Container(
//                                         child: Column(
//                                           children: <Widget>[
//                                             Text(
//                                               userDetails!['u_desc'],
//                                               // Feel free to post get Status of your post. \n I Love Goffix
//                                               style: TextStyle(
//                                                   color: Colors.black,
//                                                   fontFamily: "Lato",
//                                                   // fontWeight: FontWeight.bold,
//                                                   fontSize: 15),
//                                             ),
//                                             SizedBox(
//                                               height: 5,
//                                             ),
//                                             Container(
//                                               padding:
//                                                   const EdgeInsets.fromLTRB(
//                                                       10, 3, 10, 3),
//                                               decoration: BoxDecoration(
//                                                   borderRadius:
//                                                       BorderRadius.circular(20),
//                                                   border: Border.all(
//                                                       color: mainBlue)),
//                                               child: Text(
//                                                 userDetails!['us_typ'] == 1
//                                                     ? "Fixer"
//                                                     : "Finder",
//                                                 style: TextStyle(
//                                                     color: mainBlue,
//                                                     fontSize: 15),
//                                               ),
//                                             ),
//                                             SizedBox(
//                                               height: 10,
//                                             ),
//                                             // Container(
//                                             //     child: SmoothStarRating(
//                                             //   // color: Colors.yellow,
//                                             //   color: mainOrange,
//                                             //   borderColor: mainOrange,
//                                             //   rating: rating,
//                                             //   size: 45,
//                                             //   starCount: 5,
//                                             // ))
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       height: 5,
//                                     ),
//
//                                     Divider(color: Colors.grey),
//                                     SizedBox(
//                                       height: 10,
//                                     ),
//                                     // Footer
//                                     Padding(
//                                       padding:
//                                           const EdgeInsets.only(bottom: 20),
//                                       child: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceEvenly,
//                                         children: [
//                                           SizedBox(width: 5),
//                                           Text(
//                                             userWork!['jobs'] + ' Jobs Done',
//                                             style: TextStyle(
//                                                 color: Colors.black,
//                                                 fontFamily: "Lato",
//                                                 // fontWeight: FontWeight.bold,
//                                                 fontSize: 15),
//                                           ),
//                                           SizedBox(width: 5),
//                                           Text("|"),
//                                           SizedBox(width: 5),
//                                           Text(
//                                             userWork!['works'] + " Posts",
//                                             style: TextStyle(
//                                                 color: Colors.black,
//                                                 fontFamily: "Lato",
//                                                 // fontWeight: FontWeight.bold,
//                                                 fontSize: 15),
//                                           ),
//                                           SizedBox(width: 5),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Center(
//                             child: Positioned(
//                               top: 10,
//                               child: ClipRRect(
//                                 borderRadius: BorderRadius.circular(100),
//                                 child: userDetails!['u_img'] == null
//                                     ? Image.asset(
//                                         'assets/images/male.png',
//                                         height: 70,
//                                       )
//                                     : userDetails!['u_img'] ==
//                                             ("file:///android_asset/www/images/male.png")
//                                         ? Image.asset(
//                                             'assets/images/male.png',
//                                             height: 70,
//                                           )
//                                         : Image.memory(
//                                             image_64(userDetails!['u_img']),
//                                             height: 80,
//                                           ),
//                               ),
//                             ),
//                           ),
//                         ]),
//
//                   // Row(children: <Widget>[
//                   //   Text("Good Morning "),
//                   // ]),
//                 ],
//               ),
//             ),
//           ),
//           SingleChildScrollView(
//             child: Padding(
//               padding:
//                   EdgeInsets.only(left: 0.0, right: 0.0, top: size.width * 1.2),
//               child: Column(
//                 children: <Widget>[
//                   Container(
//                     padding: EdgeInsets.only(left: 0.0, right: 0.0),
//                     width: double.infinity,
//                     // height: double.infinity,
//                     height: 2000,
//                     decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.only(
//                             topLeft: Radius.circular(60.0),
//                             topRight: Radius.circular(60.0)),
//                         boxShadow: [
//                           BoxShadow(
//                               color: Colors.black12,
//                               offset: Offset(0.0, -10.0),
//                               blurRadius: 10.0)
//                         ]),
//                     child: Padding(
//                       padding:
//                           const EdgeInsets.only(top: 30, left: 10, right: 10),
//                       child: Container(
//                         child: DefaultTabController(
//                             length: 2, // length of tabs
//                             initialIndex: 0,
//                             child: Container(
//                               child: Column(
//                                   crossAxisAlignment:
//                                       CrossAxisAlignment.stretch,
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   children: <Widget>[
//                                     Container(
//                                       child: TabBar(
//                                         unselectedLabelColor: mainBlue,
//                                         indicatorSize:
//                                             TabBarIndicatorSize.label,
//                                         indicator: BoxDecoration(
//                                             borderRadius:
//                                                 BorderRadius.circular(50),
//                                             color: mainBlue,
//                                             boxShadow: [
//                                               BoxShadow(
//                                                 color: Color(0xFFAAAAAA)
//                                                     .withOpacity(0.8),
//                                                 blurRadius:
//                                                     10.0, // soften the shadow
//                                                 spreadRadius:
//                                                     1, //extend the shadow
//                                                 offset: Offset(
//                                                   0.0, // Move to right 10  horizontally
//                                                   5.0, // Move to bottom 10 Vertically
//                                                 ),
//                                               ),
//                                             ]),
//                                         tabs: [
//                                           Tab(
//                                             child: Container(
//                                               decoration: BoxDecoration(
//                                                   borderRadius:
//                                                       BorderRadius.circular(50),
//                                                   border: Border.all(
//                                                       color: mainBlue,
//                                                       width: 1)),
//                                               child: Align(
//                                                 alignment: Alignment.center,
//                                                 child: Text("Activty"),
//                                               ),
//                                             ),
//                                           ),
//                                           Tab(
//                                             child: Container(
//                                               decoration: BoxDecoration(
//                                                   borderRadius:
//                                                       BorderRadius.circular(50),
//                                                   border: Border.all(
//                                                       color: mainBlue,
//                                                       width: 1)),
//                                               child: Align(
//                                                 alignment: Alignment.center,
//                                                 child: Text("Posts"),
//                                               ),
//                                             ),
//                                           )
//                                           // Tab(text: 'Tab 3'),
//                                           // Tab(text: 'Tab 4'),
//                                         ],
//                                       ),
//                                     ),
//                                     Container(
//                                       child: Padding(
//                                         padding:
//                                             const EdgeInsets.only(top: 15.0),
//                                         child: Container(
//                                             // height: double.infinity,
//                                             // width: double.infinity,
//                                             //height of TabBarView
//                                             // decoration: BoxDecoration(
//                                             // border: Border(
//                                             //     top: BorderSide(
//                                             //         color: Colors.grey, width: 2.5))),
//                                             height: 2000,
//                                             child: TabBarView(
//                                                 children: <Widget>[
//                                                   //Activity
//                                                   SingleChildScrollView(
//                                                     child: Padding(
//                                                       padding:
//                                                           const EdgeInsets.only(
//                                                               left: 10,
//                                                               right: 10),
//                                                       child: Container(
//                                                           child: listOfActivty ==
//                                                                   null
//                                                               ? Center(
//                                                                   child:
//                                                                       CircularProgressIndicator(),
//                                                                 )
//                                                               : ListView
//                                                                   .builder(
//                                                                       shrinkWrap:
//                                                                           true,
//                                                                       physics:
//                                                                           NeverScrollableScrollPhysics(),
//                                                                       padding:
//                                                                           const EdgeInsets.all(
//                                                                               0),
//                                                                       // physics: NeverScrollableScrollPhysics(),
//                                                                       itemCount:
//                                                                           listOfActivty!
//                                                                               .length,
//                                                                       itemBuilder:
//                                                                           (context,
//                                                                               index) {
//                                                                         if (listOfActivty!
//                                                                             .isEmpty) {
//                                                                           return Center(
//                                                                             child:
//                                                                                 Text("No Activity"),
//                                                                           );
//                                                                         }
//                                                                         return jobCards(
//                                                                             listOfActivty![index]['u_img'],
//                                                                             listOfActivty![index]['u_nm'],
//                                                                             listOfActivty![index]['ps_dt'],
//                                                                             listOfActivty![index]['p_tit'],
//                                                                             listOfActivty![index]['cat_name'],
//                                                                             listOfActivty![index]['p_priority']);
// //  jobCards(String uimg, String unm, String loc, String dt, String tit,String catName, String priority)
//                                                                       })),
//                                                     ),
//                                                   ),
//                                                   //Posts
//                                                   Padding(
//                                                     padding:
//                                                         const EdgeInsets.only(
//                                                             left: 10,
//                                                             right: 10,
//                                                             bottom: 70),
//                                                     child: Column(children: [
//                                                       Container(
//                                                         // width: double.infinity,
//                                                         child:
//
//                                                             // Column(children: [
//                                                             Container(
//                                                                 child: listOfPostsProfile ==
//                                                                         null
//                                                                     ? Center(
//                                                                         child:
//                                                                             Container(
//                                                                           child:
//                                                                               Text("No Posts"),
//                                                                         ),
//                                                                       )
//                                                                     : _fetchPosts()
//                                                                 // ListView
//                                                                 //     .builder(
//                                                                 //         shrinkWrap:
//                                                                 //             true,
//                                                                 //         controller:
//                                                                 //             _scrollController,
//                                                                 //         padding: EdgeInsets.only(
//                                                                 //             top:
//                                                                 //                 15.0),
//                                                                 //         itemCount:
//                                                                 //             listOfPostsProfile
//                                                                 //                 .length,
//                                                                 //         physics:
//                                                                 //             NeverScrollableScrollPhysics(),
//                                                                 //         itemBuilder:
//                                                                 //             (BuildContext context,
//                                                                 //                 int index) {
//                                                                 //           return _postCards();
//                                                                 //         }),
//                                                                 ),
//                                                       ),
//                                                     ]),
//                                                   ),
//                                                 ])),
//                                       ),
//                                     )
//                                   ]),
//                             )),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
//
// //Activity
//   jobCards(String uimg, String unm, String dt, String tit, String catName,
//       String priority) {
//     if (priority == "0") {
//       priority = "One Day";
//     } else if (priority == "1") {
//       priority = "One Week";
//     } else if (priority == "2") {
//       priority = "One Month";
//     }
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 20),
//       child: Container(
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(25),
//             color: Colors.white,
//             boxShadow: [
//               BoxShadow(
//                 color: Color(0xFFAAAAAA).withOpacity(0.3),
//                 blurRadius: 40.0, // soften the shadow
//                 spreadRadius: 3, //extend the shadow
//                 offset: Offset(
//                   0.0, // Move to right 10  horizontally
//                   30.0, // Move to bottom 10 Vertically
//                 ),
//               ),
//             ]),
//         // decoration: BoxDecoration(color: Colors.grey),
//         child: Padding(
//           padding:
//               const EdgeInsets.only(top: 15, left: 15, bottom: 15, right: 10),
//           child: Container(
//             child: Column(
//               children: <Widget>[
//                 // Header
//                 Row(
//                   children: <Widget>[
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(100),
//                       child: uimg == null
//                           ? Image.asset(
//                               'assets/images/profile.jpg',
//                               height: 70,
//                             )
//                           : Image.memory(
//                               image_64(uimg),
//                               // Image.asset(
//                               //   'assets/images/profile.jpg',
//                               height: 70,
//                               // ),
//                             ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(left: 10),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             unm,
//                             style: TextStyle(
//                                 color: Colors.grey.shade700,
//                                 fontSize: 20,
//                                 // fontFamily: "Titillium Web",
//                                 fontFamily: "Lato",
//                                 fontWeight: FontWeight.bold),
//                           ),
//                           Row(
//                             children: [
//                               Icon(
//                                 CupertinoIcons.placemark_fill,
//                                 size: 20,
//                                 color: mainBlue.withOpacity(0.8),
//                               ),
//                               Text("Vizag",
//                                   style: TextStyle(
//                                       color: mainBlue.withOpacity(0.5),
//                                       fontWeight: FontWeight.bold)),
//                             ],
//                           ),
//                           Text(
//                             dt,
//                             style:
//                                 TextStyle(color: Colors.grey.withOpacity(0.8)),
//                           ),
//                         ],
//                       ),
//                     )
//                   ],
//                 ),
//                 SizedBox(height: 10),
//                 Divider(color: Colors.grey),
//                 SizedBox(height: 10),
//                 // Body
//                 Container(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                       Text(
//                         tit,
//                         style: TextStyle(
//                             color: Colors.grey.shade800,
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold),
//                       ),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       Row(
//                         children: [
//                           Container(
//                             padding: const EdgeInsets.all(3.0),
//                             decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(10),
//                                 border: Border.all(color: mainBlue)),
//                             child: Text(
//                               catName,
//                               style: TextStyle(color: mainBlue, fontSize: 15),
//                             ),
//                           ),
//                           SizedBox(
//                             width: 10,
//                           ),
//                           Container(
//                             padding: const EdgeInsets.all(3.0),
//                             decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(20),
//                                 border: Border.all(color: mainBlue)),
//                             child: Text(
//                               priority,
//                               style: TextStyle(color: mainBlue, fontSize: 15),
//                             ),
//                           )
//                         ],
//                       ),
//                       // Padding(
//                       //   padding: const EdgeInsets.fromLTRB(0, 8.0, 8.0, 8.0),
//                       //   child: Container(
//                       //     alignment: Alignment.center,
//                       //     width: 140,
//                       //     child: RaisedButton(
//                       //       shape: RoundedRectangleBorder(
//                       //         borderRadius: BorderRadius.circular(18.0),
//                       //       ),
//                       //       elevation: 10,
//                       //       textColor: Colors.white,
//                       //       onPressed: () => {},
//                       //       color: mainOrange,
//                       //       splashColor: mainBlue,
//                       //       // padding: EdgeInsets.all(10.0),
//                       //       child: Row(
//                       //         // Replace with a Row for horizontal icon + text
//                       //         children: <Widget>[
//                       //           Icon(Icons.add),
//                       //           Text("Work Done")
//                       //         ],
//                       //       ),
//                       //     ),
//                       //   ),
//                       // )
//                     ],
//                   ),
//                 ),
//                 // SizedBox(
//                 //   height: 10,
//                 // ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
// //Posts
//
//   _fetchPosts() {
//     final FocusNode _focusNode = FocusNode();
//     var priority;
//     // var uid = await User().getUID();
//     // print(uid);
//     return FutureBuilder(
//       future: DBProvider.db.getAllProfilePosts(),
//       builder: (BuildContext context, AsyncSnapshot snapshot) {
//         if (!snapshot.hasData) {
//           // _getPosts();
//           return Center(
//             child: CircularProgressIndicator(),
//           );
//         } else {
//           return ListView.builder(
//             shrinkWrap: true,
//             physics: NeverScrollableScrollPhysics(),
//             itemCount: snapshot.data.length,
//             itemBuilder: (context, index) {
//               if (snapshot.data[index].pPriority == "0") {
//                 priority = "One Day";
//               } else if (snapshot.data[index].pPriority == "1") {
//                 priority = "One Week";
//               } else if (snapshot.data[index].pPriority == "2") {
//                 priority = "One Month";
//               }
//               return Container(
//                 child: Padding(
//                   padding: const EdgeInsets.only(bottom: 20),
//                   child: Container(
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(35),
//                         color: Colors.white,
//                         boxShadow: [
//                           BoxShadow(
//                             color: Color(0xFFAAAAAA).withOpacity(0.3),
//                             blurRadius: 40.0, // soften the shadow
//                             spreadRadius: 3, //extend the shadow
//                             offset: Offset(
//                               0.0, // Move to right 10  horizontally
//                               30.0, // Move to bottom 10 Vertically
//                             ),
//                           ),
//                         ]),
//                     // decoration: BoxDecoration(color: Colors.grey),
//                     child: Padding(
//                       padding: const EdgeInsets.only(
//                           top: 0, left: 15, bottom: 15, right: 10),
//                       child: Container(
//                         child: Column(
//                           children: <Widget>[
//                             // Header
//                             Row(
//                               children: <Widget>[
//                                 ClipRRect(
//                                   borderRadius: BorderRadius.circular(100),
//                                   child: snapshot.data[index].uImg == null
//                                       ? Image.asset(
//                                           'assets/images/profile.jpg',
//                                           height: 70,
//                                         )
//                                       : Image.memory(
//                                           image_64(snapshot.data[index].uImg),
//                                           // Image.asset(
//                                           //   'assets/images/profile.jpg',
//                                           height: 70,
//                                           // ),
//                                         ),
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.only(left: 10),
//                                   child: Column(
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         snapshot.data[index].uNm,
//                                         style: TextStyle(
//                                             color: Colors.grey.shade700,
//                                             fontSize: 20,
//                                             // fontFamily: "Titillium Web",
//                                             fontFamily: "Lato",
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                       Row(
//                                         children: [
//                                           Icon(
//                                             CupertinoIcons.placemark_fill,
//                                             size: 20,
//                                             color: mainBlue.withOpacity(0.8),
//                                           ),
//                                           Text(snapshot.data[index].locName,
//                                               style: TextStyle(
//                                                   color:
//                                                       mainBlue.withOpacity(0.5),
//                                                   fontWeight: FontWeight.bold)),
//                                         ],
//                                       ),
//                                       // Text(
//                                       //   // snapshot.data[index].pDt.toString(),
//                                       //   // TimeAgo.timeAgoSinceDate(
//                                       //   //     snapshot.data[index].pDt.toString()),
//                                       //   Jiffy(snapshot.data[index].pDt)
//                                       //       .fromNow(),
//                                       //   style: TextStyle(
//                                       //       color:
//                                       //           Colors.grey.withOpacity(0.8)),
//                                       // ),
//                                     ],
//                                   ),
//                                 )
//                               ],
//                             ),
//                             SizedBox(
//                               height: 10,
//                             ),
//
//                             Divider(
//                               color: Colors.grey,
//                             ),
//                             SizedBox(
//                               height: 10,
//                             ),
//                             // Body
//                             Container(
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: <Widget>[
//                                   Text(
//                                     snapshot.data[index].pTit +
//                                         '/' +
//                                         snapshot.data[index].pUid + //fdid
//                                         '/' +
//                                         uid.toString() +
//                                         '/' +
//                                         snapshot.data[index].pId,
//                                     style: TextStyle(
//                                         color: Colors.grey.shade800,
//                                         fontSize: 20,
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                   Text(
//                                     snapshot.data[index].pJd,
//                                     style: TextStyle(
//                                       color: Colors.grey.shade800,
//                                       fontSize: 18,
//
//                                       // fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     height: 10,
//                                   ),
//                                   Row(
//                                     children: [
//                                       Container(
//                                         padding: const EdgeInsets.all(3.0),
//                                         decoration: BoxDecoration(
//                                             borderRadius:
//                                                 BorderRadius.circular(20),
//                                             border:
//                                                 Border.all(color: mainBlue)),
//                                         child: Text(
//                                           snapshot.data[index].catName,
//                                           style: TextStyle(
//                                               color: mainBlue, fontSize: 15),
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         width: 10,
//                                       ),
//                                       Container(
//                                         padding: const EdgeInsets.all(3.0),
//                                         decoration: BoxDecoration(
//                                             borderRadius:
//                                                 BorderRadius.circular(20),
//                                             border:
//                                                 Border.all(color: mainBlue)),
//                                         child: Text(
//                                           priority,
//                                           style: TextStyle(
//                                               color: mainBlue, fontSize: 15),
//                                         ),
//                                       )
//                                     ],
//                                   )
//                                 ],
//                               ),
//                             ),
//                             SizedBox(
//                               height: 10,
//                             ),
//
//                             Divider(color: Colors.grey),
//                             SizedBox(
//                               height: 10,
//                             ),
//                             // Footer
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceAround,
//                               children: [
//                                 SimpleAccountMenu(
//                                   icons: [
//                                     Icon(Icons.call),
//                                     Icon(Icons.message),
//                                   ],
//                                   iconColor: Colors.white,
//                                   onChange: (index1) {
//                                     print(index1);
//                                     if (index1 == 0) {
//                                       _callClick(
//                                           snapshot.data[index].pId,
//                                           uid,
//                                           snapshot.data[index].pUid,
//                                           uid,
//                                           snapshot.data[index].uPhn);
//                                     } else {
//                                       _msgClick(
//                                           int.parse(snapshot.data[index].pUid),
//                                           uid,
//                                           int.parse(snapshot.data[index].pId),
//                                           snapshot.data[index].uImg,
//                                           snapshot.data[index].uNm);
//                                     }
//                                   },
//                                 ),
//                                 // SimpleAccountMenu(),
//                                 InkWell(
//                                   onTap: () {
//                                     var shareText = snapshot.data[index].pTit +
//                                         '\n' +
//                                         snapshot.data[index].pJd;
//                                     // Share.share(shareText);
//                                   },
//                                   child: Icon(
//                                     Icons.share_outlined,
//                                     size: 28,
//                                     color: mainBlue.withOpacity(0.5),
//                                   ),
//                                 ),
//                                 InkWell(
//                                   onTap: () {
//                                     print(snapshot.data[index].issaved);
//                                     // _savePost(snapshot.data[index].pId);
//                                   },
//                                   child: Icon(
//                                     snapshot.data[index].issaved == 0
//                                         ? CupertinoIcons.bookmark_fill
//                                         : CupertinoIcons.bookmark,
//                                     size: 28,
//                                     color: mainBlue.withOpacity(0.5),
//                                   ),
//                                 ),
//                                 Icon(
//                                   CupertinoIcons.info_circle,
//                                   size: 28,
//                                   color: mainBlue.withOpacity(0.5),
//                                 )
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               );
//             },
//           );
//         }
//       },
//     );
//   }
// }
