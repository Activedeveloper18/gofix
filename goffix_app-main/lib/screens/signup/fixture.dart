

import 'package:flutter/material.dart';
import 'package:goffix/screens/layout/layout.dart';

import '../../constants.dart';

class FixtureScreen extends StatefulWidget {
  const FixtureScreen();

  @override
  State<FixtureScreen> createState() => _FixtureScreenState();
}

class _FixtureScreenState extends State<FixtureScreen> {
  final TextEditingController _proController = new TextEditingController();
  final TextEditingController _yearsOfExpController =
      new TextEditingController();
  final TextEditingController _descController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SingleChildScrollView(
        child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "SIGN UP",
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 20,

            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _proController,
                decoration: InputDecoration(
        
                    // suffixIcon: Icon(CupertinoIcons.eye),
                    border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.grey.shade300, width: 3.0),
                        borderRadius: BorderRadius.circular(10.0)),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.grey.shade300, width: 3.0),
                        borderRadius: BorderRadius.circular(10.0)),
                    contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 10.0),
                    hintText: "Profession",
                    focusColor: Colors.green,
                    fillColor: Colors.grey),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _yearsOfExpController,
                decoration: InputDecoration(
        
                    // suffixIcon: Icon(CupertinoIcons.eye),
                    border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.grey.shade300, width: 3.0),
                        borderRadius: BorderRadius.circular(10.0)),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.grey.shade300, width: 3.0),
                        borderRadius: BorderRadius.circular(10.0)),
                    contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 10.0),
                    hintText: "Years of Experience",
                    focusColor: Colors.green,
                    fillColor: Colors.grey),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _descController,
                maxLines: 7,
                decoration: InputDecoration(
        
                    // suffixIcon: Icon(CupertinoIcons.eye),
                    border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.grey.shade300, width: 3.0),
                        borderRadius: BorderRadius.circular(10.0)),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.grey.shade300, width: 3.0),
                        borderRadius: BorderRadius.circular(10.0)),
                    contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 10.0),
                    hintText: "Descrption",
        
                    focusColor: Colors.green,
                    fillColor: Colors.grey),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.all(5),
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all(mainBlue)),
                    onPressed: () => {{
                      Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => Layout()),
                  )
                    }},
                    child: Text(
                      "   Continue   ",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 20),
              child: Image.asset(
                "assets/images/fix.png",
                width: double.infinity,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
