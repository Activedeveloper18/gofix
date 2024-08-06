import 'dart:ui';

import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:goffix/constants.dart';
import 'package:goffix/screens/ForgotPassword/forgotPassword.dart';
import 'package:goffix/screens/settings/editProfile.dart';
import 'package:goffix/screens/welcome/welcome.dart';
import 'package:in_app_review/in_app_review.dart';
// import 'package:otp_screen/otp_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return
        //  Scaffold(
        //     extendBodyBehindAppBar: true,
        //     appBar: AppBar(
        //       backgroundColor: Colors.transparent,
        //       elevation: 0,
        //       bottomOpacity: 0.8,
        //       toolbarHeight: 60,
        // title: Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     GestureDetector(
        //       onTap: () {
        //         print("testProfile");
        //       },
        //       child: Text(
        //         "Settings",
        //         style: TextStyle(
        //             fontFamily: "Lato",
        //             color: Colors.white,
        //             fontSize: 30,
        //             fontWeight: FontWeight.bold),
        //       ),
        //     ),
        //   ],
        // ),
        // ),
        // body:
        // Column(
        //   children: [
        //     Container(
        //       height: size.height * .30,
        //       // width: 350,
        //       decoration: BoxDecoration(
        //         image: DecorationImage(
        //           image: AssetImage("assets/images/bg.png"),
        //           fit: BoxFit.cover,
        //         ),
        //       ),
        //       child: BackdropFilter(
        //         filter: ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0),
        //         child: Container(
        //           color: Color(0xFF241331).withOpacity(.7),
        //         ),
        //       ),
        //     ),
        //   ],
        // ),

        Padding(
            padding:
                EdgeInsets.only(left: 0.0, right: 0.0, top: size.width * .6),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black12,
                            offset: Offset(0.0, -10.0),
                            blurRadius: 10.0)
                      ]),
                  // height: size.height,
                  child: Column(
                    children: [
                      SizedBox(height: 20,),
                      _listCat(
                        name: "MY BOOKINGS",
                        count: "Edit your Profile",
                        action: "edit",
                      ),
                      _listCat(
                          name: "EDIT ADDRESS",
                          count: "Change password here",
                          action: "changepassword"),
                      _listCat(
                          name: "CHANGE CITY",
                          count: "Change password here",
                          action: "changepassword"),
                      _listCat(
                          name: "CHANGE LANGUAGE",
                          count: "Change password here",
                          action: "changepassword"),
                      // _listCat(
                      //   name: "Bookmarks",
                      //   count: "Your Saved Posts",
                      // ),
                      _listCat(
                        name: "TERMS & CONDITIONS",
                        count: "View Terms & Conditions",
                        action: "TC",
                      ),
                      _listCat(
                        name: "CHAT WITH US ",
                        count: "Write email to us / Call us",
                        action: "call",
                      ),
                      // _listCat(
                      //   name: "Contact Us with Phone",
                      //   count: "Call to us",
                      // ),
                      // _listCat(
                      //   name: "About",
                      //   count: "About the App",
                      //   action: "about",
                      // ),
                      // _listCat(
                      //   name: "Rating",
                      //   count: "Rate Our App",
                      //   action: "rate",
                      // ),

                      _listCat(
                        name: "SIGN OUT",
                        count: "Logout",
                        action: "logout",
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text("App version: 4.2.1"),
                      SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                )
              ],
            ));
  }
}

class _listCat extends StatelessWidget {
  final String? name;
  final String? count;
  final String? action;
  @override
  _listCat({Key? key, this.name, this.count, this.action}) : super(key: key);

  _logout() async {
    final pref = await SharedPreferences.getInstance();
    await pref.clear();

    return true;
  }

  int? uid;
  String? token;
  // Check IsLoggedIn
  Future<dynamic> param() async {
    final pref = await SharedPreferences.getInstance();
    uid = (await pref.getInt('uid'))!;
    token = (await pref.getString('token'))!;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (action == "logout") {
          _logout();

          await FirebasePhoneAuthHandler.signOut(context);
          // Navigator.pop(context);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => WelcomeScreen(),
              ));
          // if (_logout() == true) {
          // Alert(
          //   context: context,
          //   type: AlertType.info,
          //   title: "Logout",
          //   desc: "Will Reach me Soon",
          //   buttons: [
          //     DialogButton(
          //       // height: 70,
          //       child: Text(
          //         "logout",
          //         style: TextStyle(color: Colors.white, fontSize: 20),
          //       ),
          //       onPressed: () {
          //         // print(unm);
          //         // launch('tel:' + u_phn);
          //       },
          //       width: 150,
          //     ),
          //   ],
          // ).show().then((value) {
          //   print(value);
          //   //
          // });

