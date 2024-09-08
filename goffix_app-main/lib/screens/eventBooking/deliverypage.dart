import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:goffix/screens/eventBooking/selectedeventscreen.dart';
import 'package:slider_button/slider_button.dart';

import '../../constants.dart';
import '../add/AddScreen.dart';

class Deliverypagescreen extends StatefulWidget {
  Deliverypagescreen();

  @override
  State<Deliverypagescreen> createState() => _EventscreenState();
}

class _EventscreenState extends State<Deliverypagescreen> {
  bool _ischecked=false;
  // int _isSlider=0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 150,
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
        leading: Row(
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios)),
            InkWell(
              onTap: () {},
              child: Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.fitWidth,
                height: 80,
                width: 100,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextFormField(
              decoration: InputDecoration(
                  hintText: "Location",
                  filled: true,
                  fillColor: Colors.grey.shade300,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50))),
            ),
            10.verticalSpace,
            TextFormField(
              maxLines: 4,
              decoration: InputDecoration(
                  hintText: "Enter Delivery Address",
                  contentPadding: EdgeInsets.all(20),
                  filled: true,
                  fillColor: Colors.grey.shade300,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50))),
            ),
            10.verticalSpace,
            TextFormField(
              maxLines: 4,
              decoration: InputDecoration(
                  hintText: "Additional  Details, if any",
                  contentPadding: EdgeInsets.all(20),
                  filled: true,
                  fillColor: Colors.grey.shade300,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50))),
            ),
            10.verticalSpace,
            TextFormField(
              maxLength: 10,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[0-9]'))
              ],
              decoration: InputDecoration(
                  counterText: "",
                  hintText: "Enter Mobile Number",
                  filled: true,
                  fillColor: Colors.grey.shade300,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50))),
            ),
            10.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.verified_rounded,size: 30,color: Colors.grey.shade800,),
                    Text("Order",style: TextStyle(),),
                    Text("Confirmed",style: TextStyle(),),
                  ],
                ),
                 Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.pedal_bike,size: 30,color: Colors.grey.shade800,),
                    Text("Started",style: TextStyle(),),
                    Text("Journey",style: TextStyle(),),
                  ],
                ),
                 Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.pin_drop,size: 30,color: Colors.grey.shade800,),
                    Text("Pro",style: TextStyle(),),
                    Text("Reached",style: TextStyle(),),
                  ],
                ),
                 Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.money,size: 30,color: Colors.grey.shade800,),
                    Text("Cash on",style: TextStyle(),),
                    Text("Delivery",style: TextStyle(),),
                  ],
                ),

              ],
            ),
            Row(
              children: [
                Checkbox(value: _ischecked, onChanged: (v){
                  _ischecked=!_ischecked;
                  setState(() {

                  });
                }),
                Row(
                  children: [
                    Text("I have and agree to the "),
                    Text("Terms and Conditions ",style: TextStyle(color: Colors.blue),),
                  ],
                ),

              ],
            ),
            // Slider(value: 0.5, onChanged: (v){
            //   // _isSlider=10.0;
            //   setState(() {
            //
            //   });
            // })
            // SizedBox(
            //     height: 50,width: MediaQuery.of(context).size.width*0.9,
            //     child: ElevatedButton(onPressed: (){}, child: Text("Submit",style: TextStyle(color: Colors.white,fontSize: 24),),
            //     style: ElevatedButton.styleFrom(backgroundColor: Colors.indigoAccent),
            //     ))

            SliderButton(
              action: () {
                ///Do something here OnSlide
                print("Posting a Job");
                // if (_titValError ==
                //     false) {
                //   // startTimer();
                //   _addPost(
                //       _postTitle.text,
                //       _postDesc.text);
                // }
                // _bookService();
              },

              ///Put label over here
              label: Text(
                "Slide to Book",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight:
                    FontWeight.w500,
                    fontSize: 17),
              ),
              icon: Center(
                  child: Icon(
                    Icons.add,
                    color: mainOrange,
                    size: 40.0,
                    semanticLabel:
                    'Text to announce in accessibility modes',
                  )),

              //Put BoxShadow here
              boxShadow: BoxShadow(
                color: Colors.transparent
                    .withOpacity(.6),
                blurRadius: 10,
              ),

              //Adjust effects such as shimmer and flag vibration here
              shimmer: true,
              vibrationFlag: false,
              // dismissThresholds: 2.0,
              // dismissible:

              alignLabel: Alignment(0.0, 0),

              ///Change All the color and size from here.
              width: 300,
              radius: 20,
              buttonColor: Colors.white
                  .withOpacity(0.8),
              // buttonColor: Colors.transparent,
              backgroundColor: mainOrange,
              highlightedColor: mainBlue,
              baseColor: Colors.white,
            )
          ],
        ),
      )),
    );
  }
}
