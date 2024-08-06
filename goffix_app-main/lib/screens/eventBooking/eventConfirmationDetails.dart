import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:goffix/constants.dart';

class EventConfirmationDetails extends StatefulWidget {
  const EventConfirmationDetails({Key? key}) : super(key: key);

  @override
  State<EventConfirmationDetails> createState() =>
      _EventConfirmationDetailsState();
}

class _EventConfirmationDetailsState extends State<EventConfirmationDetails> {
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
                  "Details",
                  style: TextStyle(color: mainBlue),
                ),
                // Image.asset("assets/images/go_del.png", height: 60),
              ),
            )
          ],
        ),
      ),
      body: Container(
        height: 800,
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
              "JBYQCDTWW",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            Divider(),
            SizedBox(
              width: 150,
              child: Image.network(
                  'https://pngimg.com/uploads/qr_code/qr_code_PNG26.png'),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Deal/Event",
                    style: TextStyle(fontSize: 12),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: Text(
                      "ClarityBrew Life Management Coaching",
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Location",
                    style: TextStyle(fontSize: 12),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: Text(
                      "Online",
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Coupon Code",
                    style: TextStyle(fontSize: 12),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: Text(
                      "JBYQCDTWW",
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Bill Amount",
                    style: TextStyle(fontSize: 12),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: Text(
                      "Free",
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Date/Time",
                    style: TextStyle(fontSize: 12),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: Text(
                      "14 Feb 2023 02:00 PM - 04:00 PM",
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Order Date",
                    style: TextStyle(fontSize: 12),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: Text(
                      "13 Feb 2023 03:47 pm",
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
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
              "VIEW ORDER",
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
