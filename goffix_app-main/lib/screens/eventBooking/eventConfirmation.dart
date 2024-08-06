import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter_html/style.dart';
import 'package:goffix/constants.dart';
import 'package:goffix/screens/eventBooking/eventConfirmationDetails.dart';

class EventConfirmation extends StatefulWidget {
  const EventConfirmation({Key? key}) : super(key: key);

  @override
  State<EventConfirmation> createState() => _EventConfirmationState();
}

class _EventConfirmationState extends State<EventConfirmation> {
  @override
  Widget build(BuildContext context) {
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
                  "Confirmation Booking",
                  style: TextStyle(color: mainBlue),
                ),
                // Image.asset("assets/images/go_del.png", height: 60),
              ),
            )
          ],
        ),
      ),
      body: Container(
        height: 210,
        width: 500,
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
          children: [
            Text(
              "ClarityBrew Life Management Coaching",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text("Online"),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [Text("14 Feb, 2023"), Text("4 PM - 6 PM")],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Column(
                children: [
                  Text(
                    "ClarityBrew Life Management Coaching : ",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: Text(
                      "2 Tickets",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                "By continuing I agree to both the Joboy customer terms & conditions and the event terms & condition",
                style: TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 50,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EventConfirmationDetails()));
            },
            child: Text(
              "CONFIRM",
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
