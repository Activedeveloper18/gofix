import 'dart:convert';
import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goffix/screens/add/AddScreen.dart';
import 'package:goffix/screens/chatPost/chatPost.dart';
import 'package:goffix/screens/home/homeScreen.dart';
import 'package:goffix/screens/login/login.dart';
import 'package:goffix/screens/message/msg_body.dart';
import 'package:goffix/screens/message/msg_body.dart';
import 'package:goffix/screens/profile/ProfileScreen.dart';
import 'package:goffix/screens/search/SearchScreen.dart';
import 'package:goffix/screens/login/login.dart' as Login;
import 'package:http/http.dart' as http;


import '../../constants.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
   List? listRequsted;
   List? myPosts;
   int? uid;
  Future<dynamic> param() async {
    int? _uid = await User().getUID();
    // String _token = await User().getToken();
    if (this.mounted) {
      setState(() {
        uid = _uid!;
        // token = _token;
      });
    }
  }

  image_64(String _img64) {
    if (_img64 != null) {
      List img = _img64.split(",");
      Uint8List _bytesImage;
      _bytesImage = Base64Decoder().convert(img[1]);
      // return Image.memory(_bytesImage);
      return _bytesImage;
    }
  }

  Future<dynamic> _getRequested() async {
    int? _uid = await Login.User().getUID();
    String? token = await Login.User().getToken();
    var requestBody = {
      "service_name": "myRequestedPosts",
      "param": {"uid": _uid, "startPost": "0", "limitPost": "100"}
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
            listRequsted = jsonResponse['response']['result']['data'];
          });
        }
        print(listRequsted);
      } else if (jsonResponse["response"]["status"] == 108) {
        // _showMyDialog("Error", "Username/Password not found", "login");
        print("No Message found");
      } else {
        print("Something Went Wrong");
      }
    }
  }

  Future<dynamic> _myPosts() async {
    int? _uid = await Login.User().getUID();
    String? token = await Login.User().getToken();
    var requestBody = {
      "service_name": "myPostsChat",
      "param": {"uid": _uid, "startPost": "0", "limitPost": "100"}
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
            myPosts = jsonResponse['response']['result']['data'];
          });
        }
        print(myPosts);
      } else if (jsonResponse["response"]["status"] == 108) {
        // _showMyDialog("Error", "Username/Password not found", "login");
        print("No Message found");
      } else {
        print("Something Went Wrong");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    this._getRequested();
    this._myPosts();
    this.param();
  }

  @override
  void dispose() {
    super.dispose();
    this._getRequested();
    this._myPosts();
    this.param();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // MaterialApp(
      //   debugShowCheckedModeBanner: false,
      //   theme: ThemeData(primaryColor: Colors.white),
      //   home:
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            titleSpacing: 2,
            automaticallyImplyLeading: false,
            elevation: 10,
            toolbarHeight: 70,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                  child: Align(
                    alignment: Alignment.center,
                    child: TabBar(
                      unselectedLabelColor: mainBlue,
                      indicatorSize: TabBarIndicatorSize.label,
                      labelColor: Colors.white,
                      indicatorColor: Colors.white,
                      // indicatorPadding: EdgeInsets.all(30),
                      indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: mainBlue,
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFFAAAAAA).withOpacity(0.8),
                              blurRadius: 10.0, // soften the shadow
                              spreadRadius: 1, //extend the shadow
                              offset: Offset(
                                0.0, // Move to right 10  horizontally
                                5.0, // Move to bottom 10 Vertically
                              ),
                            ),
                          ]),
                      tabs: [
                        Tab(
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(color: mainBlue, width: 1)),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                "My Posts",
                              ),
                            ),
                          ),
                        ),
                        Tab(
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(color: mainBlue, width: 1)),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text("Requested"),
                            ),
                          ),
                        )
                        // Tab(text: 'Tab 3'),
                        // Tab(text: 'Tab 4'),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          body: Container(
            child: TabBarView(
              children: [
                // my posts
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(children: [
                      Container(
                          padding: EdgeInsets.only(
                              left: 0.0, right: 0.0, bottom: 70),
                          width: double.infinity,
                          // height: 600,
                          // child: Column(
                          //   children: [
                          child: Container(
                            child: myPosts == null
                                ? Center(
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Center(
                                              child:
                                                  CircularProgressIndicator()),
                                          // Container(
                                          //   child: Center(
                                          //     child: Text(
                                          //       "No Messages!",
                                          //       style: TextStyle(
                                          //           color: Colors.grey[400],
                                          //           fontWeight: FontWeight.w600,
                                          //           fontSize: 20.0),
                                          //     ),
                                          //   ),
                                          // ),
                                        ]),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.only(top: 15.0),
                                    itemCount: myPosts!.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      // final msg = listRequsted[index];
                                      // print(listRequsted[index]['p_id']);
                                      return MyPostCards(
                                          myPosts![index]['u_un'],
                                          myPosts![index]['p_tit'],
                                          myPosts![index]['p_dt'],
                                          int.parse(myPosts![index]['m_rid']),
                                          myPosts![index]['u_img'],
                                          int.parse(myPosts![index]['p_id']));
                                    },
                                  ),
                          )
                          //   ],
                          // ),
                          ),
                    ]),
                  ),
                ),
                //requested posts
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(children: [
                      Container(
                          padding: EdgeInsets.only(
                              left: 0.0, right: 0.0, bottom: 70),
                          width: double.infinity,
                          // height: 600,
                          // child: Column(
                          //   children: [
                          child: Container(
                            child: listRequsted == null
                                ? Center(
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            child: Center(
                                              child: Text(
                                                "No Messages!",
                                                style: TextStyle(
                                                    color: Colors.grey[400],
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 20.0),
                                              ),
                                            ),
                                          ),
                                        ]),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.only(top: 15.0),
                                    itemCount: listRequsted!.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      // final msg = listRequsted[index];
                                      print(listRequsted![index]['p_id']);
                                      return jobCards(
                                          listRequsted![index]['nm'],
                                          listRequsted![index]['p_tit'],
                                          listRequsted![index]['p_dt'],
                                          int.parse(
                                              listRequsted![index]['puid']),
                                          listRequsted![index]['u_img'],
                                          int.parse(
                                              listRequsted![index]['p_id']));
                                    },
                                  ),
                          )
                          //   ],
                          // ),
                          ),
                    ]),
                  ),
                ),
                // Icon(Icons.directions_bike),
              ],
            ),
          ),
        ),
      ),
    );
    // );
  }

