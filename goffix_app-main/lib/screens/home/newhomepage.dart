import 'dart:convert';
import 'dart:typed_data';

// import 'package:carousel_slider/carousel_slider.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goffix/constants.dart';
import 'package:goffix/screens/AdService/BookAdService.dart';
import 'package:goffix/screens/CauroselDemo.dart';
import 'package:goffix/screens/eventBooking/eventListing.dart';
import 'package:goffix/screens/home/notificaton.dart';
import 'package:goffix/screens/home/providers/homeProvider.dart';
import 'package:goffix/screens/search/BookService.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'style.dart' as style;

class HomePage extends StatefulWidget {
  HomePage({Key? key, Title? title}) : super(key: key);
  final String title = '';
  static const String page_id = 'Home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> qty = ['150 g', '170 g'];

  String dropdownValue = '150 g';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'assets/images/logo.png',
              fit: BoxFit.contain,
              height: 60,
            ),
          ],
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Notifications()));
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(Icons.notifications, color: mainBlue),
            ),
          )
        ],
      ),
      body: _buildBody(context),
    );
  }


  Widget _buildBody(context) {
    var homeProvider = Provider.of<HomeProvider>(context);
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        child: Column(
          children: [
            // Container(
            //   child: Row(
            //     children: [
            //       Icon(Icons.location_pin),
            //       Text("Mithilapuri Colony ,VSKp 530019")
            //     ],
            //   ),
            // ),
            SizedBox(
              height: 8,
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: homeProvider.homeList.length,
              itemBuilder: (context, index) {
                return CarouselSlider(
                  items: homeProvider.homeList[index].map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        if (i.sectionImg == "0") {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  i.sectionText!,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900),
                                ),
                              ),
                            ],
                          );
                        } else {
                          return InkWell(
                            onTap: () {
                              String link_name = i.aLink!;
                              print(link_name);
                              List resultLink = link_name.split(':');
                              if (resultLink[0] == "tel") {
                                print(resultLink[1]);
                                // ignore: deprecated_member_use
                                launch(link_name.toString());
                              } else if (resultLink[0] == "http" ||
                                  resultLink[0] == "https") {
                                print(link_name);
                                // ignore: deprecated_member_use
                                launch(link_name);
                              } else if (resultLink[0] == "pop") {
                                print(resultLink[1]);
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //       builder: (context) => BookAdServiceScreen(
                                //             a_id: int.parse(i.aId),
                                //           )),
                                // );
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        BookAdServiceScreen(aId: i)));
                              } else if (resultLink[0] == "eve") {
                                print(resultLink[1]);
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        EventListing(aId: i)));
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Image.memory(
                                image_64(_removeDataUrl(i.aImg!)),
                                fit: BoxFit.fill,
                                width: 1300,
                                height: double.parse(i.atypeHeight!),
                              ),
                            ),
                          );
                        }
                      },
                    );
                  }).toList(),
                  options: CarouselOptions(
                      scrollPhysics:
                          homeProvider.homeList[index][0].sectionImg == "0"
                              ? NeverScrollableScrollPhysics()
                              : ScrollPhysics(),
                      autoPlay:
                          homeProvider.homeList[index][0].sectionImg == "0"
                              ? false
                              : true,
                      // height: 30,
                      // autoPlay: true,
                      // enlargeCenterPage: true,
                      // aspectRatio: 1.8,
                      height: double.parse(
                                  homeProvider.homeList[index][0].sectionImg!) !=
                              0
                          ? double.parse(
                              homeProvider.homeList[index][0].atypeHeight!)
                          : 60,
                      viewportFraction: 1.0,
                      enlargeCenterPage: false,
                      // autoPlay: adSliderImages.length > 1 ? true : false,
                      enableInfiniteScroll:
                          homeProvider.homeList[index].length > 1
                              ? true
                              : false,
                      autoPlayInterval: Duration(seconds: 3),
                      onPageChanged: (index, reason) {}),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTitleRow(val) {
    return Container(
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$val',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
            ),
          ],
        ));
  }

  Widget _SeachIcon(String img, String nm, String link) {
    return InkWell(
      onTap: () {
        // launch(link);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  BookServiceScreen(catid: int.parse(link), cname: nm)),
        );
      },
      child: Container(
        height: 40.0,
        width: 120.0,
        padding: const EdgeInsets.all(7.0),
        margin: EdgeInsets.all(4),
        decoration: BoxDecoration(
            border: Border.all(
              color: mainBlue,
            ),
            borderRadius: BorderRadius.circular(5.0)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon(CupertinoIcons.paintbrush_fill, color: mainBlue),
            Image.asset(
              img,
              height: 32,
              width: 32,
            ),
            Text(
              nm,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: mainBlue,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }

  backImage(val) {
    return BoxDecoration(
        image: DecorationImage(image: AssetImage(val), fit: BoxFit.fill));
  }

  Widget _buildSingleProduct(product) {
    return InkWell(
      onTap: () {
        // Navigator.push(context, new MaterialPageRoute(
        //     builder: (context) => new ProductDetailPage())
        // );
      },
      child: Container(
        width: 172,
        margin: EdgeInsets.only(right: 16),
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(16),
            ),
            color: Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(product.img),
                  Text(
                    product.name,
                    style: TextStyle(fontSize: 15, fontFamily: 'medium'),
                  ),
                  SizedBox(height: 8),
                  _buildDropDown(),
                  SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                      text: product.price,
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontFamily: 'semi-bold'),
                      children: <TextSpan>[
                        TextSpan(text: ' '),
                        TextSpan(
                            text: product.offPrice,
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                                fontFamily: 'regular')),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                child: Text('ADD'),
                style: style.addButton(),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDropDown() {
    return Container(
        width: double.infinity,
        height: 30,
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        decoration: style.outlineDecoration(),
        child: DropdownButton<String>(
          isExpanded: true,
          value: dropdownValue,
          icon: const Icon(Icons.arrow_drop_down),
          elevation: 16,
          style: const TextStyle(fontFamily: 'regular', color: Colors.black),
          underline: SizedBox(),
          onChanged: (String? newValue) {
            setState(() {
              dropdownValue = newValue!;
            });
          },
          items: qty.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
              ),
            );
          }).toList(),
        ));
  }
}

class Item {
  Item(this.img, this.name, this.price, this.offPrice);
  final String img;
  final String name;
  final String price;
  final String offPrice;
}
