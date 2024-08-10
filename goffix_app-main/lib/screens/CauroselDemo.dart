import 'dart:convert';
import 'dart:typed_data';
import 'dart:async';
import 'dart:io';
// import 'package:carousel_slider/carousel_controller.dart';
// import 'package:carousel_slider/carousel_options.dart';
// import 'package:carousel_slider/carousel_slider.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';
import 'package:goffix/screens/AdService/BookAdService.dart';
import 'package:goffix/screens/login/login.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../constants.dart';

class CarouselWithIndicatorDemo extends StatefulWidget {
  final String? Screen;
  var size;
  var index;

  @override
  CarouselWithIndicatorDemo({Key? key, this.Screen, this.index, this.size})
      : super(key: key);
  State<StatefulWidget> createState() {
    return _CarouselWithIndicatorState();
  }
}

class _CarouselWithIndicatorState extends State<CarouselWithIndicatorDemo> {
  int _current = 0;
   List? listOfAds;
  List? _images;
  List? _imagesTemp;
  List<List<dynamic>> tilesfilter =
      new List.generate(10, (i) => [], growable: true);

  Future<dynamic> ads() async {
    String? token = await User().getToken();
    int? uid = await User().getUID();
    var requestBody = {"service_name": "Adds", "param": {}};
    var jsonRequest = json.encode(requestBody);
    print(jsonRequest);
    var response = await http.post(baseUrl,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonRequest);
    var jsonResponse = null;
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse["response"]["status"] == 200) {
        if (jsonResponse.length != null) {
          List<dynamic> data = jsonResponse['response']['result']['data'];

          print(data);
          List<dynamic> filterData = [];

          if (widget.Screen == "home") {
            for (var i = 0; i < data.length; i++) {
              if (data[i]['a_type'] == "0" || data[i]['a_type'] == "1") {
                filterData.add(data[i]);
              }
            }
          } else if (widget.Screen == "search") {
            for (var i = 0; i < data.length; i++) {
              if (data[i]['a_type'] == "2") {
                filterData.add(data[i]);
              }
            }
          } else if (widget.Screen == "tiles") {
            for (var i = 0; i < data.length; i++) {
              if (data[i]['a_type'] == "3") {
                tilesfilter[0].add(data[i]);
              }
              if (data[i]['a_type'] == "4") {
                tilesfilter[1].add(data[i]);
              }
              if (data[i]['a_type'] == "5") {
                tilesfilter[2].add(data[i]);
              }
              if (data[i]['a_type'] == "6") {
                tilesfilter[3].add(data[i]);
              }
              if (data[i]['a_type'] == "7") {
                tilesfilter[4].add(data[i]);
              }
              if (data[i]['a_type'] == "8") {
                tilesfilter[5].add(data[i]);
              }
              if (data[i]['a_type'] == "9") {
                tilesfilter[6].add(data[i]);
              }
              if (data[i]['a_type'] == "10") {
                tilesfilter[7].add(data[i]);
              }
              if (data[i]['a_type'] == "11") {
                tilesfilter[8].add(data[i]);
              }
              if (data[i]['a_type'] == "12") {
                tilesfilter[9].add(data[i]);
              }
            }
          }

          if (mounted) {
            setState(() {
              if (widget.index == null) {
                listOfAds = filterData;
              } else {
                listOfAds = tilesfilter[widget.index];
              }
            });
          }
        }

        // _showMyDialog("Success", "User Login Success", "home");

        print("ads");
      } else if (jsonResponse["response"]["status"] == 108) {
        // _showMyDialog("Error", "Username/Password not found", "login");
        print("Ads not found");
      }
    } else {
      print("Something Went Wrong");
    }
    // print(listOfAds);
    // return listOfAds;
    _getImages(listOfAds);
  }

  _getImages(listOfAds) {
    if (listOfAds != null) {
      _imagesTemp = listOfAds.map((e) => _removeDataUrl(e['a_img'])).toList();
      // _imagesTemp = listOfAds
      //     .map((e) => [if (e['a_type'] == "2") _removeDataUrl(e['a_img'])])
      //     .toList();
      // _imagesTemp.removeWhere((value) => value == "");
      print(_imagesTemp);
      if (mounted) {
        setState(() {
          _images = _imagesTemp;
        });
      }
    }
  }

  _removeDataUrl(String url) {
    if (url != null) {
      List img = url.split(",");
      return img[1];
    }
  }

  image_64(String _img64) {
    if (_img64 != null) {
      // List img = _img64.split(",");
      Uint8List _bytesImage;
      _bytesImage = Base64Decoder().convert(_img64);
      // return Image.memory(_bytesImage);
      return _bytesImage;
    }
  }

  // TValue case2<TOptionType, TValue>(
  //   TOptionType? selectedOption,
  //   Map<TOptionType, TValue> branches, [
  //   TValue defaultValue = null
  // ]
  //
  //     )
  // {
  //   if (!branches.containsKey(selectedOption)) {
  //     return defaultValue;
  //   }
  //
  //   return branches[selectedOption]!;
  // }

  @override
  void initState() {
    super.initState();
    this.ads();
  }

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   super.dispose();
  //   this.ads();
  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final List<Widget> adSliderImages = _images?.map((item) {
          // if (_images != null)
          return Container(
            child: Container(
              margin: EdgeInsets.all(5.0),
              child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  child: Stack(
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          int index = _images!.indexOf(item);
                          print(listOfAds![index]['a_link']);
                          String url = listOfAds![index]['a_link'];
                          List link = url.split(':');
                          if (link[0] == "tel") {
                            print(url);
                            launch(url.toString());
                          } else if (link[0] == "http" || link[0] == "https") {
                            launch(url);
                          } else if (link[0] == "pop") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BookAdServiceScreen(
                                        a_id:
                                            int.parse(listOfAds![index]['a_id']),
                                      )),
                            );
                          }
                        },
                        child: Image.memory(
                          image_64(item),
                          fit: BoxFit.fill,
                          width: 1300.0,
                          // height: case2(widget.size, {
                          //   "small": 125,
                          //   "medium": 250,
                          //   "big": 450,
                          // }),
                        ),
                      ),
                    ],
                  )),
            ),
          );
        })?.toList() ??
        [];
    return _images == null
        ? Center(child: Container()
            // CircularProgressIndicator(),
            )
        : widget.Screen == "tiles"
            ? tilesfilter[widget.index].isEmpty
                ? Center(
                    child: Container(),
                  )
                : Container(
                    decoration: BoxDecoration(),
                    child: CarouselSlider(
                      items: adSliderImages,
                      options: CarouselOptions(
                          // height: 30,
                          // autoPlay: true,
                          // enlargeCenterPage: true,
                          // aspectRatio: 1.8,
                          // height: case2(widget.size, {
                          //   "small": 125,
                          //   "medium": 250,
                          //   "big": 450,
                          // }),
                          viewportFraction: 1.0,
                          enlargeCenterPage: false,
                          autoPlay: adSliderImages.length > 1 ? true : false,
                          enableInfiniteScroll:
                              adSliderImages.length > 1 ? true : false,
                          autoPlayInterval: Duration(seconds: 3),
                          onPageChanged: (index, reason) {
                            if (mounted) {
                              setState(() {
                                _current = index;
                              });
                            }
                          }),
                    ),
                  )
            : Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFAAAAAA),
                      blurRadius: 30.0, // soften the shadow
                      spreadRadius: 3, //extend the shadow
                      offset: Offset(
                        0.0, // Move to right 10  horizontally
                        5.0, // Move to bottom 10 Vertically
                      ),
                    ),
                  ],
                ),
                child: CarouselSlider(
                  items: adSliderImages,
                  options: CarouselOptions(
                      // height: 30,
                      // autoPlay: true,
                      // enlargeCenterPage: true,
                      // aspectRatio: 1.8,
                      // height: case2(widget.size, {
                      //   "small": 125,
                      //   "medium": 250,
                      //   "big": 450,
                      // }),
                      viewportFraction: 1.0,
                      enlargeCenterPage: false,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 3),
                      onPageChanged: (index, reason) {
                        if (mounted) {
                          setState(() {
                            _current = index;
                          });
                        }
                      }),
                ),
              );

    //   ),
    // );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    this.ads();
  }
}
