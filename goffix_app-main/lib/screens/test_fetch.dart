// import 'dart:typed_data';

// import 'package:carousel_pro/carousel_pro.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:goffix/constants.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'dart:io' as Io;

// import 'login/login.dart';

// class UserList extends StatelessWidget {
//   List img;
//   final String apiUrl = "https://randomuser.me/api/?results=10";

//   Future<List<dynamic>> fetchUsers() async {
//     var result = await http.get(apiUrl);
//     return json.decode(result.body)['results'];
//   }

//   Future<List<dynamic>> fetchAds() async {
//     String token = await User().getToken();
//     var requestBody = {"service_name": "Adds", "param": {}};
//     var jsonRequest = json.encode(requestBody);
//     var response = await http.post(baseUrl,
//         headers: {
//           'Accept': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//         body: jsonRequest);
//     print(json.decode(response.body)['response']['status']);
//     return json.decode(response.body)['response']['result']['data'];
//   }

//   String _name(dynamic user) {
//     return user['name']['title'] +
//         " " +
//         user['name']['first'] +
//         " " +
//         user['name']['last'];
//   }

//   String _location(dynamic user) {
//     return user['location']['country'];
//   }

//   String _age(Map<dynamic, dynamic> user) {
//     return "Age: " + user['dob']['age'].toString();
//   }

//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('User List'),
//       ),
//       body: Container(
//         // child: Container(
//         //   child: Column(
//         //     children: [],
//         //   ),
//         // ),
//         child: SizedBox(
//           height: size.height * .30,
//           width: size.width,
//           child: FutureBuilder<List<dynamic>>(
//             future: fetchAds(),
//             builder: (BuildContext context, AsyncSnapshot snapshot) {
//               if (snapshot.hasData) {
//                 print(snapshot.data[0]);
//                 return ListView.builder(
//                     shrinkWrap: true,
//                     // physics: NeverScrollableScrollPhysics(),
//                     itemCount: snapshot.data.length,
//                     itemBuilder: (BuildContext context, int index) {
//                       String imgVal = snapshot.data[5]['a_img'];
//                       img = imgVal.split(",");
//                       Uint8List bytes = base64.decode(img[1]);
//                       return Column(
//                         children: [
//                           Image.memory(bytes),
//                         ],
//                       );
//                       // Carousel(
//                       //   // data:image/png;base64,
//                       //   images: [
//                       //     MemoryImage(bytes)
//                       //     // ExactAssetImage("assets/images/ad_1.png")
//                       //     // MemoryImage(
//                       //     //     iVBORw0KGgoAAAANSUhEUgAABRMAAAOoCAMAAAB1PJOXAAADAFBMVEXCAAD///8REBABQ4ACUZwCQn7SZ2fx1NTio6MCUJj//f8CRYMBRIICUJoCQXz/6OUCTpQCS44CQX37//8CT5cCU53///v/+v/9//8CTpYBSIkCSYv19fUBTZMCRYXGJCQCR4f79fUCaLjCAAX3//8CTZIBTJHah4efW1gCVZ/KPz/039//+/xsbGzOVFT5///pvLz//P8BRYb46ur1//8BS5D//fvl5eUCUZj/+P/p6epIXnTHx8cBP3qmpaXV1dXWeHjelpbtyMjx//////fmsLD8//r9/f2+AgL/nJhigJ0CO2/4//r//vTGAQX/+O3EBw/8//3/+fj1//r5//X/+Pu6AwX4//0COW3//fgAQIX//vv/9P9if5swMDACZrWLi4sAPn/0+/b2+Pq+vr7NsaUAOXz6+/vs7OwBSY4BR4vLAwf7+///+PMAPYLjSj3gu8Ps//8NPWr//vHg4OC6y9tbW1uxCQ7//uzJztLR1Nb/8/HhfnHm6u/v//mysrP/4+ZHR0fd5ex7mLQqYZX/8+K8CQ7KERj/+ecnVH/o7vTt8fSvxdn/3td8fHwpUXjEAAL/9Pg+cqMMS4f/6NvLysp9n8BLeaQ4bJ35+fhTga2YmZoSVpUeWJAALWXR3Ob/x8n/8uqvvssvZ5z5/+1xl7rz//EOUZCJpL0qWIXbKDCiEhT+r7P+1MoANHa7FRr/0deXssv/u7tmjbMDPXXw9fjTGSGUqr7/7e7D0d5hiKwkTHMWUYn/6OnX4OjvTFbdTVHlNTzJ1uPeWl/+n6bpZmrKKTCjNjVui6f7qqO8JCOjvNP8jZSoWFixOzvBMzOyJCv8gIe8TU3YPEbv/+fqiorKenShIyTe//zveYD2bnc3YozqP0qwTEaktsgPRnq/bGa9YFz3+uTr9tzzwr5GbZHNioX8XWjJm4jFSEcCWqbhs6PUoprg//Da29zy3szTwbHf48l),
//                       //     // ExactAssetImage("assets/images/ad_3.png"),
//                       //     // ExactAssetImage("assets/images/ad_4.png"),
//                       //     // ExactAssetImage("assets/images/ad_5.png"),
//                       //   ],
//                       //   boxFit: BoxFit.fill,
//                       //   animationCurve: Curves.fastOutSlowIn,
//                       //   animationDuration: Duration(milliseconds: 1000),
//                       //   dotSize: 4.0,
//                       //   dotSpacing: 15.0,
//                       //   dotBgColor: Colors.transparent,
//                       //   indicatorBgPadding: 5.0,
//                       //   borderRadius: true,
//                       //   radius: Radius.circular(30),
//                       // );
//                     });
//               } else {
//                 return Center(
//                   child: CircularProgressIndicator(),
//                 );
//               }
//             },
//           ),
//         ),
//       ),

