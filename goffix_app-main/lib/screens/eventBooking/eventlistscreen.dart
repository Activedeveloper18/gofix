import 'package:flutter/material.dart';
import 'package:goffix/screens/eventBooking/eventscreen.dart';

import '../../constants.dart';
import '../add/AddScreen.dart';

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
        // leading: SizedBox(),
        actions: [
          // Container(
          //   padding: EdgeInsets.all(8),
          //   child: ElevatedButton.icon(
          //     style: ButtonStyle(
          //         shape: MaterialStateProperty.all(
          //           RoundedRectangleBorder(
          //               borderRadius: BorderRadius.circular(25.0)),
          //         ),
          //         elevation: MaterialStateProperty.all(0),
          //         foregroundColor: MaterialStateProperty.all(Colors.white),
          //         backgroundColor: MaterialStateProperty.all(mainBlue)),
          //     onPressed: () {
          //       Navigator.push(context,
          //           MaterialPageRoute(builder: (context) => AddScreen()));
          //     },
          //     icon: Icon(Icons.arrow_circle_right_rounded),
          //     label: Text("Post a Job"),
          //   ),
          // )
        ],
        backgroundColor: Colors.white,
        elevation: 30,
        bottomOpacity: 0.8,
        toolbarHeight: 60,
        leading: InkWell(
          onTap: () {},
          child: Image.asset(
            'assets/images/logo.png',
            fit: BoxFit.fitWidth,
            // height: 100,
            // width: 100,
          ),
        ),
      ),
      body: ListView.builder(itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>Eventscreen()));
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

        );
      }),
    );
  }
}
