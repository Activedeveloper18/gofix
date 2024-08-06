import 'dart:convert';
import 'dart:typed_data';

// import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goffix/screens/login/login.dart';
import 'package:goffix/screens/search/SearchScreen.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
// import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants.dart';

class SearchResultScreen extends StatefulWidget {
  final int? cid;
  // final String username;
  @override
  const SearchResultScreen({Key? key, this.cid}) : super(key: key);
  _SearchResultScreenState createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  late List listOfFixers;
  String Fixers = "FIXERS";
  image_64(String _img64) {
    if (_img64 != null) {
      List img = _img64.split(",");
      Uint8List _bytesImage;
      _bytesImage = Base64Decoder().convert(img[1]);
      return _bytesImage;
    }
  }

  Future _getFixers() async {
    int cid = widget.cid!;
    // int cid = 3;
    String? token = await User().getToken();
    var requestBody = {
      "service_name": "fixersOnCategorySelect",
      "param": {"cat_id": cid, "startPost": "0", "limitPost": "100"}
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
        listOfFixers = jsonResponse['response']['result']['data'];

        // for (var i = 0; i < listOfFixers.length; i++) {
        //   var ratingRequestBody = {
        //     "service_name": "userJobsCountAndWorksCountAndRating",
        //     "param": {"uid": listOfFixers[i]['u_id'], "utype": "1"}
        //   };
        //   var ratingJsonRequest = json.encode(ratingRequestBody);
        //   var ratingResponse = await http.post(baseUrl,
        //       headers: {
        //         'Accept': 'application/json',
        //         'Authorization': 'Bearer $token',
        //       },
        //       body: ratingJsonRequest);
        //   var ratingJsonResponse = null;
        //   if (ratingResponse.statusCode == 200) {
        //     ratingJsonResponse = json.decode(ratingResponse.body);

        //     // setState(() {
        //     listOfFixers[i]['rating'] =
        //         ratingJsonResponse['response']['result']['data']['rating'];
        //     listOfFixers[i]['jobs'] =
        //         ratingJsonResponse['response']['result']['data']['jobs'];
        //     listOfFixers[i]['works'] =
        //         ratingJsonResponse['response']['result']['data']['works'];
        //     // });
        //   }
        // }
        if (this.mounted) {
          setState(() {
            listOfFixers;
          });
        }
        print(listOfFixers);
        if (this.mounted) {
          setState(() {
            Fixers = jsonResponse['response']['result']['data'][0]['cat_name'];
          });
        }
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
                child: listOfFixers == null
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
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(0),
                        // physics: NeverScrollableScrollPhysics(),
                        itemCount: listOfFixers.length,
                        itemBuilder: (context, index) {
                          return _nameCards(
                              listOfFixers[index]['u_nm'],
                              listOfFixers[index]['cat_name'],
                              listOfFixers[index]['u_img'],
                              listOfFixers[index]['works'],
                              listOfFixers[index]['loc_name'],
                              listOfFixers[index]['u_phn']
                              // double.parse(listOfFixers[index]['rating'])
                              );
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

  _nameCards(String unm, String cat, String uimg, String wrks, String loc_nm,
      String u_phn) {
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
              const EdgeInsets.only(top: 15, left: 15, bottom: 15, right: 0),
          child: Container(
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.end,
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // mainAxisAlignme,
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
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              minWidth: 150.0,
                              maxWidth: 250.0,
                              // minHeight: 30.0,
                              // maxHeight: 100.0,
                            ),
                            // child:
                                // AutoSizeText(
                                //   unm,
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
                            //     Text(
                            //   unm.length > 20
                            //       ? toBeginningOfSentenceCase(unm)
                            //               .substring(0, 20) +
                            //           '...'
                            //       : toBeginningOfSentenceCase(unm),
                            //   style: TextStyle(
                            //       color: Colors.grey.shade700,
                            //       fontSize: 20,
                            //       // fontFamily: "Titillium Web",
                            //       fontFamily: "Lato",
                            //       fontWeight: FontWeight.bold),
                            // ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Text(loc_nm,
                                  style: TextStyle(
                                      color: mainBlue.withOpacity(0.5),
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          // Row(
                          //   children: [
                          //     // SmoothStarRating(
                          //     //   // color: Colors.yellow,
                          //     //   color: mainOrange,
                          //     //   isReadOnly: true,
                          //     //   borderColor: mainOrange,
                          //     //   rating: rating,
                          //     //   size: 30,
                          //     //   starCount: 5,
                          //     // )
                          //   ],
                          // )
                        ],
                      ),
                    ),
                    Spacer(),
                    Expanded(
                      child: InkWell(
                          onTap: () {
                            print(u_phn);
                            Alert(
                              context: context,
                              type: AlertType.warning,
                              title: "Disclaimer",
                              desc:
                                  "Goffix is not Liable to Charges/Service Quality/Pricing by the servicers in this section. \n ",
                              buttons: [
                                DialogButton(
                                  // height: 70,
                                  child: Text(
                                    "Call",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                  onPressed: () {
                                    print(unm);
                                    launch('tel:' + u_phn);
                                  },
                                  width: 150,
                                ),
                              ],
                            ).show().then((value) {
                              print(value);
                              //
                            });
                          },
                          child: Icon(
                            Icons.call,
                            color: mainBlue,
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
    );
  }
}
