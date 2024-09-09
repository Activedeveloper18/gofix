import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:goffix/screens/signup/signup.dart';
import 'package:goffix/utils/const_font.dart';

class CatagoryUserScreen extends StatefulWidget {
  // const CatagoryUserScreen({});

  @override
  State<CatagoryUserScreen> createState() => _CatagoryUserScreenState();
}

class _CatagoryUserScreenState extends State<CatagoryUserScreen> {
  int? tabindex;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Change Role ",
              style: TextStyleConst().headingLarge,
            ),
            20.verticalSpace,
            InkWell(
                onTap: () {
                  tabindex = 0;
                  setState(() {});
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => SignupScreen(catagory: tabindex ?? 1)));
                },
                child: Container(
                    decoration: BoxDecoration(boxShadow: [
                      tabindex == 0
                          ? BoxShadow(
                              color: Colors.blue,
                              spreadRadius: 2.0,
                              blurRadius: 5.0)
                          : BoxShadow(
                              color: Colors.blue,
                            )
                    ]),
                    child:
                        Image(image: AssetImage('assets/images/finder.jpg')))),
            20.verticalSpace,
            InkWell(
                onTap: () {
                  tabindex = 1;
                  setState(() {});
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => SignupScreen(catagory: tabindex ?? 1)));
                },
                child: Container(
                    decoration: BoxDecoration(boxShadow: [
                      tabindex == 1
                          ? BoxShadow(
                              color: Colors.deepOrange,
                              spreadRadius: 2.0,
                              blurRadius: 5.0)
                          : BoxShadow(
                              color: Colors.blue,
                            )
                    ]),
                    child:
                        Image(image: AssetImage('assets/images/fixer.jpg')),
                )),
          ],
        ),
      ),
    );
  }
}
