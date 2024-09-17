import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import '../../constants.dart';
import '../../models/getbyprofessiontype.dart';
import 'BookService.dart';

class ListFixerScreen extends StatefulWidget {
  final String? professionType; // Changed to final
  ListFixerScreen({this.professionType});

  @override
  State<ListFixerScreen> createState() => _ListFixerScreenState();
}

class _ListFixerScreenState extends State<ListFixerScreen> {
  @override
  void initState() {
    super.initState();
  }

  Future<List<GetByProfessionTypeModel>> _getCat() async {
    print("---------------- gdail listr ");
    // Uri url = Uri.parse(
    //     getAllUserByProfession + "profession=${widget.professionType}");
    Uri url = Uri.parse(
        "http://ec2-51-20-153-77.eu-north-1.compute.amazonaws.com:5000/gdial/users/by-profession?profession=${widget.professionType}");
    print('get jobs ${url}');
    final response = await http.get(url, headers: headers);
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = jsonDecode(response.body);
      return List<GetByProfessionTypeModel>.from(
          data.map((e) => GetByProfessionTypeModel.fromJson(e)));
      setState(() {});
    } else {
      throw Exception("Failed to load data");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 30,
        bottomOpacity: 0.8,
        toolbarHeight: 60,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'assets/images/logo.png',
              fit: BoxFit.contain,
              height: 45,
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<GetByProfessionTypeModel>>(
        future: _getCat(), // Now returns a List<GetByProfessionTypeModel>
        builder: (BuildContext context,
            AsyncSnapshot<List<GetByProfessionTypeModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text("No data found"),
            );
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                      "${widget.professionType} : ${snapshot.data!.length}"),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>BookServiceScreen(
                            cname: snapshot.data![index].usname,
                            catid: 1,
                          )));
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.black54)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // username and email
                                SizedBox(
                                  child: Row(
                                    children: [
                                      10.horizontalSpace,
                                      CircleAvatar(
                                        backgroundImage:
                                            AssetImage("assets/images/male.png"),
                                        radius: 40,
                                      ),
                                      20.horizontalSpace,
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${snapshot.data![index].usname}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge!
                                                .copyWith(
                                                    fontWeight: FontWeight.w800),
                                          ),
                                          Text("${snapshot.data![index].email}"),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.verified_sharp,
                                                color: snapshot.data![index]
                                                            .usstatus !=
                                                        "Active"
                                                    ? Colors.blueGrey
                                                    : Colors.indigo,
                                                size: 20,
                                              ),
                                              5.horizontalSpace,
                                              Text(
                                                  "${snapshot.data![index].usstatus == "Active" ? "Verified" : "Not Verified"}"),
                                            ],
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                10.verticalSpace,
                                // phone and message
                                SizedBox(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      IconButton(
                                          onPressed: () {},
                                          icon: Icon(
                                            Icons.phone,
                                            color: Colors.indigo,
                                            size: 30,
                                          )),
                                      IconButton(
                                          onPressed: () {},
                                          icon: Icon(
                                            Icons.message_outlined,
                                            color: Colors.indigo,
                                            size: 30,
                                          ))
                                    ],
                                  ),
                                ),
                              ],
                            )),
                      ),
                    );
                  },
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
