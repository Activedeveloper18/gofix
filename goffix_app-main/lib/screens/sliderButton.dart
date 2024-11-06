import 'package:flutter/material.dart';
import 'package:goffix/constants.dart';
import 'package:slider_button/slider_button.dart';

class SlideButtonScreen extends StatefulWidget {
  @override
  _SlideButtonScreenState createState() => _SlideButtonScreenState();
}

class _SlideButtonScreenState extends State<SlideButtonScreen> {
  bool isPosted = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Center(
              child: SliderButton(
                action: () async {
                try {
                  print("Sliding Delivery");

                  // Uncomment if needed
                  // if (_titValError == false) {
                  //   // startTimer();
                  //   await _addPost(_postTitle.text, _postDesc.text);
                  // }

                  bool result = await _bookService();
                  return result;
                } catch (e) {
                  print("Error: $e");
                  return false;
                }},
            // action: () {
            //   ///Do something here OnSlide
            //   print("working");
            //   setState(() {
            //     isPosted = true;
            //   });
            // },

            ///Put label over here
            label: Text(
              "Slide to Post",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 17),
            ),
            icon: Center(
                child: Icon(
              Icons.add,
              color: mainOrange,
              size: 40.0,
              semanticLabel: 'Text to announce in accessibility modes',
            )),

            //Put BoxShadow here
            boxShadow: BoxShadow(
              color: Colors.transparent.withOpacity(.6),
              blurRadius: 1,
            ),

            //Adjust effects such as shimmer and flag vibration here
            shimmer: true,
            vibrationFlag: false,
            // dismissThresholds: 2.0,
            // dismissible: true,
            alignLabel: Alignment(0.0, 0),

            ///Change All the color and size from here.
            width: 300,
            radius: 20,
            buttonColor: Colors.white.withOpacity(0.8),
            // buttonColor: Colors.transparent,
            backgroundColor: mainOrange,
            highlightedColor: mainBlue,
            baseColor: Colors.white,
          )),
          isPosted
              ? Container(
                  height: 70,
                  width: 300,
                  decoration: BoxDecoration(
                      color: mainOrange,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                            child: Icon(
                          Icons.check_circle,
                          color: Colors.white,
                          size: 25.0,
                          semanticLabel:
                              'Text to announce in accessibility modes',
                        )),
                        SizedBox(
                          width: 10,
                        ),
                        Center(
                            child: Text(
                          "Posted Successfully",
                          style: TextStyle(color: Colors.white, fontSize: 17),
                        )),
                      ]),
                )
              : Container(),
          SizedBox(
            height: 30,
          ),
        ]),
      ),
    );
  }
  
  _bookService() {}
}
