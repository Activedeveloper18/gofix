import 'dart:convert';
import 'dart:typed_data';

// import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goffix/screens/login/login.dart';
import 'package:goffix/screens/message/msg_body.dart';
import 'package:goffix/screens/search/SearchScreen.dart';
import 'package:http/http.dart' as http;
// import 'package:jiffy/jiffy.dart';
// import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../../constants.dart';

class ChatPostScreen extends StatefulWidget {
  final int? pid;
  // final String username;
  @override
  const ChatPostScreen({Key? key, this.pid}) : super(key: key);
  _ChatPostScreenState createState() => _ChatPostScreenState();
}

class _ChatPostScreenState extends State<ChatPostScreen> {
  late List listOfMyPosts;
  int? uid;
  String? token;
  image_64(String _img64) {
    if (_img64 != null) {
      List img = _img64.split(",");
      Uint8List _bytesImage;
      _bytesImage = Base64Decoder().convert(img[1]);
      return _bytesImage;
    }
  }

  // Check IsLoggedIn
  Future<dynamic> param() async {
    int? _uid = await User().getUID();
    String? _token = await User().getToken();

    if (mounted) {
      setState(() {
        uid = _uid;
        token = _token;
      });
    }
  }

  Future _getFixers() async {
    int pid = widget.pid!;
    // int cid = 3;
    String? token = await User().getToken();
    int? _uid = await User().getUID();
    var requestBody = {
      "service_name": "userChatAboutPost",
      "param": {"pid": pid, "uid": _uid}
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
            listOfMyPosts = jsonResponse['response']['result']['data'];
          });
        }

        print(listOfMyPosts);
        // return listOfUsers;
      } else if (jsonResponse["response"]["status"] == 108) {
        // _showMyDialog("Error", "Username/Password not found", "login");
        print("Users not found");
      } else {
        print("Something Went Wrong");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    this._getFixers();
    this.param();
  }

  Widget build(BuildContext context) {
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
              // padding: EdgeInsets.only(left: 20, right: 20),
              child: Center(
                child: Text(
                  "Fixers Responded",
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
                  top: 10.0, bottom: 70, left: 10, right: 10),
              child: Container(
                width: double.infinity,
                // height: 2000.0,
                child: listOfMyPosts == null
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(0),
                        // physics: NeverScrollableScrollPhysics(),
                        itemCount: listOfMyPosts.length,
                        itemBuilder: (context, index) {
                          return jobCards(
                              listOfMyPosts[index]['u_nm'],
                              listOfMyPosts[index]['body'],
                              listOfMyPosts[index]['dt'],
                              int.parse(listOfMyPosts[index]['m_sid']),
                              listOfMyPosts[index]['u_img'],
                              widget.pid!);
                          // _nameCards(
                          //   listOfMyPosts[index]['u_nm'],
                          //   listOfMyPosts[index]['cat_name'],
                          //   listOfMyPosts[index]['u_img'],
                          //   listOfMyPosts[index]['works'],
                          // );
                          // _nameCards(listOfFixers[index]['rating']);
                        },
                      ),
                // Column(
                //     children: <Widget>[
                //       _nameCards(),
                //       _nameCards(),
                //     ],
                //   ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  jobCards(
      String name, String title, String time, int fdid, String uimg, int pid) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
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
              if (title != "Call was initiated") {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return MessageScreen(
                      uid: uid,
                      fdid: fdid,
                      pid: pid,
                      userimage: uimg,
                      username: name);
                })
                    // MessageScreen()),
                    );
              }
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
                        child: uimg != null
                            ? Image.memory(
                                image_64(uimg),
                                height: 70,
                              )
                            : Image.asset(
                                'assets/images/profile.jpg',
                                height: 70,
                              ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                title != "Call was initiated"
                                    ? Icon(
                                        Icons.message,
                                        color: mainOrange,
                                        size: 20,
                                      )
                                    : Icon(
                                        Icons.call,
                                        color: mainOrange,
                                        size: 20,
                                      ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  name,
                                  style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontSize: 20,
                                      // fontFamily: "Titillium Web",
                                      fontFamily: "Lato",
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(title,
                                    style: TextStyle(
                                        fontSize: 15,
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
