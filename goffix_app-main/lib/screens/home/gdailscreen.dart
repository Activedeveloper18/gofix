import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:goffix/models/getbyprofessiontype.dart';
import 'package:goffix/screens/home/repo/gdailrepo.dart';

import '../../models/getcountbyprofession.dart';
import '../search/list_fixer_screen.dart';

class Gdailscreen extends StatefulWidget {
  const Gdailscreen();

  @override
  State<Gdailscreen> createState() => _GdailscreenState();
}

class _GdailscreenState extends State<Gdailscreen> {
  TextEditingController search_controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    GdailRepo().getCountProfession();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<GetCountByProfessionModel>?>(
        future: GdailRepo().getCountProfession(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: Container(
                    child: Center(
                        child: Image.asset("assets/images/page_load.gif",
                            height: 50))));
          } else if (snapshot.hasError) {
            return Center(child: Text("An error occurred: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No data found"));
          } else {
            return Column(
              children: [
                Container(
                  height: 300,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.indigo,
                    image: DecorationImage(
                      image: AssetImage("assets/images/gdail_topimage.png"),
                    ),
                  ),
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: search_controller,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        suffixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2,
                            style: BorderStyle.solid,
                            color: Colors.white,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      GetCountByProfessionModel item = snapshot.data![index];
                      return InkWell(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ListFixerScreen(
                                  professionType: item.profession.toString(),
                                )),
                          );

                        },
                        child: Container(
                          height: 70,
                          padding: EdgeInsets.all(10),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  item.profession ?? "Unknown Profession",
                                  style: TextStyle(
                                    color: Colors.indigo,
                                    fontSize: 24,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Container(
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                      color: Colors.indigo,
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      "${item.count}",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_right,
                                    color: Colors.indigo,
                                    size: 40,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Divider(
                  thickness: 1.5,
                  color: Colors.grey,
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
