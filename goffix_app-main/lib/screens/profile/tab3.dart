import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goffix/constants.dart';
import 'package:goffix/models/profile_posts_model.dart';
import 'package:goffix/providers/db_provider.dart';
import 'package:goffix/screens/home/components/popover_button.dart';
import 'package:goffix/screens/login/login.dart';
import 'package:http/http.dart' as http;
// import 'package:jiffy/jiffy.dart';
// import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

// void main() => runApp(MyHomePage());

class TabPage extends StatefulWidget {
  @override
  _TabPageState createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> with SingleTickerProviderStateMixin {
  late List listOfActivty;
  late List listOfPostsProfile;

  late int uid;
  late String token;
  Future<dynamic> param() async {
    int? _uid = await User().getUID();
    String? _token = await User().getToken();
    if (this.mounted) {
      setState(() {
        uid = _uid!;
        token = _token!;
      });
    }
  }

  Future _chckOffline() async {
    // List temp = DBProvider.db.getAllEmployees() as List;

    // if (DBProvider.db.getAllEmployees() == null) {
    //   _getPosts();
    // }
    DBProvider.db.getAllProfilePosts().then((chkOff) {
      print(chkOff);
      if (chkOff == null) {
        _getPosts();
      }
    });
  }

  Future _getUserActivity() async {
    int? uid = await User().getUID();
    String? token = await User().getToken();
    var requestBody = {
      "service_name": "getPostedJobsActivitiesfromuid",
      "param": {"uid": uid, "utyp": 1, "startPost": 0, "limitPost": 100}
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
            listOfActivty = jsonResponse['response']['result']['data'];
          });
        }
      } else if (jsonResponse["response"]["status"] == 108) {
        // _showMyDialog("Error", "Username/Password not found", "login");
        print("Users not found");
      } else {
        print("Something Went Wrong");
      }
    }
  }

  Future<dynamic> _getPosts() async {
    int fxid = 25;
    int? _uid = await User().getUID();
    // int fxid = _uid;
    String? _token = await User().getToken();
    var requestBody = {
      "service_name": "getUserPostedJobsByID",
      "param": {
        "sessionid": _uid,
        "uid": _uid,
        "startPost": "0",
        "limitPost": "20"
      }
    };
    var jsonRequest = json.encode(requestBody);
    print(jsonRequest);
    var response = await http.post(baseUrl,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $_token',
        },
        body: jsonRequest);
    var jsonResponse = null;
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse["response"]["status"] == 200) {
        if (this.mounted) {
          setState(() {
            listOfPostsProfile = jsonResponse['response']['result']['data'];
          });
        }
        // DBProvider.db.deleteAllProfilePosts();
        // return (listOfPostsProfile as List).map((posts) {
        //   print('Inserting $posts');
        //   DBProvider.db.createProfilePosts(UserProfilePosts.fromJson(posts));
        // }).toList();

        // await Future.delayed(const Duration(seconds: 2));
        // return listOfPostsProfile;
      } else if (jsonResponse["response"]["status"] == 108) {
        // _showMyDialog("Error", "Username/Password not found", "login");
        print("No Message found");
      } else {
        print("Something Went Wrong");
      }
    }
    // return null;
  }

  image_64(String _img64) {
    if (_img64 != null) {
      List img = _img64.split(",");
      Uint8List _bytesImage;
      _bytesImage = Base64Decoder().convert(img[1]);
      return _bytesImage;
    }
  }

  Future<dynamic> _callClick(pid, fxid, fdid, _uid, phn) async {
    String? token = await User().getToken();
    int? uid = await User().getUID();
    if (fdid == fxid) {
      print("Sorry it's your Post");
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
    if (uid != fdid) {
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) =>
      //         // HomeScreen(uid: uid, username: username),
      //         MessageScreen(
      //             uid: uid,
      //             fdid: fdid,
      //             pid: pid,
      //             userimage: uimg,
      //             username: unm),
      //   ),
      // );
    } else {
      print("Its ur Post");
    }
  }

  final List<Widget> myTabs = [
    Tab(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: mainBlue, width: 1)),
        child: Align(
          alignment: Alignment.center,
          child: Text("Activity"),
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
          child: Text("Posts"),
        ),
      ),
    ),
    // Tab(text: 'three'),
  ];

  late TabController _tabController;

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    this._getUserActivity();
    this._getPosts();
    this._chckOffline();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
    super.initState();
  }

  _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      if (this.mounted) {
        setState(() {});
      }
    }
  }

  _listItem() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Colors.blueAccent,
        ),
      ),
      height: 120,
      child: Center(
        child: Text('List Item', style: TextStyle(fontSize: 20.0)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(top: .30 * size.height),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(30.0),
              topLeft: Radius.circular(30.0),
            )),
        child: Column(
          children: <Widget>[
            // _listItem(),
            SizedBox(
              height: 10,
            ),
            TabBar(
              controller: _tabController,
              unselectedLabelColor: mainBlue,
              indicatorSize: TabBarIndicatorSize.label,
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
              tabs: myTabs,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              child: [
                // Text('first tab'),

                listOfActivty == null
                    ? Center(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                child: Center(
                                  child: Text(
                                    "No Activity",
                                    style: TextStyle(
                                        color: Colors.grey[400],
                                        fontWeight: FontWeight.w600,
                                        fontSize: 20.0),
                                  ),
                                ),
                              ),
                            ]),
                      )
                    : Flexible(
                        child: Container(
                          padding: EdgeInsets.all(5),
                          height: .800 * size.height,
                          width: double.infinity,
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: listOfActivty.length,
                            itemBuilder: (context, index) {
                              if (listOfActivty.isEmpty) {
                                return Center(
                                  child: Text("No Activity"),
                                );
                              }
                              return jobCards(
                                  listOfActivty[index]['u_img'],
                                  listOfActivty[index]['u_nm'],
                                  listOfActivty[index]['ps_dt'],
                                  listOfActivty[index]['p_tit'],
                                  listOfActivty[index]['cat_name'],
                                  listOfActivty[index]['p_priority']);
                              // }),
                            },
                          ),
                        ),
                      ),
                Flexible(
                    child: Container(
                  padding: EdgeInsets.all(5),
                  height: .800 * size.height,
                  width: double.infinity,
                  child: listOfPostsProfile == null
                      ? Center(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  child: Center(
                                    child: Text(
                                      "No Posts",
                                      style: TextStyle(
                                          color: Colors.grey[400],
                                          fontWeight: FontWeight.w600,
                                          fontSize: 20.0),
                                    ),
                                  ),
                                ),
                              ]),
                        )
                      : _fetchPosts(),
                ))

                // Padding(
                //     padding: const EdgeInsets.only(left: 10, right: 10),
                //     child: SingleChildScrollView(
                //         physics: NeverScrollableScrollPhysics(),
                //         child: Container(
                //           child: listOfActivty == null
                //               ? Center(
                //                   child: CircularProgressIndicator(),
                //                 )
                //               : ListView.builder(
                //                   physics: NeverScrollableScrollPhysics(),
                //                   shrinkWrap: true,
                //                   itemCount: listOfActivty.length,
                //                   itemBuilder: (context, index) {
                //                     if (listOfActivty.isEmpty) {
                //                       return Center(
                //                         child: Text("No Activity"),
                //                       );
                //                     }
                //                     return jobCards(
                //                         listOfActivty[index]['u_img'],
                //                         listOfActivty[index]['u_nm'],
                //                         listOfActivty[index]['ps_dt'],
                //                         listOfActivty[index]['p_tit'],
                //                         listOfActivty[index]['cat_name'],
                //                         listOfActivty[index]['p_priority']);
                //                   }),
                //         ))),

                // Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     mainAxisSize: MainAxisSize.max,
                //     // padding: const EdgeInsets.only(left: 10, right: 10),
                //     children: [
                //       Container(
                //         // physics: NeverScrollableScrollPhysics(),
                //         child: Container(
                //           child: listOfPostsProfile == null
                //               ? Center(
                //                   child: Container(
                //                     child: Text("No Posts"),
                //                   ),
                //                 )
                //               : _fetchPosts(),
                //         ),
                //       ),
                //     ]),
                // Column(
                //   children: [
                //     Text('third tab'),
                //     ...List.generate(100, (index) => Text('line: $index'))
                //   ],
                // ),
              ][_tabController.index],
            ),
          ],
        ),
      ),
    );
  }

  jobCards(String uimg, String unm, String dt, String tit, String catName,
      String priority) {
    if (priority == "0") {
      priority = "One Day";
    } else if (priority == "1") {
      priority = "One Week";
    } else if (priority == "2") {
      priority = "One Month";
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
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
          child: Container(
            child: Column(
              children: <Widget>[
                // Header
                Row(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: uimg == null
                          ? Image.asset(
                              'assets/images/profile.jpg',
                              height: 70,
                            )
                          : Image.memory(
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            unm,
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
                              Text("Visakhapatnam",
                                  style: TextStyle(
                                      color: mainBlue.withOpacity(0.5),
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          // Text(
                          //   Jiffy(dt).fromNow(),
                          //   style:
                          //       TextStyle(color: Colors.grey.withOpacity(0.8)),
                          // ),
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(height: 10),
                Divider(color: Colors.grey),
                SizedBox(height: 10),
                // Body
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        tit,
                        style: TextStyle(
                            color: Colors.grey.shade800,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(3.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: mainBlue)),
                            child: Text(
                              catName,
                              style: TextStyle(color: mainBlue, fontSize: 15),
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
                              style: TextStyle(color: mainBlue, fontSize: 15),
                            ),
                          )
                        ],
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.fromLTRB(0, 8.0, 8.0, 8.0),
                      //   child: Container(
                      //     alignment: Alignment.center,
                      //     width: 140,
                      //     child: RaisedButton(
                      //       shape: RoundedRectangleBorder(
                      //         borderRadius: BorderRadius.circular(18.0),
                      //       ),
                      //       elevation: 10,
                      //       textColor: Colors.white,
                      //       onPressed: () => {},
                      //       color: mainOrange,
                      //       splashColor: mainBlue,
                      //       // padding: EdgeInsets.all(10.0),
                      //       child: Row(
                      //         // Replace with a Row for horizontal icon + text
                      //         children: <Widget>[
                      //           Icon(Icons.add),
                      //           Text("Work Done")
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      // )
                    ],
                  ),
                ),
                // SizedBox(
                //   height: 10,
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

//Posts

  _fetchPosts() {
    final FocusNode _focusNode = FocusNode();
    var priority;
    // var uid = await User().getUID();
    // print(uid);

    return Container(
      // physics: NeverScrollableScrollPhysics(),
      child: FutureBuilder(
        future: DBProvider.db.getAllProfilePosts(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            // _getPosts();
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.builder(
              // physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
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
                String Jdf = Jd.replaceAll("<br/>", "\n");
                return Container(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        bottom: 20, top: 20, left: 10, right: 10),
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
                            top: 10, left: 15, bottom: 15, right: 10),
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
                                            'assets/images/profile.jpg',
                                            height: 70,
                                          )
                                        : Image.memory(
                                            image_64(snapshot.data[index].uImg),
                                            // Image.asset(
                                            //   'assets/images/profile.jpg',
                                            height: 70,
                                            // ),
                                          ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
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
                                                    color: mainBlue
                                                        .withOpacity(0.5),
                                                    fontWeight:
                                                        FontWeight.bold)),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
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
                                  // (snapshot.data[index].pCtyp == "0")
                                  //     ? InkWell(
                                  //         onTap: () {
                                  //           _callClick(
                                  //               snapshot.data[index].pId,
                                  //               uid,
                                  //               snapshot.data[index].uId,
                                  //               uid,
                                  //               snapshot.data[index].uPhn);
                                  //         },
                                  //         child: Icon(
                                  //           Icons.call,
                                  //           size: 23,
                                  //           color: mainBlue,
                                  //         ),
                                  //       )
                                  //     :
                                  Icon(
                                    Icons.call,
                                    size: 23,
                                    color: Colors.grey,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      // _msgClick(
                                      //     int.parse(snapshot.data[index].uId),
                                      //     uid,
                                      //     int.parse(snapshot.data[index].pId),
                                      //     snapshot.data[index].uImg,
                                      //     snapshot.data[index].uNm);
                                    },
                                    child: Icon(
                                      Icons.message,
                                      size: 23,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  // SimpleAccountMenu(),
                                  InkWell(
                                    onTap: () {
                                      var shareText =
                                          snapshot.data[index].pTit +
                                              '\n' +
                                              Jdf;
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
                                      // _savePost(snapshot.data[index].pId);
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
      ),
    );
  }
}
