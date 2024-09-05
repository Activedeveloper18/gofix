import 'dart:async';
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
import 'package:flutter/services.dart';
import 'package:goffix/screens/home/gdailscreen.dart';
import 'package:goffix/screens/home/homeScreen.dart';
import 'package:goffix/screens/home/newhomepage.dart';
import 'package:goffix/screens/login/login.dart';
import 'package:goffix/screens/profile/ProfileScreenNew.dart';
import 'package:goffix/screens/search/SearchScreen.dart';
import 'package:goffix/screens/chat/chat.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// import 'package:goffix/screens/network/network_status_service.dart';
// import 'package:goffix/screens/network/network_aware_widget.dart';
// import 'package:provider/provider.dart';
import 'package:connectivity/connectivity.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import '../../constants.dart';
import '../eventBooking/eventListing.dart';
import '../eventBooking/eventlistscreen.dart';
import '../eventBooking/eventscreen.dart';
import '../profile/fixeruserprofilescreen.dart';

class Layout extends StatefulWidget {
  static const id = 'HomeScreen';
  // final int uid;
  // final String username;
  @override
  // const Layout({Key key, this.uid, this.username}) : super(key: key);
  _LayoutState createState() => _LayoutState();
}

class _MQSize {
  BuildContext context;
  _MQSize(this.context);

  double get width => MediaQuery.of(context).size.width;
  double get height => MediaQuery.of(context).size.height;
}

// class capitalize{
String capitalize(String string) {
  if (string.isEmpty) {
    return string;
  }

  return string[0].toUpperCase() + string.substring(1);
}
// }

class _LayoutState extends State<Layout> {
  int? _page = 0;
  int? uid;
  bool IsMsg = false;
  String _conStatus = "ConnectivityResult.none";
  Future<dynamic> param() async {
    String? _token = await User().getToken();
    if (_token == null || _token == "") {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginOtpScreen()));
    }
  }

//Network widget
  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;

// Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    ConnectivityResult result = ConnectivityResult.none;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
      case ConnectivityResult.none:
        setState(() => _connectionStatus = result.toString());
        break;
      default:
        setState(() => _connectionStatus = 'Failed to get connectivity.');
        break;
    }
  }

//Check Msg
  Future<dynamic> checkMsg() async {
    String? token = await User().getToken();
    int? uid = await User().getUID();
    var requestBody = {
      "service_name": "checkNewMsgs",
      "param": {
        "u_id": uid,
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
      if (jsonResponse["response"]["status"] == 200) {
        if (jsonResponse.length != null) {
          if (jsonResponse['response']['result']['data']['new_msgs_count'] !=
              "0") {
            if (mounted) {
              setState(() {
                IsMsg = true;
              });
            }
            print("Msg found:" + IsMsg.toString());
          }
          // print("ads");
        } else if (jsonResponse["response"]["status"] == 108) {
          print("msgs not found");
        }
      } else {
        print("Something Went Wrong");
      }
      print(IsMsg);
      return IsMsg;
    }
  }

//Network widget end

  @override
  void initState() {
    super.initState();
    // this.param();

    this.checkMsg();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _pageOption = [
      // HomePage(),
      // Eventscreen(),
      EventListScreen(),
      // EventListing(),
      // HomeScreen(),
      SearchScreen(),
      // AddScreen(),
      HomeScreen(),
      Gdailscreen(),
      // ChatScreen(),
      // ProfilePageScreen(),
      FixerProfilePageScreen()
      // ProfileScreen(),
      // SettingsScreen()
    ];
    return
        // StreamProvider<NetworkStatus>(
        //   create: (context) =>
        //       NetworkStatusService().networkStatusController.stream,
        //   child: NetworkAwareWidget(
        //     onlineChild:
        _connectionStatus != _conStatus
            ? Scaffold(
                // backgroundColor: Colors.white,
                bottomNavigationBar: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    color: Colors.white,
                  ),
                  child: SalomonBottomBar(
                    currentIndex: _page!,

                    // height: 60,
                    // color: mainBlue,
                    // backgroundColor: Color(0x00000000),
                    // buttonBackgroundColor: mainOrange,
                    // animationCurve: Curves.easeInOut,
                    // animationDuration: Duration(milliseconds: 600),
                    items: [
                      SalomonBottomBarItem(
                          icon: Icon(Icons.percent),
                          title: Text("Offers"),
                          selectedColor: mainOrange,
                          unselectedColor: mainBlue),
                      SalomonBottomBarItem(
                          icon: Icon(CupertinoIcons.calendar),
                          title: Text("services"),
                          selectedColor: mainOrange,
                          unselectedColor: mainBlue),
                      SalomonBottomBarItem(
                          icon: Icon(Icons.work),
                          title: Text("jobs"),
                          selectedColor: mainOrange,
                          unselectedColor: mainBlue),

                      // Icon(Icons.percent, size: 35, color: Colors.white),
                      // Icon(CupertinoIcons.calendar,
                      // size: 28, color: Colors.white),
                      // Image.asset(
                      //   "assets/icons/book.png",
                      //   width: 35,
                      // ),
                      // Icon(Icons.feed, size: 35, color: Colors.white),
                      IsMsg != true
                          ? SalomonBottomBarItem(
                              icon: Icon(Icons.call),
                              title: Text("G Dails"),
                              selectedColor: mainOrange,
                              unselectedColor: mainBlue)
                          // : Stack(
                          //     children: <Widget>[
                          //       new Icon(Icons.message,
                          //           size: 28, color: mainBlue),
                          //       new Positioned(
                          //         // top: 20,
                          //         right: 0,
                          //         child: new Container(
                          //           padding: EdgeInsets.all(1),
                          //           decoration: new BoxDecoration(
                          //             color: Colors.red,
                          //             borderRadius: BorderRadius.circular(6),
                          //           ),
                          //           constraints: BoxConstraints(
                          //             minWidth: 10,
                          //             minHeight: 10,
                          //           ),
                          //           child: new Text(
                          //             '',
                          //             style: new TextStyle(
                          //               color: Colors.white,
                          //               fontSize: 1,
                          //             ),
                          //             textAlign: TextAlign.center,
                          //           ),
                          //         ),
                          //       )
                          //     ],
                          //   ),
                          : SalomonBottomBarItem(
                              icon: Icon(Icons.chat),
                              title: Text("messages"),
                              selectedColor: mainOrange,
                              unselectedColor: mainBlue),
                      SalomonBottomBarItem(
                          icon: Icon(CupertinoIcons.person_fill),
                          title: Text("profile"),
                          selectedColor: mainOrange,
                          unselectedColor: mainBlue),
                    ],
                    onTap: (index) {
                      setState(() {
                        _page = index;
                      });
                    },
                  ),
                ),
                extendBody: true,
                body: _pageOption[_page!],
                // floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
                // floatingActionButton: messageIcon(),
              )
            // offlineChild:
            : Scaffold(
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
              );
    //   ),
    // );
  }

  messageIcon() {
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
