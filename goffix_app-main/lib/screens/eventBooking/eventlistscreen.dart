import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:goffix/screens/eventBooking/event_booking.dart';
import 'package:goffix/screens/eventBooking/eventscreen.dart';

import '../../constants.dart';
import '../add/AddScreen.dart';
import 'deliverypage.dart';

class EventListScreen extends StatefulWidget {
  const EventListScreen();

  @override
  State<EventListScreen> createState() => _EventListscreenState();
}

class _EventListscreenState extends State<EventListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 150,
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 30,
        bottomOpacity: 0.8,
        toolbarHeight: 60,
        leading: InkWell(
          onTap: () {},
          child: Image.asset(
            'assets/images/logo.png',
            fit: BoxFit.fitWidth,
            height: 80,
            width: 100,
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Eventscreen()));
              },
              child: Container(
                height: 250,
                width: MediaQuery.of(context).size.width * 8,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/2807471.jpg"),
                        fit: BoxFit.cover),
                    // color: Colors.blue,
                    borderRadius: BorderRadius.circular(10)),
                // child: Column(),
              ),
            ),
            10.verticalSpace,
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Deliverypagescreen()));
              },
              child: Container(
                height: 800,
                width: MediaQuery.of(context).size.width * 8,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/poster.jpg"),
                        fit: BoxFit.contain),
                    // color: Colors.blue,
                    borderRadius: BorderRadius.circular(10)),
                // child: Column(),
              ),
            ),
            20.verticalSpace
          ],
        ),
      ),
      // body: ListView.builder(itemBuilder: (context, index) {
      //   return Padding(
      //     padding: const EdgeInsets.all(8.0),
      //     child: InkWell(
      //       onTap: (){
      //         Navigator.push(context, MaterialPageRoute(builder: (context)=>Eventscreen()));
      //       },
      //       child: Container(
      //         height: 250,
      //         width: MediaQuery.of(context).size.width * 8,
      //         decoration: BoxDecoration(
      //             image: DecorationImage(
      //                 image: AssetImage("assets/images/2807471.jpg"),
      //                 fit: BoxFit.cover),
      //             // color: Colors.blue,
      //             borderRadius: BorderRadius.circular(10)),
      //         // child: Column(),
      //       ),
      //     ),
      //
      //   );
      // }),
    );
  }
}
