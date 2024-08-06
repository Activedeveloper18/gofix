import 'dart:convert';
import 'dart:typed_data';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter_html/flutter_html.dart';
import 'package:goffix/constants.dart';
import 'package:goffix/screens/home/models/homePageModel.dart';
import 'package:goffix/screens/home/providers/homeProvider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'eventBooking.dart';

class EventListing extends StatefulWidget {
  HomeItem? aId;
  EventListing({Key? key, this.aId}) : super(key: key);

  @override
  State<EventListing> createState() => _EventListingState();
}

class _EventListingState extends State<EventListing> {
  @override
  Widget build(BuildContext context) {
    displayDate(DateTime date) {
      String formattedDate = DateFormat('dd-MM-yyyy').format(date);
      return formattedDate;
    }

    _removeDataUrl(String url) {
      if (url != null) {
        List img = url.split(",");
        return img[1];
      }
    }

    image_64(String _img64) {
      if (_img64 != null) {
        // List img = _img64.split(",");
        Uint8List _bytesImage;
        _bytesImage = Base64Decoder().convert(_img64);
        // return Image.memory(_bytesImage);
        return _bytesImage;
      }
    }

    var homeProvider = Provider.of<HomeProvider>(context);
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: mainBlue, //change your color here
        ),
        bottomOpacity: 0.8,
        toolbarHeight: 60,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              child: Center(
                child: Text(
                  "Event Booking",
                  style: TextStyle(color: mainBlue),
                ),
                // Image.asset("assets/images/go_del.png", height: 60),
              ),
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              width: MediaQuery.of(context).size.width,
              height: double.parse(widget.aId!.atypeHeight!),
              // child: Image.memory(
              //   image_64(_removeDataUrl(widget.aId.aImg)),
              //   fit: BoxFit.fill,
              //   width: 1300,
              //   // height: double.parse(i.atypeHeight),
              // ),
            ),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(15),
                  child: Text(
                    widget.aId!.aTitle!,
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                  ),
                ),
              ],
            ),
            Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                padding:
                    EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    shape: BoxShape.rectangle,
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    )),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        // widget.aId.aDt.toString(),
                        displayDate(widget.aId!.aDt!),
                        textAlign: TextAlign.start,
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        widget.aId!.aPrice!,
                        textAlign: TextAlign.end,
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                )),
            Container(
              width: MediaQuery.of(context).size.width + 74,
              padding: EdgeInsets.only(left: 25, top: 20),
              margin: EdgeInsets.all(18),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  shape: BoxShape.rectangle,
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  )),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "About",
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                  ),
                  // Html(
                  //   data: widget.aId!.aDescription,
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.all(8),
        height: 50,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EventBooking(
                            eventTitle: widget.aId!.aTitle,
                            eventDate: widget.aId!.aDt,
                            id: widget.aId!.aId,
                          )));
            },
            child: Text(
              "REGISTER",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                letterSpacing: 2,
                fontSize: 18,
              ),
            )),
      ),
    );
  }
}
