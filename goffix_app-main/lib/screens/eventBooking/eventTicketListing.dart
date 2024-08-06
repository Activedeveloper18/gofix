import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:goffix/constants.dart';
import 'package:goffix/screens/eventBooking/eventConfirmation.dart';
import 'package:goffix/screens/home/models/eventTicketPageModel.dart';
import 'package:goffix/screens/home/providers/eventTicketProvider.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class EventTicketListing extends StatefulWidget {
  List? inputTextList = [];
  String? eventAddId;
  List<EventTicketItem>? eventTicketId;
  EventTicketListing(
      {Key? key, this.inputTextList, this.eventAddId, this.eventTicketId})
      : super(key: key);

  @override
  State<EventTicketListing> createState() => _EventTicketListingState();
}

class _EventTicketListingState extends State<EventTicketListing> {
  @override
  Widget build(BuildContext context) {
    var eventProvider = Provider.of<EventTicketProvider>(context);
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
                  "Visitors",
                  style: TextStyle(color: mainBlue),
                ),
                // Image.asset("assets/images/go_del.png", height: 60),
              ),
            )
          ],
        ),
      ),
      body: ListView.builder(
        // physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: eventProvider.myTextListController.length,
        itemBuilder: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15, top: 10),
                child: Text(
                  eventProvider.list[index].ticketPriceInfo!,
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                ),
              ),
              ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount:
                      int.parse(eventProvider.myTextListController[index].text),
                  itemBuilder: (context, i) {
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
                          Padding(
                            padding: const EdgeInsets.only(left: 15, top: 10),
                            child: Text(
                              // eventProvider.list[i].ticketPriceInfo,
                              "visitor ${i + 1}",
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 15, right: 15, top: 10),
                            child: TextField(
                              obscureText: true,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Name',
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 15, right: 15, top: 10),
                            child: TextField(
                              obscureText: true,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Email',
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 15, right: 15, top: 10, bottom: 10),
                            child: TextField(
                              obscureText: true,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Phone Number',
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
            ],
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
                            builder: (context) => EventConfirmation()));
                  }
                : null,
            child: Text(
              "PROCEED",
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