          // }
        // } else if (action == "changepassword") {
        //   param();
        //
        //   Navigator.pop(context);
        //   Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //         builder: (context) => ForgotPasswordScreen(),
        //       ));
        }
        else if (action == "edit") {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => SignupEditScreen()));
        } else if (action == "call") {
          _showContactDialog(context);
        } else if (action == "about") {
          _showAboutDialog(context);
        } else if (action == "TC") {
          _showAboutTCDialog(context);
        } else if (action == "rate") {
          final InAppReview inAppReview = InAppReview.instance;
          if (await inAppReview.isAvailable()) {
            inAppReview.requestReview();
          }
        }
      },
      child: Column(
        children: [
          Container(
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
                  'MY BOOKINGS',
                  style: TextStyle(color: mainBlue, fontSize: 18,fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 2,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [Icon(Icons.event)],
                )
              ],
            ),
          ),

          GestureDetector(
            onTap: (){
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SignupEditScreen()));
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
                    'EDIT ADDRESS ',
                    style: TextStyle(color: mainBlue, fontSize: 18,fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [Icon(Icons.edit_calendar)],
                  )
                ],
              ),
            ),
          ),
          Container(
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
                  'CHANGE CITY ',
                  style: TextStyle(color: mainBlue, fontSize: 18,fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 2,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [Icon(Icons.change_circle_rounded)],
                )
              ],
            ),
          ),
          Container(
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
                  'CHANGE LAUNGUAGE',
                  style: TextStyle(color: mainBlue, fontSize: 18,fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 2,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [Icon(Icons.g_translate_rounded)],
                )
              ],
            ),
          ),
          Container(
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
                  'CHAT WITH US',
                  style: TextStyle(color: mainBlue, fontSize: 18,fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 2,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [Icon(Icons.chat)],
                )
              ],
            ),
          ),

          Container(
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
                  'TERMS & CONDITIONS',
                  style: TextStyle(color: mainBlue, fontSize: 18,fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 2,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [Icon(Icons.question_answer)],
                )
              ],
            ),
          ),
          Container(
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
                  'SIGN OUT',
                  style: TextStyle(color: mainBlue, fontSize: 18,fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 2,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [Icon(Icons.login_outlined)],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  // void _showerrorDialog(String message,context) {
  //   showDialog(
  //     context: context,
  //     builder: (ctx) => AlertDialog(
  //       title: Text(
  //         'An Error Occurs',
  //         style: TextStyle(color: Colors.blue),
  //       ),
  //       content: Text(message),
  //       actions: <Widget>[
  //         FlatButton(
  //             child: Text('Okay'), onPressed: () => Navigator.pop())
  //       ],
  //     ),
  //   );
  // }

  void _showContactDialog(context) {
    String no = "+918074035151";

    showDialog(
        context: context,
        barrierDismissible: false,
        //context: _scaffoldKey.currentContext,
        builder: (context) {
          return AlertDialog(
            contentPadding: EdgeInsets.only(left: 10, right: 10),
            title: Center(child: Text("Contact Us",style: TextStyle(color: Colors.black),)),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            content: Container(
              height: 200,
              width: 300,
              child: SingleChildScrollView(
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

  void _showAboutDialog(context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        //context: _scaffoldKey.currentContext,
        builder: (context) {
          return AlertDialog(
            contentPadding: EdgeInsets.only(left: 10, right: 10),
            title: Center(child: Text("About Us")),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            content: Container(
              height: MediaQuery.of(context).size.height,
              // height: 600,
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    Text(about),
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
                      // width: MediaQuery.of(context).size.width * 0.20,
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

  void _showAboutTCDialog(context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        //context: _scaffoldKey.currentContext,
        builder: (context) {
          return AlertDialog(
            contentPadding: EdgeInsets.only(left: 10, right: 10),
            title: Center(child: Text("Terms to Use")),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            content: Container(
              height: MediaQuery.of(context).size.height,
              // height: 600,
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    Text(AppTC),
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
                      // width: MediaQuery.of(context).size.width * 0.20,
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
