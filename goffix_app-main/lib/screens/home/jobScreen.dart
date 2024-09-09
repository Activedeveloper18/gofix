import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../constants.dart';
import '../../utils/const_list.dart';
import '../add/AddScreen.dart';

class JobScreen extends StatefulWidget {
  const JobScreen();

  @override
  State<JobScreen> createState() => _JobScreenState();
}

class _JobScreenState extends State<JobScreen> {
  @override
  Widget build(BuildContext context) {
    double screen_width = MediaQuery.of(context).size.width;
    double screen_height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        // leading: SizedBox(),
        actions: [
          Container(
            padding: EdgeInsets.all(8),
            child: ElevatedButton.icon(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0)),
                  ),
                  elevation: MaterialStateProperty.all(0),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                  backgroundColor: MaterialStateProperty.all(mainBlue)),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddScreen()));
              },
              icon: Icon(Icons.arrow_circle_right_rounded),
              label: Text("Post a Job"),
            ),
          )
        ],
        backgroundColor: Colors.white,
        elevation: 30,
        bottomOpacity: 0.8,
        toolbarHeight: 65,
        leadingWidth: 100,
        leading: InkWell(
          onTap: () {
            // fetchPost();
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Image.asset(
              'assets/images/jobpagelogo.png',
              fit: BoxFit.contain,
              height: 100,
              width: 120,
            ),
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  end: Alignment.topCenter,
                  begin: Alignment.center,
                  colors: [
                Colors.white,
                Colors.orange.shade50,
              ])),
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: screen_width,
                  height: 80,
                  // color: Colors.deepOrange,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Welcome Madhu",
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          Text(
                            "Find Every Job in One Place",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 60,
                        child: Image.asset("assets/images/logox.png"),
                      )
                    ],
                  ),
                ),
                // search job
                SizedBox(
                  width: screen_width * 0.95,
                  // height: 60,
                  child: TextField(
                    decoration: InputDecoration(
                        // contentPadding: EdgeInsets.only(right: 5),
                        suffixIcon: Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: Container(
                              decoration: BoxDecoration(
                                  color:
                                      Colors.deepOrangeAccent.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(5)),
                              child: IconButton(
                                icon: Icon(Icons.search),
                                onPressed: () {},
                              )),
                        ),
                        hintText: "Search job  at your location",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        )),
                  ),
                ),

                // poster slider carousel slider
                Container(
                  height: 250,
                  // padding: EdgeInsets.all(5),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  child: CarouselSlider(
                    options: CarouselOptions(height: 400.0),
                    items: imagesList.map((i) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  // image: DecorationImage(
                                  //
                                  //     image: AssetImage('$i'))
                                ),
                                child: Image.asset('$i')),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
                // recommanded jobs
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Recommended jobs",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Text(
                          "Based on your performance",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.view_list_sharp,
                          size: 45,
                        ))
                  ],
                ),

                // carsouls
                Container(
                  height: 200,
                  // padding: EdgeInsets.all(5),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  child: CarouselSlider(
                    options: CarouselOptions(height: 400.0),
                    items: jobList.map((i) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 5,
                                        spreadRadius: 2)
                                  ]),
                              child: Row(
                                children: [
                                  Container(
                                      padding: EdgeInsets.all(5),
                                      width: screen_width / 4,
                                      child: Image(
                                        image: AssetImage(i),
                                        fit: BoxFit.fitHeight,
                                      )),
                                  Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        SizedBox(
                                          width: screen_width / 2,
                                          child: Text(
                                            "Business  Developer Manager",
                                            maxLines: 2,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge!
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.w500),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Icon(Icons.corporate_fare),
                                            Text(
                                              "Company Name",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Icon(Icons.pin_drop_outlined),
                                            Text(
                                              "Bangalore",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Icon(Icons.wallet_outlined),
                                            Text(
                                              "25K - 40K / month",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Icon(Icons.work_outline),
                                            Text(
                                              "Full Time",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),

                // location jobs
                Row(
                  children: [
                    SizedBox(
                        height: 80,
                        child: Image(
                            image: AssetImage(
                                "assets/images/vizaglocation.jpeg"))),
                    Column(
                      children: [
                        Text(
                          "Vizag Jobs",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(fontWeight: FontWeight.w500),
                        ),
                        Row(
                          children: [
                            Icon(Icons.pin_drop_outlined),
                            Text(
                              "Bangalore",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        Text("3 months ago",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(fontWeight: FontWeight.w500)),
                      ],
                    )
                  ],
                ),
                Divider(
                  thickness: 2,
                  color: Colors.grey,
                ),

                Container(
                  // height: 300,
                  width: screen_width,
                  child: Text("We are looking for Sales Excutives ",
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .copyWith(
                              fontWeight: FontWeight.w500,
                              color: Colors.black54)),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black12,
                              blurRadius: 5,
                              spreadRadius: 2)
                        ]),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(5),
                          width: 20,
                          // child: Image(
                          //   image: AssetImage(jobList[0]),
                          //   fit: BoxFit.fitHeight,
                          // )
                        ),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: Text(
                                  "Business  Developer Manager",
                                  maxLines: 2,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(fontWeight: FontWeight.w500),
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(Icons.corporate_fare),
                                  Text(
                                    "Company Name",
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(Icons.pin_drop_outlined),
                                  Text(
                                    "Bangalore",
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(Icons.wallet_outlined),
                                  Text(
                                    "25K - 40K / month",
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(Icons.work_outline),
                                  Text(
                                    "Full Time",
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                50.verticalSpace
              ],
            ),
          ),
        ),
      ),
    );
  }
}
