import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'confirmbookingscreen.dart';

class EventBookingScreen extends StatefulWidget {
  const EventBookingScreen();

  @override
  State<EventBookingScreen> createState() => _EventBookingScreenState();
}

class _EventBookingScreenState extends State<EventBookingScreen> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController age = TextEditingController();
  TextEditingController contactnumber = TextEditingController();
  @override
  Widget build(BuildContext context) {
    print("event page ");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 30,
        bottomOpacity: 0.8,
        toolbarHeight: 60,
        title: Text("Visitors",style: TextStyle(fontWeight: FontWeight.w800,color: Colors.black),),
        centerTitle: true,
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
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Form(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          height: 330,
                          width: MediaQuery.of(context).size.width * 0.7,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black12,
                                    spreadRadius: 2,
                                    blurRadius: 2.0,
                                    offset: Offset(2, 1))
                              ]),
                          padding:
                              EdgeInsets.only(top: 20, left: 20, right: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Visitors",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                              Divider(
                                thickness: 1,
                                color: Colors.black12,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: TextFormField(
                                  maxLength: 50,
                                  initialValue: name.text,
                                  decoration: InputDecoration(
                                      counterText: "",
                                      labelText: "Name",
                                      border: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black12),
                                        borderRadius: BorderRadius.circular(10),
                                      )),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: TextFormField(
                                  initialValue: email.text,
                                  maxLength: 50,
                                  decoration: InputDecoration(
                                      counterText: "",
                                      labelText: "Email",
                                      border: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black12),
                                        borderRadius: BorderRadius.circular(10),
                                      )),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: TextFormField(
                                  initialValue: age.text,
                                  maxLength: 2,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp('[0-9]')),
                                  ],
                                  decoration: InputDecoration(
                                      counterText: "",
                                      labelText: "age",
                                      border: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black12),
                                        borderRadius: BorderRadius.circular(10),
                                      )),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: TextFormField(
                                  maxLength: 10,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp('[0-9]')),
                                  ],
                                  initialValue: contactnumber.text,
                                  decoration: InputDecoration(
                                      counterText: "",
                                      labelText: "contact",
                                      border: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black12),
                                        borderRadius: BorderRadius.circular(10),
                                      )),
                                ),
                              ),
                            ],
                          )),
                    ),
                  );
                }),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width*0.9,
            child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Confirmbookingscreen()));
                },
                child: Text("Continue",style: TextStyle(color: Colors.white,fontSize: 20),),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5)
              )
            ),
            ),
          )
        ],
      ),
    );
  }
}
