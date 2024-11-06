// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:goffix/screens/eventBooking/event_booking.dart';
// import 'package:goffix/screens/eventBooking/eventscreen.dart';

// import '../../constants.dart';
// import '../add/AddScreen.dart';
// import 'deliverypage.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:goffix/screens/eventBooking/event_booking.dart';
import 'package:goffix/screens/eventBooking/eventscreen.dart';

import '../../constants.dart';
import '../add/AddScreen.dart';
import 'deliverypage.dart';

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EventListScreen extends StatefulWidget {
  const EventListScreen();

  @override
  State<EventListScreen> createState() => _EventListscreenState();
}

class _EventListscreenState extends State<EventListScreen> {
   List adsData = [];
     @override
  void initState() {
    super.initState();
    fetchAds();
  }

     Future<void> fetchAds() async {
      print('ads1');
    final url = 'https://admin.goffix.com/api/ads/ads.php';
    try {
      final response = await http.get(Uri.parse(url));
      print('ads2 $response');
      if (response.statusCode == 200) {
        print('ads3');
        final List data = json.decode(response.body);
        print('ads4');
        setState(() {
          adsData = data;
        });
      } else {
        print('Failed to load ads');
      }
    } catch (e) {
      print('Error fetching ads: $e');
    }
  }


  Future<List<dynamic>> fetchEvents() async {
    print('here client');
    final response = await http.get(
      Uri.parse('https://admin.goffix.com/api/events/events.php'),
    );
    print('here client 2 ${response.statusCode}');

    if (response.statusCode == 200) {
          final jsonResponse = json.decode(response.body);
    print('Events fetched successfully');
    return jsonResponse['data'];
    } else {
      throw Exception("Failed to load events");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
           mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
      height: 150, // Adjust height as needed
      child: adsData.isNotEmpty
          ? ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: adsData.length,
              itemBuilder: (context, index) {
                final ad = adsData[index];
                return ad['a_img'] != null
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.network(
                              'https://admin.goffix.com/dashboard/${ad['a_img']}',
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(height: 8),
                            Text(
                              ad['a_note'] ?? '',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      )
                    : Container();
              },
            )
          : Center(child: CircularProgressIndicator()),
    ),
           FutureBuilder<List<dynamic>>(
  future: fetchEvents(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Center(child: CircularProgressIndicator());
    } else if (snapshot.hasError) {
      return Center(child: Text('Failed to load events'));
    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return Center(child: Text('No events available'));
    } else {
      return SizedBox(
        height: 250, // Set a fixed height for the horizontal ListView
        child: ListView.builder(
          itemCount: snapshot.data!.length,
          scrollDirection: Axis.horizontal, // Change scroll direction to horizontal
          itemBuilder: (context, index) {
            final event = snapshot.data![index];
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Eventscreen(eveId: event['eve_id']),
                  ),
                );
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                width: MediaQuery.of(context).size.width * 0.6, // Adjust width as needed
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage("https://admin.goffix.com/dashboard/${event['eve_img']}"),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        event['eve_title'] ?? '',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          backgroundColor: Colors.black54,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    }
  },
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
          
          
          ]
        ),
      ),
    );
  }
}


// class EventListScreen extends StatefulWidget {
//   const EventListScreen();

//   @override
//   State<EventListScreen> createState() => _EventListscreenState();
// }

// class _EventListscreenState extends State<EventListScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,

//       appBar: AppBar(
//         leadingWidth: 150,
//         centerTitle: true,
//         backgroundColor: Colors.white,
//         elevation: 30,
//         bottomOpacity: 0.8,
//         toolbarHeight: 60,
//         leading: InkWell(
//           onTap: () {},
//           child: Image.asset(
//             'assets/images/logo.png',
//             fit: BoxFit.fitWidth,
//             height: 80,
//             width: 100,
//           ),
//         ),
//       ),

//       body: SingleChildScrollView(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Text("Hello ",style: Theme.of(context).textTheme.headlineSmall,),
//             ),
//             InkWell(
//               onTap: () {
//                 Navigator.push(context,
//                     MaterialPageRoute(builder: (context) => Eventscreen()));
//               },
//               child: Container(
//                 height: 250,
//                 width: MediaQuery.of(context).size.width * 8,
//                 decoration: BoxDecoration(
//                     image: DecorationImage(
//                         image: AssetImage("assets/images/2807471.jpg"),
//                         fit: BoxFit.cover),
//                     // color: Colors.blue,
//                     borderRadius: BorderRadius.circular(10)),
//                 // child: Column(),
//               ),
//             ),
//             10.verticalSpace,
//             InkWell(
//               onTap: () {
//                 Navigator.push(context,
//                     MaterialPageRoute(builder: (context) => Deliverypagescreen()));
//               },
//               child: Container(
//                 height: 800,
//                 width: MediaQuery.of(context).size.width * 8,
//                 decoration: BoxDecoration(
//                     image: DecorationImage(
//                         image: AssetImage("assets/images/poster.jpg"),
//                         fit: BoxFit.contain),
//                     // color: Colors.blue,
//                     borderRadius: BorderRadius.circular(10)),
//                 // child: Column(),
//               ),
//             ),
//             20.verticalSpace
//           ],
//         ),
//       ),
//       // body: ListView.builder(itemBuilder: (context, index) {
//       //   return Padding(
//       //     padding: const EdgeInsets.all(8.0),
//       //     child: InkWell(
//       //       onTap: (){
//       //         Navigator.push(context, MaterialPageRoute(builder: (context)=>Eventscreen()));
//       //       },
//       //       child: Container(
//       //         height: 250,
//       //         width: MediaQuery.of(context).size.width * 8,
//       //         decoration: BoxDecoration(
//       //             image: DecorationImage(
//       //                 image: AssetImage("assets/images/2807471.jpg"),
//       //                 fit: BoxFit.cover),
//       //             // color: Colors.blue,
//       //             borderRadius: BorderRadius.circular(10)),
//       //         // child: Column(),
//       //       ),
//       //     ),
//       //
//       //   );
//       // }),
//     );
//   }
// }
