import 'dart:convert';

import 'package:flutter/material.dart';
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
    Uri url = Uri.parse(getAllUserByProfession + "profession=Engineer");
    final response = await http.get(url, headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': "Bearer $bearerToken"
    });

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = jsonDecode(response.body);
      return List<GetByProfessionTypeModel>.from(
          data.map((e) => GetByProfessionTypeModel.fromJson(e)));
    } else {
      throw Exception("Failed to load data");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: SizedBox(),
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
                  child: Text("Fixers : ${snapshot.data!.length}"),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.black54)),
                        child: ListTile(
                          onTap: (){
                            print("object $index");
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      BookServiceScreen(cname: widget.professionType,)),
                            );
                          },
                          title: Text(snapshot.data![index].usname!.toString()),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                             Row(
                                  children: [
                                    Icon(Icons.email,size: 15,),
                                    SizedBox(
                                      width: 120,
                                      child: Text(snapshot.data![index].username!.toString(),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,

                                      ),
                                    ),
                                  ],
                                ),

                              Row(
                                children: [
                                  Icon(Icons.phone,size: 15,),
                                  Text(snapshot.data![index].phNumber!.toString()),
                                ],
                              ),
                            ],
                          ),
                        ),
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
