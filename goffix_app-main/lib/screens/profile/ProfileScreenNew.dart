import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
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

class ProfilePageScreen extends StatefulWidget {
  LoginCredentialsModel? usermodel;
  @override
  ProfilePageScreen({
    this.usermodel,
  });
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfilePageScreen>
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
            SizedBox(
              height: 50,
            ),
            Container(
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: mainBlue, 
                  image: DecorationImage(image: AssetImage("assets/images/profilebg.jpeg",),fit: BoxFit.fill),
                  borderRadius: BorderRadius.circular(10)),

              height: 230,
              // height: .4 * size.height,
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
                child: userDetails == null
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              ClipRect(
                                child: Image.network(
                                  userDetails?.employeeImage ?? "",
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  height:
                                      MediaQuery.of(context).size.width * 0.4,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[

                                  10.verticalSpace,
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.35,
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
                          20.verticalSpace,

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
            SizedBox(
              height: 20,
            ),
            // TabPage(),
            // SettingsScreen()
            Column(
              children: [
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
                          children: [Icon(Icons.calendar_month, color: mainBlue)],
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
                            Icon(Icons.home_work_outlined, color: mainBlue)
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
                          Icon(Icons.pin_drop_sharp, color: mainBlue)
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
                          children: [Icon(Icons.question_answer, color: mainBlue)],
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
                          Icon(Icons.edit_note, color: mainBlue)
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
              height: 500,
              width: 300,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(
                      height: 200,width: 200,
                      child: Image(image: AssetImage("assets/images/chatwithus.png"),),
                    ),
                  SizedBox(
                    height: 400,
                    child: Expanded(
                      child: GridView.count(
                        crossAxisCount: 2, // Number of columns in the grid
                        padding: EdgeInsets.all(10.0),
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                        children: <Widget>[
                          _buildGridTile(Icons.mail, 'Mail',Colors.red),
                          _buildGridTile(Icons.message, 'Write to us',Colors.deepOrange),
                          _buildGridTile(Icons.call, 'Call us',Colors.blueAccent),
                          _buildGridTile(CupertinoIcons.chat_bubble_2, 'WhatsApp',Colors.green),
                        ],
                      ),
                    ),
                  ),
                    Text("Mail us: info@goffix.com")
                  ],
                ),
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



Widget _buildGridTile(IconData icon, String label,Color color) {
  return GestureDetector(
    onTap: () {
      // Handle icon tap
      print('$label icon tapped');
    },
    child: GridTile(
      child: Container(
        // Background color for tiles
        child: Icon(
          icon,
          size: 30.0,
          color: color,
        ),
        alignment: Alignment.center,
      ),
      footer: GridTileBar(
        backgroundColor: Colors.white,
        title: Text(label, textAlign: TextAlign.center,style: TextStyle(color: Colors.black),),
      ),
    ),
  );
}