//my Posts
  MyPostCards(
      String name, String title, String time, int fdid, String uimg, int pid) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color(0xFFAAAAAA).withOpacity(0.3),
                blurRadius: 40.0, // soften the shadow
                spreadRadius: 3, //extend the shadow
                offset: Offset(
                  0.0, // Move to right 10  horizontally
                  30.0, // Move to bottom 10 Vertically
                ),
              ),
            ]),
        // decoration: BoxDecoration(color: Colors.grey),
        child: Padding(
          padding:
              const EdgeInsets.only(top: 15, left: 15, bottom: 15, right: 10),
          child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        // HomeScreen(uid: uid, username: username),
                        ChatPostScreen(
                      pid: pid,
                    ),
                  )
                  // MessageScreen()),
                  );
            },
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                // mainAxisAlignme,
                children: <Widget>[
                  // Header
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Text(
                            //   title,
                            //   style: TextStyle(
                            //       color: Colors.grey.shade700,
                            //       fontSize: 20,
                            //       // fontFamily: "Titillium Web",
                            //       fontFamily: "Lato",
                            //       fontWeight: FontWeight.bold),
                            // ),
                            // AutoSizeText(
                            //   title,
                            //   maxLines: 2,
                            //   softWrap: true,
                            //   minFontSize: 18,
                            //   // overflow: TextOverflow.fade,
                            //   // stepGranularity: 10,
                            //   style: TextStyle(
                            //       color: Colors.grey.shade700,
                            //       fontSize: 18,
                            //       // fontFamily: "Titillium Web",
                            //       fontFamily: "Lato",
                            //       fontWeight: FontWeight.bold),
                            // ),
                            Text(
                              title.length > 35
                                  ? title.substring(0, 35) + '...'
                                  : title,
                              style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontSize: 18,
                                  // fontFamily: "Titillium Web",
                                  fontFamily: "Lato",
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            // Text(
                            //   Jiffy(time).fromNow(),
                            //   style: TextStyle(
                            //       color: Colors.grey.withOpacity(0.8)),
                            // ),
                          ],
                        ),
                      )
                    ],
                  ),

                  // SizedBox(
                  //   height: 10,
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //requested posts
  jobCards(
      String name, String title, String time, int fdid, String uimg, int pid) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color(0xFFAAAAAA).withOpacity(0.3),
                blurRadius: 40.0, // soften the shadow
                spreadRadius: 3, //extend the shadow
                offset: Offset(
                  0.0, // Move to right 10  horizontally
                  30.0, // Move to bottom 10 Vertically
                ),
              ),
            ]),
        // decoration: BoxDecoration(color: Colors.grey),
        child: Padding(
          padding:
              const EdgeInsets.only(top: 15, left: 15, bottom: 15, right: 10),
          child: InkWell(
            onTap: () async {
              final value = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        // HomeScreen(uid: uid, username: username),
                        MessageScreen(
                            uid: uid,
                            fdid: fdid,
                            pid: pid,
                            userimage: uimg,
                            username: name),
                  )
                  // MessageScreen()),
                  );
            },
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                // mainAxisAlignme,
                children: <Widget>[
                  // Header
                  Row(
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child:

                            // uimg != null
                            //     ? Image.memory(
                            //         image_64(uimg),
                            //         height: 70,
                            //       )
                            //     : Image.asset(
                            //         'assets/images/profile.jpg',
                            //         height: 70,
                            //       ),
                            uimg == null
                                ? Image.asset(
                                    'assets/images/profile.jpg',
                                    height: 70,
                                  )
                                : uimg ==
                                        ("file:///android_asset/www/images/male.png")
                                    ? Image.asset(
                                        'assets/images/male.png',
                                        height: 70,
                                      )
                                    :
                                    //  file:///android_asset/www/images/male.png
                                    Image.memory(
                                        image_64(uimg),
                                        // Image.asset(
                                        //   'assets/images/profile.jpg',
                                        height: 70,
                                        // ),
                                      ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Text(
                            //   title,
                            //   style: TextStyle(
                            //       color: Colors.grey.shade700,
                            //       fontSize: 20,
                            //       // fontFamily: "Titillium Web",
                            //       fontFamily: "Lato",
                            //       fontWeight: FontWeight.bold),
                            // ),
                            // AutoSizeText(
                            //   title,
                            //   maxLines: 2,
                            //   softWrap: true,
                            //   minFontSize: 18,
                            //   // overflow: TextOverflow.fade,
                            //   // stepGranularity: 10,
                            //   style: TextStyle(
                            //       color: Colors.grey.shade700,
                            //       fontSize: 18,
                            //       // fontFamily: "Titillium Web",
                            //       fontFamily: "Lato",
                            //       fontWeight: FontWeight.bold),
                            // ),
                            Text(
                              title.length > 30
                                  ? title.substring(0, 30) + '...'
                                  : title,
                              style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontSize: 18,
                                  // fontFamily: "Titillium Web",
                                  fontFamily: "Lato",
                                  fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                Text(name,
                                    style: TextStyle(
                                        color: mainBlue.withOpacity(0.5),
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                            // Text(
                            //   Jiffy(time).fromNow(),
                            //   style: TextStyle(
                            //       color: Colors.grey.withOpacity(0.8)),
                            // ),
                          ],
                        ),
                      )
                    ],
                  ),

                  // SizedBox(
                  //   height: 10,
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
