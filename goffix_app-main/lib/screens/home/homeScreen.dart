import 'dart:convert';
import 'dart:io' as Io;
import 'dart:async';
import 'dart:typed_data';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:carousel_pro/carousel_pro.dart';
import 'package:goffix/constants.dart';
import 'package:goffix/models/post_model.dart';
import 'package:goffix/providers/db_provider.dart';
import 'package:goffix/screens/add/AddScreen.dart';
import 'package:goffix/screens/home/components/tooltip.dart';
import 'package:goffix/screens/login/login.dart';
import 'package:goffix/screens/message/msg_body.dart';
import 'package:http/http.dart' as http;
import 'package:popup_menu/popup_menu.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
// import 'package:share/share.dart';
import 'package:goffix/providers/timeagoprovider.dart';
// import 'package:jiffy/jiffy.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shimmer/shimmer.dart';

import '../../models/getcountbyprofession.dart';
import '../../repo/user_repo.dart';
import '../CauroselDemo.dart';
import 'components/popover_button.dart';
import 'package:goffix/screens/network/network_status_service.dart';
import 'package:goffix/screens/network/network_aware_widget.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<LiquidPullToRefreshState> _refreshIndicatorKey =
      GlobalKey<LiquidPullToRefreshState>();
  // Map<String, dynamic> listOfAds;
  List? listOfAds;
  List? listOfPosts;
  bool isLoader = false;
  List? listOfPostsTop10;
  // Map<String, dynamic> listOfPostsTemp;
  List? listOfPostsTemp;
  List? chkOff;
  bool _isFetchPostLoading = true;
  var startPost = "0";
  var limitPost = "50";
  List? postedJobs;
  PopupMenu? menu;
  final LayerLink _layerLink = LayerLink();
  int? uid;
  String? token;
  List? adImages;
  late OverlayEntry _overlayEntry;
  bool _otpPop = true;
  String _savePostIcon = "";
  GlobalKey<ScaffoldState>? _scaffoldKey;
  String userName = "";
  String mobile = "";

  Future _chckOffline() async {
    DBProvider.db.getAllEmployees().then((chkOff) {
      print(chkOff);
      if (chkOff == null) {
        _getPosts();
      }
    });
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

// bookmark to Offline
  Future<dynamic> _savePost(pid) async {
    var res = await DBProvider.db.updatePost(pid);
    print(res);
    _fetchPosts();
  }

//_callClick
  Future<dynamic> _callClick(pid, fxid, fdid, _uid, phn) async {
    String? token = await User().getToken();
    int? uid = await User().getUID();
    fdid = fdid.toString();
    fxid = fxid.toString();
    if (fdid == fxid) {
      print("Sorry it's your Post");
      Alert(
        context: context,
        type: AlertType.warning,
        title: "Disclaimer",
        desc: "It's your Post",
        buttons: [],
      ).show().then((value) {
        print(value);
        //
      });
    } else {
      var requestBody = {
        "service_name": "addCall",
        "param": {
          "pc_body": "Call was initiated",
          "pc_pid": pid,
          "pc_fxid": fxid,
          "pc_fdid": fdid,
          "uid": uid
        }
      };
      print(requestBody);
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
          String Phn = "tel:+91" + phn;
          launch(Phn.toString());
        }
      } else if (jsonResponse["response"]["status"] == 108) {
        print("Sorry Couldn't Call");
      } else {
        print("Something Went Wrong");
      }
    }
  }

  //
//_msgClick
  Future<dynamic> _msgClick(fdid, uid, pid, uimg, unm) async {
    String? token = await User().getToken();
    int? uid = await User().getUID();
    // String uid1 = uid.toString();
    if (uid != fdid) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              // HomeScreen(uid: uid, username: username),
              MessageScreen(
                  uid: uid,
                  fdid: fdid,
                  pid: pid,
                  userimage: uimg,
                  username: unm),
        ),
      );
    } else {
      print("Its ur Post");
      Alert(
        context: context,
        type: AlertType.warning,
        title: "Disclaimer",
        desc: "It's your Post",
        buttons: [],
      ).show().then((value) {
        print(value);
        //
      });
    }
  }