//       // Carousel(
//       //   images: [
//       //     // for (var i = 0; i <= listOfAds.length; i++)
//       //     //   {
//       //     //     MemoryImage(listOfAds[i]["a_img"]),
//       //     //   }

//       //     ExactAssetImage("assets/images/ad_2.png"),
//       //     ExactAssetImage("assets/images/ad_3.png"),
//       //     ExactAssetImage("assets/images/ad_4.png"),
//       //     ExactAssetImage("assets/images/ad_5.png"),
//       //   ],
//       //   boxFit: BoxFit.fill,
//       //   animationCurve: Curves.fastOutSlowIn,
//       //   animationDuration: Duration(milliseconds: 1000),
//       //   dotSize: 4.0,
//       //   dotSpacing: 15.0,
//       //   dotBgColor: Colors.transparent,
//       //   indicatorBgPadding: 5.0,
//       //   borderRadius: true,
//       //   radius: Radius.circular(30),
//       // ),

//       // Container(
//       //   child: FutureBuilder<List<dynamic>>(
//       //     future: fetchUsers(),
//       //     builder: (BuildContext context, AsyncSnapshot snapshot) {
//       //       if (snapshot.hasData) {
//       //         print(_age(snapshot.data[0]));
//       //         return ListView.builder(
//       //             padding: EdgeInsets.all(8),
//       //             itemCount: snapshot.data.length,
//       //             itemBuilder: (BuildContext context, int index) {
//       //               return Card(
//       //                 child: Column(
//       //                   children: <Widget>[
//       //                     ListTile(
//       //                       leading: CircleAvatar(
//       //                           radius: 30,
//       //                           backgroundImage: NetworkImage(
//       //                               snapshot.data[index]['picture']['large'])),
//       //                       title: Text(_name(snapshot.data[index])),
//       //                       subtitle: Text(_location(snapshot.data[index])),
//       //                       trailing: Text(_age(snapshot.data[index])),
//       //                     )
//       //                   ],
//       //                 ),
//       //               );
//       //             });
//       //       } else {
//       //         return Center(child: CircularProgressIndicator());
//       //       }
//       //     },
//       //   ),
//       // ),
//     );
//   }
// }
