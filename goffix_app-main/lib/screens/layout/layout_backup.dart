import 'dart:convert';
// import 'dart:html';
// import 'dart:js';

// import 'package:Kare.ai/screens/home/home.dart';
// import 'package:Kare.ai/screens/home/components/body.dart' as fetchBannerimp;
// import 'package:Kare.ai/screens/login/components/body.dart';
// import 'package:Kare.ai/screens/profile/profile_screen.dart';
// import 'package:Kare.ai/screens/settings/settings.dart';
// import 'package:Kare.ai/screens/welcome/welcome_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:goffix/screens/home/homeScreen.dart';
import 'package:goffix/screens/add/AddScreen.dart';
import 'package:goffix/screens/login/login.dart';
import 'package:goffix/screens/profile/ProfileScreen.dart';
import 'package:goffix/screens/profile/ProfileScreenNew.dart';
import 'package:goffix/screens/search/SearchScreen.dart';
import 'package:goffix/screens/chat/chat.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:goffix/screens/network/network_status_service.dart';
import 'package:goffix/screens/network/network_aware_widget.dart';
import 'package:provider/provider.dart';
// import 'package:connectivity/connectivity.dart';

import '../../constants.dart';

class Layout extends StatefulWidget {
  // final int uid;
  // final String username;
  @override
  // const Layout({Key key, this.uid, this.username}) : super(key: key);
  _LayoutState createState() => _LayoutState();
}

class _MQSize {
  BuildContext context;
  _MQSize(this.context) : assert(context != null);

  double get width => MediaQuery.of(context).size.width;
  double get height => MediaQuery.of(context).size.height;
}

// class capitalize{
String capitalize(String string) {
  if (string == null) {
    throw ArgumentError.notNull('string');
  }

  if (string.isEmpty) {
    return string;
  }

  return string[0].toUpperCase() + string.substring(1);
}
// }

class _LayoutState extends State<Layout> {
  int? _page = 0;
  int? uid;
  Future<dynamic> param() async {
    String? _token = await User().getToken();
    if (_token == null || _token == "") {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginOtpScreen()));
    }
  }

  @override
  void initState() {
    super.initState();
    // this.param();
  }

  @override
  Widget build(BuildContext context) {
    final _pageOption = [
      HomeScreen(),
      SearchScreen(),
      AddScreen(),
      ChatScreen(),
      ProfilePageScreen(),

      // ProfileScreen(),
      // SettingsScreen()
    ];
    return StreamProvider<NetworkStatus>(
      create: (context) =>
          NetworkStatusService().networkStatusController.stream,

      initialData: NetworkStatus.Online,
      child: NetworkAwareWidget(
        onlineChild: Scaffold(
          bottomNavigationBar: CurvedNavigationBar(
            height: 60,
            color: mainBlue,
            backgroundColor: Color(0x00000000),
            buttonBackgroundColor: mainOrange,
            animationCurve: Curves.easeInOut,
            animationDuration: Duration(milliseconds: 600),
            items: <Widget>[
              Icon(Icons.home, size: 35, color: Colors.white),
              Icon(CupertinoIcons.calendar, size: 28, color: Colors.white),
              // Image.asset(
              //   "assets/icons/book.png",
              //   width: 35,
              // ),
              Icon(Icons.add, size: 35, color: Colors.white),
              Icon(Icons.message, size: 28, color: Colors.white),

              Icon(CupertinoIcons.person_fill, size: 35, color: Colors.white),
            ],
            onTap: (index) {
              setState(() {
                _page = index;
              });
            },
          ),
          extendBody: true,
          body: _pageOption[_page!],
          // floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          // floatingActionButton: messageIcon(),
        ),
        offlineChild: Scaffold(
          body: Container(
            child: Center(
              child: Text(
                "No internet connection!",
                style: TextStyle(
                    color: Colors.grey[400],
                    fontWeight: FontWeight.w600,
                    fontSize: 20.0),
              ),
            ),
          ),
        ),
      ),
    );
  }

  messageIcon() {
    double height = _MQSize(context).height;
    double width = _MQSize(context).width;
    double bottomPad = height * .7;
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 95),
        child: FloatingActionButton(
          onPressed: () {
            // setState(() {
            //   _page = 4;
            // });
            // Navigator.of(context).pushAndRemoveUntil(
            //     MaterialPageRoute(
            //         builder: (BuildContext context) =>
            //             // Layout(uid: uid, username: username)
            //             // symptomChecker2()
            //             ChatScreen()),
            //     (Route<dynamic> route) => false);
          },
          child: Icon(
            Icons.message,
            color: Colors.white,
          ),
          backgroundColor: mainBlue,
        ),
      ),
    );
  }
}