//Fetch Ads
  Future<dynamic> ads() async {
    String? token = await User().getToken();
    int? uid = await User().getUID();
    var requestBody = {"service_name": "Adds", "param": {}};
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
          // return jsonResponse;
          // var adTyp =
          //     json.decode(jsonResponse['response']['result']['data']['a_type']);
          // print(adTyp);
          // if (adTyp == 1) {
          if (mounted) {
            setState(() {
              listOfAds = jsonResponse['response']['result']['data'];
              // adImages = listOfAds['a_img'];
            });
          }
          // for (var i = 0; i < listOfAds.length; i++) {
          //   adImages = image_64(listOfAds[i]['a_img']).toList();
          // }
          // }
        }

        // _showMyDialog("Success", "User Login Success", "home");

        print("ads");
      } else if (jsonResponse["response"]["status"] == 108) {
        // _showMyDialog("Error", "Username/Password not found", "login");
        print("Ads not found");
      }
    } else {
      print("Something Went Wrong");
    }
    print(listOfAds);
    return listOfAds;
  }

// Insert into offline db
  Future<List<Null>?> _getPosts() async {
    // refreshPosts() {}
    // Future _getPosts() async {
    // _getPosts() async {
    String? token = await User().getToken();
    int? uid = await User().getUID();
    var requestBody = {
      "service_name": "postedJobs15",
      "param": {
        "u_id": uid,
        "startPost": startPost,
        "limitPost": limitPost,
        "pageLoading": "",
        "filter_by_cat": "",
        "filter_by_loc": ""
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
        // setState(() {
        listOfPosts = jsonResponse['response']['result']['data'];
        // });

        // setState(() {
        //   listOfPosts = listOfPosts;
        // });
        DBProvider.db.deleteAllEmployees();
        return (listOfPosts as List).map((posts) {
          print('Inserting $posts');
          DBProvider.db.createEmployee(PostModel.fromJson(posts));
        }).toList();
        // _scaffoldKey.currentState.showSnackBar(
        //   SnackBar(
        //     content: const Text('Page Refreshed'),
        //   ),
        // );
        await Future.delayed(const Duration(seconds: 2));
        // DBProvider.db.getAllEmployees();
      } else if (jsonResponse["response"]["status"] == 108) {
        // _showMyDialog("Error", "Username/Password not found", "login");
        print("Posts not found");
      } else {
        print("Something Went Wrong");
      }
    }
    // return null;
  }

// Live Sync 10 posts
  Future<List<PostModel>?> _getPostsTop10() async {
    // refreshPosts() {}
    // Future _getPosts() async {
    // _getPosts() async {
    String? token = await User().getToken();
    int? uid = await User().getUID();
    var requestBody = {
      "service_name": "LivePosts",
      "param": {"u_id": uid, "startPost": "0", "limitPost": "10"}
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
            listOfPostsTop10 = jsonResponse['response']['result']['data'];
          });
        }

        // DBProvider.db.getAllEmployees();
      } else if (jsonResponse["response"]["status"] == 108) {
        // _showMyDialog("Error", "Username/Password not found", "login");
        print("Posts not found");
      } else {
        print("Something Went Wrong");
      }
    }
    // return null;
  }

  late ScrollController _scrollController;

  // Image Ads Conversion from base64 to Img

  image_64(String _img64) {
    if (_img64 != null) {
      List img = _img64.split(",");
      Uint8List _bytesImage;
      _bytesImage = Base64Decoder().convert(img[1]);
      // return Image.memory(_bytesImage);
      return _bytesImage;
    }
  }

