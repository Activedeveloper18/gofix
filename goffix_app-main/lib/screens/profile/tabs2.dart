import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// void main() {
//   runApp(MyApp());
// }

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tab inside body widget',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        // visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tabs Example'),
      ),
      body: Container(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 20.0),
              Text('Tabs Inside Body',
                  textAlign: TextAlign.center, style: TextStyle(fontSize: 22)),
              DefaultTabController(
                  length: 2, // length of tabs
                  initialIndex: 0,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Container(
                          child: TabBar(
                            unselectedLabelColor: Colors.redAccent,
                            indicatorSize: TabBarIndicatorSize.label,
                            indicator: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.redAccent,
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFFAAAAAA).withOpacity(0.8),
                                    blurRadius: 10.0, // soften the shadow
                                    spreadRadius: 1, //extend the shadow
                                    offset: Offset(
                                      0.0, // Move to right 10  horizontally
                                      5.0, // Move to bottom 10 Vertically
                                    ),
                                  ),
                                ]),
                            tabs: [
                              Tab(
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      border: Border.all(
                                          color: Colors.redAccent, width: 1)),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text("APPS"),
                                  ),
                                ),
                              ),
                              Tab(
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      border: Border.all(
                                          color: Colors.redAccent, width: 1)),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text("APPS"),
                                  ),
                                ),
                              )
                              // Tab(text: 'Tab 3'),
                              // Tab(text: 'Tab 4'),
                            ],
                          ),
                        ),
                        Container(
                            height: 400, //height of TabBarView
                            // decoration: BoxDecoration(
                            // border: Border(
                            //     top: BorderSide(
                            //         color: Colors.grey, width: 2.5))),
                            child: TabBarView(children: <Widget>[
                              Container(
                                child: Center(
                                  child: Text('Display Tab 1',
                                      style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                              Container(
                                child: Center(
                                  child: Text('Display Tab 2',
                                      style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ]))
                      ])),
            ]),
      ),
    );
  }
}
