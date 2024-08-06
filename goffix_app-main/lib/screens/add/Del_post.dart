import 'dart:convert';
import 'dart:typed_data';

// import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goffix/screens/login/login.dart';
import 'package:goffix/screens/search/SearchScreen.dart';
import 'package:http/http.dart' as http;

import 'package:rflutter_alert/rflutter_alert.dart';

// import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:goffix/screens/login/login.dart' as Login;

import '../../constants.dart';

class DeletePostScreen extends StatefulWidget {
  // final String username;
  @override
  _DeletePostScreenState createState() => _DeletePostScreenState();
}

class _DeletePostScreenState extends State<DeletePostScreen> {
  late List listOfFixers;
  late List myPosts;
  bool noPosts = false;
  String Fixers = "Your Posts";
  image_64(String _img64) {
    if (_img64 != null) {
      List img = _img64.split(",");
      Uint8List _bytesImage;
      _bytesImage = Base64Decoder().convert(img[1]);
      return _bytesImage;
    }
  }

  Future<dynamic> _delPosts(int _pid) async {
    int? _uid = await Login.User().getUID();
    String? token = await Login.User().getToken();
    var requestBody = {
      "service_name": "deleteMyPost",
      "param": {"u_id": _uid, "p_id": _pid}
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
        // print(""._pid."Post Deleted");
        print(_pid);
        print("Post Deleted");
        _myPosts();
      } else if (jsonResponse["response"]["status"] == 108) {
        // _showMyDialog("Error", "Username/Password not found", "login");
        print("No Post Deleted");
      } else {
        print("Something Went Wrong");
      }
    }
  }

  Future<dynamic> _myPosts() async {
    int? _uid = await Login.User().getUID();
    String? token = await Login.User().getToken();
    var requestBody = {
      "service_name": "myPosts",
      "param": {"uid": _uid, "startPost": "0", "limitPost": "20"}
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
      } else if (jsonResponse["response"]["status"] == 202) {
        if (this.mounted) {
          setState(() {
            noPosts = true;

          });
        }
        print(noPosts);
      } else if (jsonResponse["response"]["status"] == 108) {
        // _showMyDialog("Error", "Username/Password not found", "login");
        print("No Posts found");
      } else {
        print("Something Went Wrong");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    this._myPosts();
    // this._getFixers();
  }

  Widget build(BuildContext context) {
    String no = "+918019510486";
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
                  top: 10.0, bottom: 70, left: 10, right: 10),
              child: Container(
                width: double.infinity,
                // height: 2000.0,
                child: myPosts == null
                    ? !noPosts
                        ? Center(
                            // child: CircularProgressIndicator(),
                            child: Column(
                                // height: MediaQuery.of(context).size.height,
                                // width: MediaQuery.of(context).size.width,
                                // mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset("assets/images/page_load.gif",
                                      height: 50)
                                ]),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 20.0),
                                child: Text(
                                  'No Posts Available',
                                  style: TextStyle(
                                      fontSize: 25, color: Colors.grey),
                                ),
                              ),
                            ],
                          )
                    // : Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: Center(child: Text("No Posts Available")),
                    // )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.only(top: 15.0),
                        itemCount: myPosts.length,
                        itemBuilder: (BuildContext context, int index) {
                          // final msg = listRequsted[index];
                          // print(listRequsted[index]['p_id']);
                          return MyPostCards(
                              myPosts[index]['u_un'],
                              myPosts[index]['p_tit'],
                              myPosts[index]['p_dt'],
                              // int.parse(myPosts[index]['m_rid']),
                              // myPosts[index]['u_img'],
                              int.parse(myPosts[index]['p_id']));
                        },
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  MyPostCards(String name, String title, String time, int pid) {
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
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) =>
              //           // HomeScreen(uid: uid, username: username),
              //           ChatPostScreen(
              //         pid: pid,
              //       ),
              //     )
              //     // MessageScreen()),
              //     );
            },
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                // mainAxisAlignme,
                children: <Widget>[
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      ),
                      InkWell(
                        onTap: () {
                          Alert(
                            context: context,
                            type: AlertType.warning,
                            title: "Are you sure?",
                            desc:
                                "Once deleted, you will not be able to recover this post!",
                            buttons: [
                              DialogButton(
                                child: Text(
                                  "Delete",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                onPressed: () => Navigator.pop(context),
                                width: 120,
                              )
                            ],
                          ).show().then((value) {
                            print(pid);
                            _delPosts(pid);
                            // Navigator.pushReplacement(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => Layout()));
                          });
                        },
                        child: Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Icon(
                              Icons.delete,
                              color: mainBlue,
                              size: 25,
                            )),
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
