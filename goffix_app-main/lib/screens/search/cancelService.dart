import 'package:flutter/material.dart';
import 'package:goffix/constants.dart';
import 'package:google_fonts/google_fonts.dart';

class cancelService extends StatefulWidget {
  const cancelService({Key? key}) : super(key: key);

  @override
  State<cancelService> createState() => _cancelServiceState();
}

class _cancelServiceState extends State<cancelService> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cancel Service"),
      ),
      body: Column(
        children: [
          CheckboxListTile(
            controlAffinity: ListTileControlAffinity.leading,
            title: Text(
              "I changed my mind",
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w300,
                fontSize: 18,
              ),
            ),
            value: true,
            onChanged: ((value) {}),
          ),
          CheckboxListTile(
            controlAffinity: ListTileControlAffinity.leading,
            title: Text(
              "I am unavailabel at the scheduled time",
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w300,
                fontSize: 18,
              ),
            ),
            value: true,
            onChanged: ((value) {}),
          ),
          CheckboxListTile(
            controlAffinity: ListTileControlAffinity.leading,
            title: Text(
              "My issue was resolved automatically",
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w300,
                fontSize: 18,
              ),
            ),
            value: true,
            onChanged: ((value) {}),
          ),
          CheckboxListTile(
            controlAffinity: ListTileControlAffinity.leading,
            title: Text(
              "I found another service provider",
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w300,
                fontSize: 18,
              ),
            ),
            value: true,
            onChanged: ((value) {}),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {},
                child: Text("Submit"),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(mainOrange)),
              ),
            ],
          )
        ],
      ),
    );
  }
}
