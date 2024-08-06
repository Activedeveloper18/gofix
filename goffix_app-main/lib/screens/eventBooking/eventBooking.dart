import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:goffix/constants.dart';
import 'package:goffix/screens/eventBooking/eventTicketListing.dart';
import 'package:goffix/screens/home/providers/eventTicketProvider.dart';
import 'package:goffix/screens/home/providers/homeProvider.dart';
import 'package:intl/intl.dart';
import 'package:number_inc_dec/number_inc_dec.dart';
import 'package:provider/provider.dart';

class EventBooking extends StatefulWidget {
  String? eventTitle;
  DateTime? eventDate;
  String? id;
  EventBooking({
    Key? key,
    this.eventTitle,
    this.eventDate,
    this.id,
  }) : super(key: key);

  @override
  State<EventBooking> createState() => _EventBookingState();
}

class _EventBookingState extends State<EventBooking> {
  displayDate(DateTime date) {
    String formattedDate = DateFormat('dd-MM-yyyy').format(date);
    return formattedDate;
  }

  int _itemCount = 0;

  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(
        () => context.read<EventTicketProvider>().getAllTicketsData(widget.id!));
  }

  @override
  Widget build(BuildContext context) {
    var eventProvider = Provider.of<EventTicketProvider>(context);
    // List<bool> _isClicked =
    //     List<bool>.filled(eventProvider.list.length, false, growable: true);
    return Scaffold(
      backgroundColor: Colors.white,
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
              child: Center(
                child: Text(
                  "Select Ticket",
                  style: TextStyle(color: mainBlue),
                ),
                // Image.asset("assets/images/go_del.png", height: 60),
              ),
            )
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: eventProvider.list.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.all(14),
            padding: EdgeInsets.all(10),
            decoration: new BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Color.fromARGB(255, 255, 255, 255),
                boxShadow: [
                  new BoxShadow(
                    color: Colors.grey,
                    blurRadius: 20.0,
                  ),
                ]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text(
                    eventProvider.list[index].ticketPriceInfo!,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Text(eventProvider.list[index].ticketPrice!),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    eventProvider.isClicked[index] == false
                        ? ElevatedButton(
                            onPressed: () => eventProvider.addClick(index),
                            child: Text("ADD"))
                        : Container(),
                  ],
                ),
                eventProvider.isClicked[index] == true
                    // _isClicked.indexWhere((selected) => selected == true) != -1
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: 100,
                            child: NumberInputPrefabbed.roundedButtons(
                              controller:
                                  eventProvider.myTextListController[index],
                              onChanged: ((newValue) {
                                // print(newValue);
                              }),
                              onIncrement: ((newValue) {
                                // print(newValue);
                                // print(eventProvider
                                //     .myTextListController[index].text);
                                // print("index value$index");
                              }),
                              onDecrement: ((newValue) {
                                // print(newValue);
                              }),
                              initialValue: 1,
                              incDecBgColor: Colors.grey,
                              scaleHeight: 0.7,
                              decIconSize: 20.0,
                              incIconSize: 20.0,
                              incIconColor: Colors.white,
                              decIconColor: Colors.white,
                              incIcon: Icons.add,
                              decIcon: Icons.remove,
                              buttonArrangement:
                                  ButtonArrangement.incRightDecLeft,
                            ),
                          ),
                        ],
                      )
                    : Container(),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Column(
                    children: [
                      Text(
                        eventProvider.list[index].ticketPriceInfo!,
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        height: 50,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
            onPressed: eventProvider.isClicked.contains(true)
                ? () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EventTicketListing(
                                  inputTextList:
                                      eventProvider.myTextListController,
                                  eventAddId: widget.id!,
                                  eventTicketId: eventProvider.list,
                                )));
                  }
                : null,
            child: Text(
              "CONTINUE",
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
