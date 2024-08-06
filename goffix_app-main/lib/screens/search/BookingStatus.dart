import 'dart:convert';
import 'dart:typed_data';

// import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goffix/screens/login/login.dart';
import 'package:goffix/screens/search/SearchScreen.dart';
import 'package:goffix/screens/search/cancelService.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
// import 'package:jiffy/jiffy.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
// import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:goffix/screens/login/login.dart' as Login;
import 'package:timeline_tile/timeline_tile.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants.dart';

class BookingStatusScreen extends StatefulWidget {
  // final String username;
  @override
  _BookingStatusScreenState createState() => _BookingStatusScreenState();
}

class _BookingStatusScreenState extends State<BookingStatusScreen> {
   List? listOfFixers;
   List? myBookings;
  bool noPosts = false;
  String Fixers = "Bookings";
  image_64(String _img64) {
    if (_img64 != null) {
      List img = _img64.split(",");
      Uint8List _bytesImage;
      _bytesImage = Base64Decoder().convert(img[1]);
      return _bytesImage;
    }
  }

  Future<dynamic> _myBookings() async {
    int? _uid = await Login.User().getUID();
    String? token = await Login.User().getToken();
    var requestBody = {
      "service_name": "getBookingDetails",
      "param": {"uid": _uid}
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
            myBookings = jsonResponse['response']['result']['data'];
          });
        }
        print(myBookings);
        if (myBookings!.length == 0) {
          if (this.mounted) {
            setState(() {
              noPosts = true;
            });
          }
        }
      } else if (jsonResponse["response"]["status"] == 202) {
        if (this.mounted) {
          setState(() {
            noPosts = true;
            // myBookings = null;
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
    this._myBookings();
    // this._getFixers();
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Center(
                child: Text(
                  Fixers,
                  style: TextStyle(color: mainBlue),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                launch("tel:+918074035151");
              },
              child: Container(
                  child: Row(
                children: [
                  Text(
                    "Call",
                    style: TextStyle(color: mainBlue),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Icon(Icons.call),
                ],
              )),
            ),
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
                child: myBookings == null || myBookings!.length == 0
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
                                  'No Bookings Available',
                                  style: TextStyle(
                                      fontSize: 25, color: Colors.grey),
                                ),
                              ),
                            ],
                          )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.only(top: 15.0),
                        itemCount: myBookings!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return MyPostCards(
                              myBookings![index]['Service'],
                              myBookings![index]['bookingId'],
                              myBookings![index]['date'],
                              int.parse(myBookings![index]['status']));
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

  MyPostCards(String ServiceNm, String bookingId, String time, int stat) {
    DateTime Bdt = new DateFormat("yyyy-MM-dd HH:mm:ss").parse(time);
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
            onTap: () {},
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
                            //Booking Time
                            Text(
                              DateFormat('EEEE, MMM d').format(Bdt),
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 23,
                                  fontFamily: "Lato",
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            //Service Name
                            AutoSizeText(
                              ServiceNm,
                              maxLines: 2,
                              softWrap: true,
                              minFontSize: 14,
                              // overflow: TextOverflow.fade,
                              // stepGranularity: 10,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                                // fontFamily: "Titillium Web",
                                fontFamily: "Lato",
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            //Job id
                            AutoSizeText(
                              "Job Id: #" + bookingId,
                              maxLines: 2,
                              softWrap: true,
                              minFontSize: 16,
                              // overflow: TextOverflow.fade,
                              // stepGranularity: 10,
                              style: TextStyle(
                                  color: mainBlue,
                                  fontSize: 16,
                                  // fontFamily: "Titillium Web",
                                  fontFamily: "Lato",
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            // _TimelineDelivery()

                            BookingStatus(stat: stat),

                            Container(
                              width: MediaQuery.of(context).size.width - 60,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // stat == 4
                                  //     ? SmoothStarRating(
                                  //         allowHalfRating: false,
                                  //         onRated: (v) {},
                                  //         starCount: 5,
                                  //         rating: 2,
                                  //         size: 20.0,
                                  //         isReadOnly: true,
                                  //         color: Colors.amber,
                                  //         borderColor: Colors.amber,
                                  //         spacing: 0.0)
                                  //     : Container(),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  cancelService()));
                                    },
                                    child: Text("Cancel"),
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                mainOrange)),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
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

class BookingStatus extends StatelessWidget {
  final int? stat;
  const BookingStatus({Key? key, this.stat}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.check_box,
              color: mainOrange,
              size: 18,
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              "Scheduled",
              style: TextStyle(
                  color: mainOrange,
                  fontSize: 16,
                  fontFamily: "Lato",
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Container(
            width: 1,
            height: 10,
            color: Colors.grey,
          ),
        ),
        Row(
          children: [
            Icon(
              stat! >= 1 ? Icons.check_box : Icons.check_box_outline_blank,
              color: stat! >= 1 ? mainOrange : Colors.grey,
              size: 18,
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              "Service Pro Assigned",
              style: TextStyle(
                  color: stat! >= 1 ? mainOrange : Colors.grey,
                  fontSize: 16,
                  fontFamily: "Lato",
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Container(
            width: 1,
            height: 10,
            color: Colors.grey,
          ),
        ),
        Row(
          children: [
            Icon(
              stat! >= 2 ? Icons.check_box : Icons.check_box_outline_blank,
              color: stat! >= 2 ? mainOrange : Colors.grey,
              size: 18,
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              "Service Pro On The Way",
              style: TextStyle(
                  color: stat! >= 2 ? mainOrange : Colors.grey,
                  fontSize: 16,
                  fontFamily: "Lato",
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Container(
            width: 1,
            height: 10,
            color: Colors.grey,
          ),
        ),
        Row(
          children: [
            Icon(
              stat! >= 3 ? Icons.check_box : Icons.check_box_outline_blank,
              color: stat! >= 3 ? mainOrange : Colors.grey,
              size: 18,
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              "Service Pro Has Arrived",
              style: TextStyle(
                  color: stat! >= 3 ? mainOrange : Colors.grey,
                  fontSize: 16,
                  fontFamily: "Lato",
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Container(
            width: 1,
            height: 10,
            color: Colors.grey,
          ),
        ),
        Row(
          children: [
            Icon(
              stat! >= 4 ? Icons.check_box : Icons.check_box_outline_blank,
              color: stat! >= 4 ? mainOrange : Colors.grey,
              size: 18,
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              "Job Completed",
              style: TextStyle(
                  color: stat! >= 4 ? mainOrange : Colors.grey,
                  fontSize: 16,
                  fontFamily: "Lato",
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
}

// class _DeliveryTimeline extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: const Color(0xFF379A69),
//       child: Theme(
//         data: Theme.of(context).copyWith(
//           accentColor: const Color(0xFF27AA69).withOpacity(0.2),
//         ),
//         child: SafeArea(
//           child: Scaffold(
//             appBar: _AppBar(),
//             backgroundColor: Colors.white,
//             body: Column(
//               children: <Widget>[
//                 _Header(),
//                 Expanded(child: _TimelineDelivery()),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

class _TimelineDelivery extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        // shrinkWrap: true,
        children: <Widget>[
          TimelineTile(
            alignment: TimelineAlign.start,
            lineXY: 0.1,
            isFirst: true,
            indicatorStyle: const IndicatorStyle(
              width: 20,
              color: Color(0xFF27AA69),
              padding: EdgeInsets.all(6),
            ),
            endChild:  _RightChild(
              title: 'Scheduled',
            ),
            beforeLineStyle: const LineStyle(
              color: Color(0xFF27AA69),
            ),
          ),
          TimelineTile(
            alignment: TimelineAlign.start,
            lineXY: 0.1,
            indicatorStyle: const IndicatorStyle(
              width: 20,
              color: Color(0xFF27AA69),
              padding: EdgeInsets.all(6),
            ),
            endChild:  _RightChild(
              title: 'Service Pro Assigned',
            ),
            beforeLineStyle: const LineStyle(
              color: Color(0xFF27AA69),
              thickness: 4,
            ),
          ),
          TimelineTile(
            alignment: TimelineAlign.start,
            lineXY: 0.1,
            indicatorStyle: const IndicatorStyle(
              width: 20,
              color: Color(0xFF27AA69),
              padding: EdgeInsets.all(6),
            ),
            endChild:  _RightChild(
              title: 'Service Pro on the Way',
            ),
            beforeLineStyle: const LineStyle(
              color: Color(0xFF27AA69),
            ),
          ),
          TimelineTile(
            alignment: TimelineAlign.start,
            lineXY: 0.1,
            indicatorStyle: const IndicatorStyle(
              width: 20,
              color: Color(0xFF2B619C),
              padding: EdgeInsets.all(6),
            ),
            endChild:  _RightChild(
              title: 'Service Pro Has Arrived',
            ),
            beforeLineStyle: const LineStyle(
              color: Color(0xFF27AA69),
            ),
            afterLineStyle: const LineStyle(
              color: Color(0xFFDADADA),
            ),
          ),
          TimelineTile(
            alignment: TimelineAlign.start,
            lineXY: 0.1,
            isLast: true,
            indicatorStyle: const IndicatorStyle(
              width: 20,
              color: Color(0xFFDADADA),
              padding: EdgeInsets.all(6),
            ),
            endChild: const _RightChild(
              disabled: true,
              title: 'Job Completed',
            ),
            beforeLineStyle: const LineStyle(
              color: Color(0xFFDADADA),
            ),
          ),
        ],
      ),
    );
  }
}

class _RightChild extends StatelessWidget {
  const _RightChild({
    Key? key,
    this.title,
    this.disabled = false,
  }) : super(key: key);

  final String? title;

  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                title!,
                style: GoogleFonts.yantramanav(
                  color: disabled
                      ? const Color(0xFFBABABA)
                      : const Color(0xFF636564),
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
