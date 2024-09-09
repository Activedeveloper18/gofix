import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:goffix/app.dart';
import 'package:goffix/constants.dart';
import 'package:goffix/models/profile_posts_model.dart';
import 'package:goffix/providers/db_provider.dart';
import 'package:goffix/screens/SizeConfig.dart';
import 'package:goffix/screens/home/components/popover_button.dart';
import 'package:goffix/screens/login/login.dart';
import 'package:goffix/screens/message/msg_body.dart';
import 'package:goffix/screens/profile/bookings.dart';
import 'package:goffix/screens/profile/tab3.dart';
import 'package:goffix/screens/settings/settings.dart';
import 'package:goffix/screens/signup/sign_in.dart';
import 'package:goffix/screens/welcome/welcome.dart';
import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
// import 'package:jiffy/jiffy.dart';
// import 'package:share/share.dart';
// import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/logincredentialsmodel.dart';
import '../settings/editProfile.dart';
import 'model/userprofilemodels.dart';

class FixerProfilePageScreen extends StatefulWidget {
  LoginCredentialsModel? usermodel;
  @override
   FixerProfilePageScreen({
    this.usermodel,
});
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<FixerProfilePageScreen>
    with TickerProviderStateMixin {
  Map? userWork;
  // List listOfPostsProfile;
  // List listOfActivty;
  List? chkOff;
  Widget? star;
  var rating = 0.0;
  int? uid;
  String? token;
  TabController? _tabController;
  image_64(String _img64) {
    if (_img64 != null) {
      List img = _img64.split(",");
      Uint8List _bytesImage;
      _bytesImage = Base64Decoder().convert(img[1]);
      return _bytesImage;
    }
  }

  // Future _getUserDetails() async {
  //   int? uid = await User().getUID();
  //   String? token = await User().getToken();
  //   var requestBody = {
  //     "service_name": "userProfileInfo",
  //     "param": {"uid": uid, "utype": "1"}
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
  //           userDetails = jsonResponse['response']['result']['data']['profile'];
  //           userWork = jsonResponse['response']['result']['data']
  //               ['user_jobs_works_rating'];
  //           rating = double.parse(userWork!['rating']);
  //         });
  //       }
  //     } else if (jsonResponse["response"]["status"] == 108) {
  //       // _showMyDialog("Error", "Username/Password not found", "login");
  //       print("Users not found");
  //     } else {
  //       print("Something Went Wrong");
  //     }
  //   }
  // }
  //
  // Future<dynamic> param() async {
  //   int? _uid = await User().getUID();
  //   String? _token = await User().getToken();
  //   if (this.mounted) {
  //     setState(() {
  //       uid = _uid!;
  //       token = _token!;
  //     });
  //   }
  // }

  // Future _chckOffline() async {
  //   // List temp = DBProvider.db.getAllEmployees() as List;

  //   // if (DBProvider.db.getAllEmployees() == null) {
  //   //   _getPosts();
  //   // }
  //   DBProvider.db.getAllProfilePosts().then((chkOff) {
  //     print(chkOff);
  //     if (chkOff == null) {
  //       _getPosts();
  //     }
  //   });
  // }
  UserProfileModel? userDetails;
  @override
  void initState() {
    super.initState();
    // this._getUserDetails();
    // // this._getPosts();
    // this.param();
    // this._getUserActivity();
    Map<String, dynamic> userdata = {
      "name": widget.usermodel?.usname ?? null,
      "email": widget.usermodel?.email ?? null,
      "mobileNumber": widget.usermodel?.phnumber ?? null,
      "typeEmployee": widget.usermodel?.ustype==1 ? "Finder" : "Fixer",
      "employeeID": "EMP123456",
      "employeeImage":
          "https://t3.ftcdn.net/jpg/02/43/12/34/240_F_243123463_zTooub557xEWABDLk0jJklDyLSGl2jrr.jpg"
    };
    userDetails = UserProfileModel.fromJson(userdata);

    _tabController = TabController(length: 2, vsync: this);
    // _tabController.addListener(_handleTabSelection);
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // SizeConfig().init(Constraints, Orientation);
    return Scaffold(
      backgroundColor: Color(0xffffff),
      // backgroundColor: Colors.transparent,
      // appBar: AppBar(
      //
      //   // bottomOpacity: 1,
      //
      //   //  ),
      //   backgroundColor: Colors.transparent,
      //   // elevation: 0.0,
      //   // bottomOpacity: 0.8,
      //   // backgroundColor: Colors.transparent,
      //   bottomOpacity: 0.0,
      //   elevation: 0.0,
      //   toolbarHeight: 60,
      //   title: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //     children: [
      //       GestureDetector(
      //         onTap: () {
      //           print("testProfile");
      //         },
      //         child: Text(
      //           "Profile",
      //           style: TextStyle(
      //               fontFamily: "Lato",
      //               color: Colors.white,
      //               fontSize: 30,
      //               fontWeight: FontWeight.bold),
      //         ),
      //       ),
      //       // GestureDetector(
      //       //   onTap: () {
      //       //     Navigator.push(
      //       //       context,
      //       //       MaterialPageRoute(
      //       //         builder: (context) =>
      //       //             // HomeScreen(uid: uid, username: username),
      //       //             SettingsScreen(),
      //       //       ),
      //       //     );
      //       //     print("test");
      //       //   },
      //       //   child: Image.asset("assets/icons/nav.png"),
      //       // )
      //     ],
      //   ),
      // ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            50.verticalSpace,
            Container(
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage("assets/images/profilebg.jpeg",),fit: BoxFit.fill),

                  color: mainBlue, borderRadius: BorderRadius.circular(10)),
              height: 280,
              // height: .4 * size.height,
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 10,bottom: 20),
                child: userDetails == null
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              // profile image
                              ClipRect(
                                child: Image.network(
                                  userDetails?.employeeImage ?? "",
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  height:
                                      MediaQuery.of(context).size.height * 0.15,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              18.horizontalSpace,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  15.verticalSpace,
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.40,
                                    child: Text(
                                      "${userDetails!.name.toString()}",
                                      maxLines: 1,
                                      style: TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          color: Colors.white,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.35,
                                    child: Text(
                                      "${userDetails!.email.toString()}",
                                      maxLines: 1,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        "${userDetails!.mobileNumber}",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "${userDetails!.employeeId}",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  ),
                                  5.verticalSpace,
                                  Row(
                                    children: <Widget>[
                                      SizedBox(
                                          // width: 20,
                                          ),
                                      Text(
                                        "${userDetails!.typeEmployee}",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                          10.verticalSpace,

                          // work details
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                          //   children: <Widget>[
                          //     Column(
                          //       children: <Widget>[
                          //         Text(
                          //          " userWork!['works']",
                          //           style: TextStyle(
                          //               color: Colors.white,
                          //               fontSize: 25,
                          //               fontWeight: FontWeight.bold),
                          //         ),
                          //         Text(
                          //           "Posts",
                          //           style: TextStyle(
                          //             color: Colors.white70,
                          //             fontSize: 15,
                          //           ),
                          //         ),
                          //       ],
                          //     ),
                          //     Column(
                          //       children: <Widget>[
                          //         Text(
                          //           "|",
                          //           style: TextStyle(
                          //             color: Colors.white70,
                          //             fontSize: 30,
                          //           ),
                          //         ),
                          //       ],
                          //     ),
                          //     Column(
                          //       children: <Widget>[
                          //         Text(
                          //           "userWork!['jobs']",
                          //           style: TextStyle(
                          //               color: Colors.white,
                          //               fontSize: 25,
                          //               fontWeight: FontWeight.bold),
                          //         ),
                          //         Text(
                          //           "Jobs",
                          //           style: TextStyle(
                          //             color: Colors.white70,
                          //             fontSize: 15,
                          //           ),
                          //         ),
                          //       ],
                          //     ),
                          //   ],
                          // ),

                          // Container(
                          //     child: SmoothStarRating(
                          //   // color: Colors.yellow,
                          //   color: mainOrange,
                          //   borderColor: mainOrange,
                          //   rating: rating,
                          //   size: 45,
                          //   starCount: 5,
                          // ))
                        ],
                      ),
              ),
            ),

            // TabPage(),
            // SettingsScreen()
            Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.95,
                  height: 350,
                  color: Colors.white,
                  padding: EdgeInsets.only(left: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Tasks ",
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(color: Colors.indigo),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // completed
                          Container(
                            height: 40,
                            width: 80,
                            // padding: EdgeInsets.all(),
                            decoration: BoxDecoration(
                                color: Colors.greenAccent.withOpacity(0.5),
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(50)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text("Completed",
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700)),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text("12",
                                        style: TextStyle(
                                            color: Colors.green,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700)),
                                    Icon(
                                      Icons.verified_sharp,
                                      color: Colors.green,
                                      size: 16,
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // in progress
                          Container(
                            height: 40,
                            width: 80,
                            // padding: EdgeInsets.all(),
                            decoration: BoxDecoration(
                                color: Colors.indigoAccent.shade100
                                    .withOpacity(0.5),
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(50)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text("In Progress",
                                    style: TextStyle(
                                        color: Colors.indigo,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700)),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text("12",
                                        style: TextStyle(
                                            color: Colors.indigo,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700)),
                                    Icon(
                                      Icons.verified_sharp,
                                      color: Colors.indigo,
                                      size: 16,
                                    )
                                  ],
                                ),
                               
                              ],
                            ),
                          ),
                          Container(
                            height: 40,
                            width: 80,
                            // padding: EdgeInsets.all(),
                            decoration: BoxDecoration(
                                color: Colors.deepOrangeAccent.withOpacity(0.4),
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(50)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text("Missed",
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700)),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text("12",
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700)),
                                    Icon(
                                      Icons.verified_sharp,
                                      color: Colors.red,
                                      size: 16,
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      // total earnings
                      Text(
                        "Total Earnings ",
                        style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Color(0xff0C45BE)),
                      ),
                      Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width * 0.85,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.deepPurpleAccent,
                              borderRadius: BorderRadius.circular(50)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "\u{20B9} 40000",
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium!
                                    .copyWith(color: Colors.white),
                              ),
                              // money
                              // SizedBox(
                              //   height: 50,
                              //   child: Image.asset("assets/images/moneylogo.png"),
                              // ),

                            ],
                          )),
                      Text(
                        "About ",
                        style: Theme.of(context)
                            .textTheme
                        .headlineSmall!
                            .copyWith(color: Color(0xff0C45BE),fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width*0.9,
                        child: Text(
                          "We’re best known for our public Q&A platform that millions of people visit every month to ask questions, learn, and share technical knowledge.",
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge!
                              .copyWith(fontWeight: FontWeight.w400),
                        ),
                      )
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MyBookings()));
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        border: Border.all(width: 1, color: mainBlue)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'MY BOOKINGS',
                          style: TextStyle(
                              color: mainBlue,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [Icon(Icons.event, color: mainBlue)],
                        )
                      ],
                    ),
                  ),
                ),

                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SignupEditScreen(userDetails: userDetails,)));
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        border: Border.all(width: 1, color: mainBlue)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'EDIT ADDRESS ',
                          style: TextStyle(
                              color: mainBlue,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(Icons.edit_calendar, color: mainBlue)
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      border: Border.all(width: 1, color: mainBlue)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'CHANGE CITY ',
                        style: TextStyle(
                            color: mainBlue,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(Icons.change_circle_rounded, color: mainBlue)
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      border: Border.all(width: 1, color: mainBlue)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'CHANGE LAUNGUAGE',
                        style: TextStyle(
                            color: mainBlue,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(Icons.g_translate_rounded, color: mainBlue)
                        ],
                      )
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _showContactDialog(context);
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        border: Border.all(width: 1, color: mainBlue)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'CHAT WITH US',
                          style: TextStyle(
                              color: mainBlue,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [Icon(Icons.chat, color: mainBlue)],
                        )
                      ],
                    ),
                  ),
                ),

                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      border: Border.all(width: 1, color: mainBlue)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'TERMS & CONDITIONS',
                        style: TextStyle(
                            color: mainBlue,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(Icons.question_answer, color: mainBlue)
                        ],
                      )
                    ],
                  ),
                ),
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>SignInScreen()));
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        border: Border.all(width: 1,color: mainBlue)

                    ),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Logout',
                          style: TextStyle(color: mainBlue, fontSize: 18,fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [Icon(Icons.logout,color:mainBlue)],
                        )
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    await FirebasePhoneAuthHandler.signOut(context);
                    // Navigator.pop(context);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WelcomeScreen(),
                        ));
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        border: Border.all(width: 1, color: mainBlue)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'SIGN OUT',
                          style: TextStyle(
                              color: mainBlue,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(Icons.login_outlined, color: mainBlue)
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showContactDialog(context) {
    String no = "+918074035151";

    showDialog(
        context: context,
        barrierDismissible: false,
        //context: _scaffoldKey.currentContext,
        builder: (context) {
          return AlertDialog(
            contentPadding: EdgeInsets.only(left: 10, right: 10),
            title: Center(
                child: Text(
              "Contact Us",
              style: TextStyle(color: Colors.black),
            )),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            content: Container(
              height: 200,
              width: 300,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                      'Please feel free to give us your valuable suggestions'),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Text(
                        'Call us: ',
                      ),
                      InkWell(
                        onTap: () {
                          launch("tel:" + no);
                        },
                        child: Text(no),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text("Mail us: info@goffix.com")
                ],
              ),
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.20,
                    child: ElevatedButton(
                      child: new Text(
                        'OK',
                        style: TextStyle(color: Colors.black),
                      ),
                      // color: mainBlue,
                      // shape: new RoundedRectangleBorder(
                      //   borderRadius: new BorderRadius.circular(30.0),
                      // ),
                      onPressed: () {
                        //saveIssue();
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.01,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 70.0),
                    child: Container(
                      // width: MediaQuery.of(context).size.width * 0.,
                      child: ElevatedButton(
                        child: new Text(
                          'Cancel',
                          style: TextStyle(color: Colors.black),
                        ),
                        // color: mainBlue,
                        // shape: new RoundedRectangleBorder(
                        //   borderRadius: new BorderRadius.circular(30.0),
                        // ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                ],
              )
            ],
          );
        });
  }
}
