import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';

import '../search/BookService.dart';

class MyBookings extends StatelessWidget {
  const MyBookings();

  @override
  Widget build(BuildContext context) {
    double screen_widhth = MediaQuery.of(context).size.width;
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //     "MY BOOKINGS",
      //     style: TextStyle(fontWeight: FontWeight.w900, color: Colors.indigo),
      //   ),
      //   centerTitle: true,
      //   backgroundColor: Colors.white,
      // ),
      body: Column(
        children: [
          10.verticalSpace,
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              height: 80,
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey,
                        spreadRadius: 2.0,
                        blurRadius: 5.0,
                        offset: Offset(0, 10)),
                  ]),
              child: Text(
                "MY BOOKINGS",
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: Colors.indigo,
                    fontSize: 30),
              ),
            ),
          ),
          10.verticalSpace,
          Expanded(child:
          ListView.builder(
              itemCount: bookingServiceList.length,
              itemBuilder: (context,index){
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 200,
                width: screen_widhth * 0.95,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.indigo,
                ),
                padding: EdgeInsets.all(5),
                child: Column(
                  children: [
                    Container(
                      height: 150,
                      width: screen_widhth * 0.95,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              // color: Colors.red,
                                borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.all(20.0),
                            width: 120,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.indigo,
                                  borderRadius: BorderRadius.circular(10)),
                              height: 100,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "${
                                        bookingServiceList[index].month
                                    }",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 26,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Divider(
                                    thickness: 2,
                                    color: Colors.white,
                                    indent: 20.0,
                                    endIndent: 20.0,
                                  ),
                                  Text(
                                    "${
                                        bookingServiceList[index].date

                                    }",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 26,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${
                                    bookingServiceList[index].servicetype

                                }",
                                style: TextStyle(
                                    color: Colors.indigo,
                                    fontSize: 26,
                                    fontWeight: FontWeight.w700),
                              ),
                              Text(
                                "Job ID #1024${
                                    index

                                }",
                                style: TextStyle(
                                    color: Colors.indigo,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w300),
                              ),
                              Text(
                                "Scheduled",
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Text(
                      'View',
                      style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          fontSize: 28),
                    )
                  ],
                ),
              ),
            );
          })
          ),

        ],
      ),
    );
  }
}