//   List<GetCountByProfessionModel> getCountByProfession = <GetCountByProfessionModel>[];
// // Sync Online
//   Future fetchPost() async {
//     isLoader = true;
//     Uri url = Uri.parse(getAllUserByProfession + "profession=Engineer");
//     final response = await http.get(url, headers: headers);
//     print(response.statusCode);
//     print(response.body);
//     if (response.statusCode == 200 || response.statusCode == 201) {
//       isLoader = false;
//       setState(() {});
//       var data = jsonDecode(response.body);
//       // var data = jsonDecode("");
//
//       getCountByProfession = data.map((e) => GetCountByProfessionModel.fromJson(e));
//     } else {
//       isLoader = false;
//       setState(() {});
//       var snackbar = '';
//     }
//   }

  @override
  void initState() {
    super.initState();
    this.param();
    this._getPostsTop10();
    // fetchPost();
    UserRepo().getCountByProfession();
    // this._chckOffline();
    _scaffoldKey = GlobalKey();
    // this.getUserName();
    // _SyncPost();
    // this.ads();
    // _scrollController = new ScrollController();
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final boxWidth = size.width;
    final dashWidth = 3.0;
    final double dashHeight = 0.2;
    final dashCount = (boxWidth / (2 * dashWidth)).floor();
    return new Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: SizedBox(),
        actions: [
          Container(
            padding: EdgeInsets.all(8),
            child: ElevatedButton.icon(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0)),
                  ),
                  elevation: MaterialStateProperty.all(0),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                  backgroundColor: MaterialStateProperty.all(mainBlue)),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddScreen()));
              },
              icon: Icon(Icons.arrow_circle_right_rounded),
              label: Text("Post a Job"),
            ),
          )
        ],
        backgroundColor: Colors.white,
        elevation: 30,
        bottomOpacity: 0.8,
        toolbarHeight: 60,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                _getPosts();
              },
              child: Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.contain,
                height: 60,
                width: 100,
              ),
            ),
          ],
        ),
      ),
      body: new GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).unfocus();
          // _overlayEntry.remove();
        },
        child: RefreshIndicator(
          child: Stack(
            fit: StackFit.expand,
            children: [
              SafeArea(
                // padding: const EdgeInsets.only(top: 70),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Container(
                      decoration: BoxDecoration(color: Colors.white),
                      width: double.infinity,
                      // height: 1000.0,
                      child: Column(
                        children: <Widget>[
                          // CarouselWithIndicatorDemo(
                          //   Screen: "home",
                          // ),
                          SizedBox(
                            height: 30,
                          ),

                          // App Posts
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: 60, left: 8, right: 8),
                            child: Container(
                              child: Container(
                                child: Column(
                                  children: <Widget>[
                                    //Posts
                                    Container(
                                      child: Column(
                                        // mainAxisAlignment:
                                        //     MainAxisAlignment.start,
                                        // crossAxisAlignment:
                                        //     CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 20),
                                            child: Text("Go Find Fix",
                                                style: TextStyle(
                                                    color: Colors.grey.shade400,
                                                    fontSize: 20,
                                                    fontFamily: "Titillium Web",
                                                    // fontFamily: "Lato",
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                          // isLoader
                                          //     ? Container(
                                          //         child: Center(
                                          //             child: Image.asset(
                                          //                 "assets/images/page_load.gif",
                                          //                 height: 50)))
                                          //     // : postCards(),
                                          // :Container(child: Text("Madhu"),),
                                          // isLoader
                                          //     ? Container()
                                          //     : _fetchPosts()
                                          isLoader
                                              ? Container(
                                                  child: Center(
                                                      child: Image.asset(
                                                          "assets/images/page_load.gif",
                                                          height: 50)))
                                              : SizedBox(
                                                  height: MediaQuery.of(context)
                                                      .size
                                                      .height,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: ListView.builder(
                                                      itemCount: 15,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return
                                                            //   Padding(
                                                            //   padding:
                                                            //       const EdgeInsets
                                                            //           .all(8.0),
                                                            //   child: Container(
                                                            //     height: 100,
                                                            //     width: MediaQuery.of(
                                                            //                 context)
                                                            //             .size
                                                            //             .width *
                                                            //         95,
                                                            //     decoration: BoxDecoration(
                                                            //         color: Colors
                                                            //             .white,
                                                            //         borderRadius:
                                                            //             BorderRadius
                                                            //                 .circular(
                                                            //                     10),
                                                            //         boxShadow: [
                                                            //           BoxShadow(
                                                            //               color: Colors
                                                            //                   .grey,
                                                            //               blurRadius:
                                                            //                   4,
                                                            //               spreadRadius:
                                                            //                   5)
                                                            //         ]),
                                                            //     child: Row(
                                                            //       mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                            //       children: [
                                                            //         CircleAvatar(
                                                            //
                                                            //           backgroundImage:
                                                            //               AssetImage(
                                                            //                   "assets/images/pic1.png"),
                                                            //         ),
                                                            //         Text("Engineer",style: TextStyle(fontSize: 32),),
                                                            //
                                                            //         Text("10",style: TextStyle(fontSize: 32),),
                                                            //
                                                            //
                                                            //       ],
                                                            //     ),
                                                            //   ),
                                                            // );
                                                            Container(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    bottom: 20),
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5),
                                                                  color: Colors
                                                                      .white,
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                      color: Color(
                                                                              0xFFAAAAAA)
                                                                          .withOpacity(
                                                                              0.3),
                                                                      blurRadius:
                                                                          40.0, // soften the shadow
                                                                      spreadRadius:
                                                                          3, //extend the shadow
                                                                      offset:
                                                                          Offset(
                                                                        0.0, // Move to right 10  horizontally
                                                                        30.0, // Move to bottom 10 Vertically
                                                                      ),
                                                                    ),
                                                                  ]),
                                                              // decoration: BoxDecoration(color: Colors.grey),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        top: 15,
                                                                        left:
                                                                            15,
                                                                        bottom:
                                                                            15,
                                                                        right:
                                                                            10),
                                                                child:
                                                                    Container(
                                                                  child: Column(
                                                                    children: <Widget>[
                                                                      // Header
                                                                      Row(
                                                                        children: <Widget>[
                                                                          ClipRRect(
                                                                            borderRadius:
                                                                                BorderRadius.circular(100),
                                                                            child: listOfPostsTop10?[index]["u_img"] == null
                                                                                ? Image.asset(
                                                                                    'assets/images/male.png',
                                                                                    height: 70,
                                                                                  )
                                                                                : listOfPostsTop10?[index]["u_img"] == ("file:///android_asset/www/images/male.png")
                                                                                    ? Image.asset(
                                                                                        'assets/images/male.png',
                                                                                        height: 70,
                                                                                      )
                                                                                    : Image.memory(
                                                                                        image_64(listOfPostsTop10?[index]["u_img"]),
                                                                                        // Image.asset(
                                                                                        //   'assets/images/profile.jpg',
                                                                                        height: 70,
                                                                                        // ),
                                                                                      ),
                                                                          ),
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(left: 10),
                                                                            child:
                                                                                Column(
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                ConstrainedBox(
                                                                                  constraints: BoxConstraints(
                                                                                    minWidth: 150.0,
                                                                                    maxWidth: 200.0,
                                                                                    // minHeight: 30.0,
                                                                                    // maxHeight: 100.0,
                                                                                  ),
                                                                                  child: AutoSizeText(
                                                                                    "listOfPostsTop10[index]",
                                                                                    // "Rajesh Reddy - Sicentix ",
                                                                                    maxLines: 2,
                                                                                    softWrap: true,
                                                                                    minFontSize: 18,
                                                                                    style: TextStyle(
                                                                                        color: Colors.grey.shade700,
                                                                                        fontSize: 20,
                                                                                        // fontFamily: "Titillium Web",
                                                                                        fontFamily: "Lato",
                                                                                        fontWeight: FontWeight.bold),
                                                                                  ),
                                                                                ),
                                                                                // Text(
                                                                                //   listOfPostsTop10[index]["u_nm"],
                                                                                //   style: TextStyle(
                                                                                //       color: Colors.grey.shade700,
                                                                                //       fontSize: 20,
                                                                                //       // fontFamily: "Titillium Web",
                                                                                //       fontFamily: "Lato",
                                                                                //       fontWeight: FontWeight.bold),
                                                                                // ),
                                                                                Row(
                                                                                  children: [
                                                                                    Icon(
                                                                                      CupertinoIcons.placemark_fill,
                                                                                      size: 20,
                                                                                      color: mainBlue.withOpacity(0.8),
                                                                                    ),
                                                                                    Text("loc_name", style: TextStyle(color: mainBlue.withOpacity(0.5), fontWeight: FontWeight.bold)),
                                                                                  ],
                                                                                ),
                                                                                // Text(
                                                                                //   // snapshot.data[index].pDt.toString(),
                                                                                //   // TimeAgo.timeAgoSinceDate(
                                                                                //   //     snapshot.data[index].pDt.toString()),
                                                                                //   Jiffy(listOfPostsTop10[index]["p_dt"])
                                                                                //       .fromNow(),
                                                                                //   style: TextStyle(
                                                                                //       color: Colors.grey.withOpacity(0.8)),
                                                                                // ),
                                                                              ],
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            10,
                                                                      ),

                                                                      Divider(
                                                                        color: Colors
                                                                            .grey,
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            10,
                                                                      ),
                                                                      // Body
                                                                      Container(
                                                                        child:
                                                                            Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: <Widget>[
                                                                            Text(
                                                                              "p_tit",
                                                                              style: TextStyle(color: Colors.grey.shade800, fontSize: 20, fontWeight: FontWeight.bold),
                                                                            ),
                                                                            Text(
                                                                              "Jdf",
                                                                              style: TextStyle(
                                                                                color: Colors.grey.shade800,
                                                                                fontSize: 18,

                                                                                // fontWeight: FontWeight.bold,
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              height: 10,
                                                                            ),
                                                                            Row(
                                                                              children: [
                                                                                Container(
                                                                                  padding: const EdgeInsets.all(3.0),
                                                                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), border: Border.all(color: mainBlue)),
                                                                                  child: Text(
                                                                                    "cat_name",
                                                                                    style: TextStyle(color: mainBlue, fontSize: 15),
                                                                                  ),
                                                                                ),
                                                                                SizedBox(
                                                                                  width: 10,
                                                                                ),
                                                                                Container(
                                                                                  padding: const EdgeInsets.all(3.0),
                                                                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), border: Border.all(color: mainBlue)),
                                                                                  child: Text(
                                                                                    "priority",
                                                                                    style: TextStyle(color: mainBlue, fontSize: 15),
                                                                                  ),
                                                                                )
                                                                              ],
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            10,
                                                                      ),

                                                                      Divider(
                                                                          color:
                                                                              Colors.grey),
                                                                      SizedBox(
                                                                        height:
                                                                            10,
                                                                      ),
                                                                      // Footer
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceAround,
                                                                        children: [
                                                                          (listOfPostsTop10?[index]["p_ctyp"] == "0")
                                                                              ? InkWell(
                                                                                  onTap: () {
                                                                                    _callClick(listOfPostsTop10?[index]["p_id"], uid, listOfPostsTop10?[index]["u_id"], uid, listOfPostsTop10?[index]["u_phn"]);
                                                                                  },
                                                                                  child: Icon(
                                                                                    Icons.call,
                                                                                    size: 23,
                                                                                    color: mainBlue,
                                                                                  ),
                                                                                )
                                                                              : Icon(
                                                                                  Icons.phone_disabled,
                                                                                  size: 23,
                                                                                  color: Colors.grey,
                                                                                ),
                                                                          InkWell(
                                                                            onTap:
                                                                                () {
                                                                              // _msgClick(
                                                                              // int.parse(listOfPostsTop10?[index]["u_id"]),
                                                                              // uid,
                                                                              // // int.parse(listOfPostsTop10[index]["p_id"]),
                                                                              // listOfPostsTop10![index]["u_img"],
                                                                              // listOfPostsTop10![index]["u_nm"]);
                                                                            },
                                                                            child:
                                                                                Icon(
                                                                              Icons.message,
                                                                              size: 23,
                                                                              color: mainBlue,
                                                                            ),
                                                                          ),
                                                                          // SimpleAccountMenu(),
                                                                          InkWell(
                                                                            onTap:
                                                                                () {
                                                                              var shareText = listOfPostsTop10![index]["p_tit"] + '\n' + "SJdf";
                                                                              // Share.share(shareText);
                                                                            },
                                                                            child:
                                                                                Icon(
                                                                              Icons.share_outlined,
                                                                              size: 23,
                                                                              color: mainBlue,
                                                                            ),
                                                                          ),
                                                                          InkWell(
                                                                            onTap:
                                                                                () {
                                                                              print(listOfPostsTop10?[index]["issaved"]);
                                                                              _savePost(listOfPostsTop10?[index]["p_id"]);

                                                                              AlertDialog();
                                                                            },
                                                                            child:
                                                                                Icon(
                                                                              "issaved" == "1" ? CupertinoIcons.info_circle_fill : CupertinoIcons.info_circle_fill,
                                                                              size: 23,
                                                                              color: mainBlue,
                                                                            ),
                                                                          ),
                                                                          Icon(
                                                                            CupertinoIcons.info_circle,
                                                                            size:
                                                                                23,
                                                                            color:
                                                                                mainBlue,
                                                                          ),
                                                                          Icon(
                                                                            Icons.bookmark,
                                                                            color:
                                                                                mainBlue,
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      }),
                                                ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          onRefresh: _getPosts,
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // this.ads();
    this._getPostsTop10();
    this._getPosts();

    // _scrollController.dispose();
  }

// Live Requests
  postCards() {
    var priority;
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: listOfPostsTop10?.length,
      itemBuilder: (context, index) {
        if (listOfPostsTop10?[index]["p_priority"] == "0") {
          priority = "One Day";
        } else if (listOfPostsTop10![index]["p_priority"] == "1") {
          priority = "One Week";
        } else if (listOfPostsTop10![index]["p_priority"] == "2") {
          priority = "One Month";
        }
        String Jd = listOfPostsTop10![index]["p_jd"];
        String Downlink =
            "\n Download App Now: https://play.google.com/store/apps/details?id=com.fewnix.goffix";
        // String Jd1 = Jd + Downlink;
        String Jdf = Jd.replaceAll("<br/>", "\n");
        String SJdf = Jdf + Downlink;
        return Container(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20),
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
                padding: const EdgeInsets.only(
                    top: 15, left: 15, bottom: 15, right: 10),
                child: Container(
                  child: Column(
                    children: <Widget>[
                      // Header
                      Row(
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: listOfPostsTop10![index]["u_img"] == null
                                ? Image.asset(
                                    'assets/images/male.png',
                                    height: 70,
                                  )
                                : listOfPostsTop10![index]["u_img"] ==
                                        ("file:///android_asset/www/images/male.png")
                                    ? Image.asset(
                                        'assets/images/male.png',
                                        height: 70,
                                      )
                                    : Image.memory(
                                        image_64(
                                            listOfPostsTop10![index]["u_img"]),
                                        // Image.asset(
                                        //   'assets/images/profile.jpg',
                                        height: 70,
                                        // ),
                                      ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                    minWidth: 150.0,
                                    maxWidth: 200.0,
                                    // minHeight: 30.0,
                                    // maxHeight: 100.0,
                                  ),
                                  child: AutoSizeText(
                                    listOfPostsTop10![index]["u_nm"],
                                    // "Rajesh Reddy - Sicentix ",
                                    maxLines: 2,
                                    softWrap: true,
                                    minFontSize: 18,
                                    style: TextStyle(
                                        color: Colors.grey.shade700,
                                        fontSize: 20,
                                        // fontFamily: "Titillium Web",
                                        fontFamily: "Lato",
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                // Text(
                                //   listOfPostsTop10[index]["u_nm"],
                                //   style: TextStyle(
                                //       color: Colors.grey.shade700,
                                //       fontSize: 20,
                                //       // fontFamily: "Titillium Web",
                                //       fontFamily: "Lato",
                                //       fontWeight: FontWeight.bold),
                                // ),
                                Row(
                                  children: [
                                    Icon(
                                      CupertinoIcons.placemark_fill,
                                      size: 20,
                                      color: mainBlue.withOpacity(0.8),
                                    ),
                                    Text(listOfPostsTop10![index]["loc_name"],
                                        style: TextStyle(
                                            color: mainBlue.withOpacity(0.5),
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                // Text(
                                //   // snapshot.data[index].pDt.toString(),
                                //   // TimeAgo.timeAgoSinceDate(
                                //   //     snapshot.data[index].pDt.toString()),
                                //   Jiffy(listOfPostsTop10[index]["p_dt"])
                                //       .fromNow(),
                                //   style: TextStyle(
                                //       color: Colors.grey.withOpacity(0.8)),
                                // ),
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),

                      Divider(
                        color: Colors.grey,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      // Body
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              listOfPostsTop10![index]["p_tit"],
                              style: TextStyle(
                                  color: Colors.grey.shade800,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              Jdf,
                              style: TextStyle(
                                color: Colors.grey.shade800,
                                fontSize: 18,

                                // fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(3.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: mainBlue)),
                                  child: Text(
                                    listOfPostsTop10![index]["cat_name"],
                                    style: TextStyle(
                                        color: mainBlue, fontSize: 15),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  padding: const EdgeInsets.all(3.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: mainBlue)),
                                  child: Text(
                                    priority,
                                    style: TextStyle(
                                        color: mainBlue, fontSize: 15),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),

                      Divider(color: Colors.grey),
                      SizedBox(
                        height: 10,
                      ),
                      // Footer
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          (listOfPostsTop10![index]["p_ctyp"] == "0")
                              ? InkWell(
                                  onTap: () {
                                    _callClick(
                                        listOfPostsTop10![index]["p_id"],
                                        uid,
                                        listOfPostsTop10![index]["u_id"],
                                        uid,
                                        listOfPostsTop10![index]["u_phn"]);
                                  },
                                  child: Icon(
                                    Icons.call,
                                    size: 23,
                                    color: mainBlue,
                                  ),
                                )
                              : Icon(
                                  Icons.phone_disabled,
                                  size: 23,
                                  color: Colors.grey,
                                ),
                          InkWell(
                            onTap: () {
                              _msgClick(
                                  int.parse(listOfPostsTop10![index]["u_id"]),
                                  uid,
                                  int.parse(listOfPostsTop10![index]["p_id"]),
                                  listOfPostsTop10![index]["u_img"],
                                  listOfPostsTop10![index]["u_nm"]);
                            },
                            child: Icon(
                              Icons.message,
                              size: 23,
                              color: mainBlue,
                            ),
                          ),
                          // SimpleAccountMenu(),
                          InkWell(
                            onTap: () {
                              var shareText = listOfPostsTop10![index]
                                      ["p_tit"] +
                                  '\n' +
                                  SJdf;
                              // Share.share(shareText);
                            },
                            child: Icon(
                              Icons.share_outlined,
                              size: 23,
                              color: mainBlue,
                            ),
                          ),
                          // InkWell(
                          //   onTap: () {
                          //     print(listOfPostsTop10[index]["issaved"]);
                          //     _savePost(listOfPostsTop10[index]["p_id"]);

                          //     AlertDialog();
                          //   },
                          //   child: Icon(
                          //     listOfPostsTop10[index]["issaved"] == "1"
                          //         ? CupertinoIcons.info_circle_fill
                          //         : CupertinoIcons.info_circle_fill,
                          //     size: 23,
                          //     color: mainBlue,
                          //   ),
                          // ),
                          // Icon(
                          //   CupertinoIcons.info_circle,
                          //   size: 23,
                          //   color: mainBlue,
                          // )

                          // Icon(
                          //   Icons.bookmark,
                          //   color: mainBlue,
                          // )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

// Offline requests
  _fetchPosts() {
    final FocusNode _focusNode = FocusNode();
    var priority;
    // var uid = await User().getUID();
    // print(uid);
    return FutureBuilder(
      future: DBProvider.db.getAllEmployees(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          // _getPosts();
          return Center(
              // child: CircularProgressIndicator(),
              child: Center(
                  child:
                      Image.asset("assets/images/page_load.gif", height: 50)));
          // return SizedBox(
          //   width: 200.0,
          //   height: 100.0,
          //   child: Shimmer.fromColors(
          //     baseColor: Colors.red,
          //     highlightColor: Colors.yellow,
          //     child: Text(
          //       'Shimmer',
          //       textAlign: TextAlign.center,
          //       style: TextStyle(
          //         fontSize: 40.0,
          //         fontWeight: FontWeight.bold,
          //       ),
          //     ),
          //   ),
          // );

          // return ListView.builder(
          //   itemCount: 10,
          //   // Important code
          //   itemBuilder: (context, index) => Shimmer.fromColors(
          //       baseColor: Colors.grey[400],
          //       highlightColor: Colors.white,
          //       child: Text("Loading...")),
          // );
        } else {
          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              if (snapshot.data[index].pPriority == "0") {
                priority = "One Day";
              } else if (snapshot.data[index].pPriority == "1") {
                priority = "One Week";
              } else if (snapshot.data[index].pPriority == "2") {
                priority = "One Month";
              }
              String Jd = snapshot.data[index].pJd;
              String Downlink =
                  "\n Download App Now: https://play.google.com/store/apps/details?id=com.fewnix.goffix";
              // String Jd1 = Jd + Downlink;
              String Jdf = Jd.replaceAll("<br/>", "\n");
              String SJdf = Jdf + Downlink;
              return Container(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(35),
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
                      padding: const EdgeInsets.only(
                          top: 15, left: 15, bottom: 15, right: 10),
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            // Header
                            Row(
                              children: <Widget>[
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: snapshot.data[index].uImg == null
                                      ? Image.asset(
                                          'assets/images/male.png',
                                          height: 70,
                                        )
                                      : snapshot.data[index].uImg ==
                                              ("file:///android_asset/www/images/male.png")
                                          ? Image.asset(
                                              'assets/images/male.png',
                                              height: 70,
                                            )
                                          : Image.memory(
                                              image_64(
                                                  snapshot.data[index].uImg),
                                              // Image.asset(
                                              //   'assets/images/profile.jpg',
                                              height: 70,
                                              // ),
                                            ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        snapshot.data[index].uNm,
                                        style: TextStyle(
                                            color: Colors.grey.shade700,
                                            fontSize: 20,
                                            // fontFamily: "Titillium Web",
                                            fontFamily: "Lato",
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            CupertinoIcons.placemark_fill,
                                            size: 20,
                                            color: mainBlue.withOpacity(0.8),
                                          ),
                                          Text(snapshot.data[index].locName,
                                              style: TextStyle(
                                                  color:
                                                      mainBlue.withOpacity(0.5),
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                      // Text(
                                      //   // snapshot.data[index].pDt.toString(),
                                      //   // TimeAgo.timeAgoSinceDate(
                                      //   //     snapshot.data[index].pDt.toString()),
                                      //   Jiffy(snapshot.data[index].pDt)
                                      //       .fromNow(),
                                      //   style: TextStyle(
                                      //       color:
                                      //           Colors.grey.withOpacity(0.8)),
                                      // ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),

                            Divider(
                              color: Colors.grey,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            // Body
                            Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    snapshot.data[index].pTit,
                                    style: TextStyle(
                                        color: Colors.grey.shade800,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    Jdf,
                                    style: TextStyle(
                                      color: Colors.grey.shade800,
                                      fontSize: 18,

                                      // fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(3.0),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            border:
                                                Border.all(color: mainBlue)),
                                        child: Text(
                                          snapshot.data[index].catName,
                                          style: TextStyle(
                                              color: mainBlue, fontSize: 15),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(3.0),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            border:
                                                Border.all(color: mainBlue)),
                                        child: Text(
                                          priority,
                                          style: TextStyle(
                                              color: mainBlue, fontSize: 15),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),

                            Divider(color: Colors.grey),
                            SizedBox(
                              height: 10,
                            ),
                            // Footer
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                // SimpleAccountMenu(
                                //   offClick: (context) {
                                //     FocusScope.of(context).unfocus();
                                //     _overlayEntry.remove();
                                //     // closeMenu();
                                //   },
                                //   icons: [
                                //     Icon(Icons.call),
                                //     Icon(Icons.message),
                                //   ],
                                //   iconColor: Colors.white,
                                //   onChange: (index1) {
                                //     print(index1);
                                //     if (index1 == 0) {
                                //       _callClick(
                                //           snapshot.data[index].pId,
                                //           uid,
                                //           snapshot.data[index].uId,
                                //           uid,
                                //           snapshot.data[index].uPhn);
                                //     } else {
                                //       _msgClick(
                                //           int.parse(snapshot.data[index].uId),
                                //           uid,
                                //           int.parse(snapshot.data[index].pId),
                                //           snapshot.data[index].uImg,
                                //           snapshot.data[index].uNm);
                                //     }
                                //   },
                                // ),
                                (snapshot.data[index].pCtyp == "0")
                                    ? InkWell(
                                        onTap: () {
                                          _callClick(
                                              snapshot.data[index].pId,
                                              uid,
                                              snapshot.data[index].uId,
                                              uid,
                                              snapshot.data[index].uPhn);
                                        },
                                        child: Icon(
                                          Icons.call,
                                          size: 23,
                                          color: mainBlue,
                                        ),
                                      )
                                    : Icon(
                                        Icons.phone_disabled,
                                        size: 23,
                                        color: Colors.grey,
                                      ),
                                InkWell(
                                  onTap: () {
                                    _msgClick(
                                        int.parse(snapshot.data[index].uId),
                                        uid,
                                        int.parse(snapshot.data[index].pId),
                                        snapshot.data[index].uImg,
                                        snapshot.data[index].uNm);
                                  },
                                  child: Icon(
                                    Icons.message,
                                    size: 23,
                                    color: mainBlue,
                                  ),
                                ),
                                // SimpleAccountMenu(),
                                InkWell(
                                  onTap: () {
                                    var shareText =
                                        snapshot.data[index].pTit + '\n' + SJdf;
                                    // Share.share(shareText);
                                  },
                                  child: Icon(
                                    Icons.share_outlined,
                                    size: 23,
                                    color: mainBlue,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    print(snapshot.data[index].issaved);
                                    _savePost(snapshot.data[index].pId);
                                  },
                                  child: Icon(
                                    snapshot.data[index].issaved == "1"
                                        ? CupertinoIcons.bookmark_fill
                                        : CupertinoIcons.bookmark,
                                    size: 23,
                                    color: mainBlue,
                                  ),
                                ),
                                // Icon(
                                //   CupertinoIcons.info_circle,
                                //   size: 23,
                                //   color: mainBlue,
                                // )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  _buildListItem(String foodName, String price, Color bgColor, Color textColor,
      String code) {
    return Padding(
        padding: EdgeInsets.only(left: 15.0),
        child: InkWell(
            onTap: () {
              //ToDo
              // Navigator.of(context).push(MaterialPageRoute(
              //   builder: (context) => BurgerPage(heroTag: foodName, foodName: foodName, pricePerItem: price, imgPath: imgPath)
              // ));
            },
            child: Container(
                height: 164.0,
                width: 120.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  color: bgColor,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 30, left: 15, bottom: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Column(
                        children: [
                          Row(
                            // mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              // Image.asset(
                              //   imgPath,
                              //   height: 20.0,
                              // ),
                              // SizedBox(
                              //   width: 5,
                              // ),
                              Padding(
                                padding: const EdgeInsets.only(left: 0),
                                child: Text(
                                  foodName,
                                  style: TextStyle(
                                      fontFamily: "Lato",
                                      fontSize: 18,
                                      color: textColor,
                                      letterSpacing: .6,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            // crossAxisAlignment: CrossAxisAlignment.,
                            children: <Widget>[
                              Text(
                                price,
                                style: TextStyle(
                                    fontFamily: "Lato",
                                    fontSize: 13,
                                    color: textColor,
                                    letterSpacing: .6,
                                    height: 1.4,
                                    fontWeight: FontWeight.w400),
                              )
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Icon(
                          //   Icons.phone_android,
                          //   color: Colors.white,
                          //   size: 16,
                          // ),
                          Text(
                            code,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontFamily: "Lato",
                              fontWeight: FontWeight.w200,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ))));
  }
}
