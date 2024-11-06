import 'package:flutter/material.dart';
import 'package:goffix/screens/eventBooking/selectedeventscreen.dart';

import '../../constants.dart';
import '../add/AddScreen.dart';

class Eventscreen extends StatefulWidget {
  Eventscreen({required eveId});

  @override
  State<Eventscreen> createState() => _EventscreenState();
}

class _EventscreenState extends State<Eventscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 150,
        // actions: [
        //   Container(
        //     padding: EdgeInsets.all(8),
        //     child: ElevatedButton.icon(
        //       style: ButtonStyle(
        //           shape: MaterialStateProperty.all(
        //             RoundedRectangleBorder(
        //                 borderRadius: BorderRadius.circular(25.0)),
        //           ),
        //           elevation: MaterialStateProperty.all(0),
        //           foregroundColor: MaterialStateProperty.all(Colors.white),
        //           backgroundColor: MaterialStateProperty.all(mainBlue)),
        //       onPressed: () {
        //         Navigator.push(context,
        //             MaterialPageRoute(builder: (context) => AddScreen()));
        //       },
        //       icon: Icon(Icons.arrow_circle_right_rounded),
        //       label: Text("Post a Job"),
        //     ),
        //   )
        // ],
        backgroundColor: Colors.white,
        elevation: 30,
        bottomOpacity: 0.8,
        toolbarHeight: 60,
        leading: Row(
          children: [
            IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back_ios)),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image(image: AssetImage('assets/images/2807471.jpg')),
            Text(
              "New year 2025 Sale on Shopper Stop on Visakhapatnam",
              // style: ThemeDataTween,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 30,
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Text(
                        "Festival",
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge!
                            .copyWith(color: Colors.white),
                      ),
                    ),
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(5)),
                  ),
                  Container(
                    height: 30,
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Text(
                        "Start from \u{20B9} 2500",
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge!
                            .copyWith(color: Colors.white),
                      ),
                    ),
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(5)),
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 1,
              color: Colors.grey,
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    child: Row(
                      children: [
                        Icon(Icons.calendar_month_outlined),
                        Text(
                          "Dec 31,2022",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    child: Row(
                      children: [
                        Icon(Icons.pin_drop_rounded),
                        Text(
                          "ShopperStop",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 1,
              color: Colors.grey,
            ),
            Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                CircleAvatar(
                  backgroundColor: Colors.yellow,
                  radius: 10,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "About",
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.black),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "DLF Mall of India, Noida - Biggest Mall in India. Spread over 2 million sq ft, DLF Mall of India is the biggest mall in India in terms of built up area. It comes with various amazing entertainment options, including a 7-screen movie theatre and a dedicated games zone.",
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Event Venue :  Visakhapatnam,RK beach",
                  ),
                  Text(
                    "Event Date :  31 Dec 2024",
                  ),
                  Text(
                    "Event Time :  7:30 PM to 3:30 AM",
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Biggest Mall in India. Spread over 2 million sq ft, DLF Mall of India is the biggest mall in India in terms of built up area. It comes with various",
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.grey.shade400),
                      height: 50,
                      width: MediaQuery.of(context).size.width * 0.95,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Terms & Conditions",
                          ),
                          IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.arrow_downward))
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.yellow,
                        radius: 10,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Location",
                        style: Theme.of(context)
                            .textTheme
                            .headlineLarge!
                            .copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: Colors.black),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Novotel Hotel, 7th floor,RK beach, Visakhapatnam,Novotel Hotel, 7th floor,RK beach, Visakhapatnam ",
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: SizedBox(
                      height: 300,
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Image(
                        image: AssetImage('assets/images/map2.jpg'),
                      ),
                    ),
                  ),
// show map button
                  Center(
                    child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.blueGrey),
                            borderRadius: BorderRadius.circular(20)),
                        height: 30,
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white),
                            onPressed: () {},
                            child: Text(
                              "Show me on map",
                              style: TextStyle(color: Colors.black),
                            ))),
                  ),
                  SizedBox(height: 10),

                  // button
                  Center(
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.black),
                        height: 50,
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          SelectedEventScreen()));
                            },
                            child: Text(
                              "Register",
                              style: TextStyle(color: Colors.white),
                            ))),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 80,
            )
          ],
        ),
      ),
    );
  }
}
