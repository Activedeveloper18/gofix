import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'confirmbookingscreen.dart';

class EventBookingScreen extends StatefulWidget {
  final int totalTickets;
  const EventBookingScreen({required this.totalTickets});

  @override
  State<EventBookingScreen> createState() => _EventBookingScreenState();
}

class _EventBookingScreenState extends State<EventBookingScreen> {
  List<TextEditingController> nameControllers = [];
  List<TextEditingController> emailControllers = [];
  List<TextEditingController> ageControllers = [];
  List<TextEditingController> contactNumberControllers = [];
  List<String?> genderValues = [];
  final List<Map<String, dynamic>> visitors = [];

  @override
  void initState() {
    super.initState();

    // Initialize controllers and gender values based on the number of tickets
    for (int i = 0; i < widget.totalTickets; i++) {
      nameControllers.add(TextEditingController());
      emailControllers.add(TextEditingController());
      ageControllers.add(TextEditingController());
      contactNumberControllers.add(TextEditingController());
      genderValues.add(null);
    }
  }

  Future<void> submitVisitors() async {
    bool allFieldsFilled = true;
    visitors.clear();

    // Capture each visitor’s data from controllers
    for (int i = 0; i < widget.totalTickets; i++) {
      final visitor = {
        'name': nameControllers[i].text,
        'email': emailControllers[i].text,
        'age': ageControllers[i].text,
        'contact': contactNumberControllers[i].text,
        'gender': genderValues[i],
      };

      if (visitor.values.any((value) => value == null || value.isEmpty)) {
        allFieldsFilled = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please fill in all fields for each visitor.')),
        );
        return;
      }

      visitors.add(visitor);
    }

    if (!allFieldsFilled) return;

    const String apiUrl = 'https://admin.goffix.com/api/events/confirm_event.php';
    
    for (var visitor in visitors) {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "eventId": 5,
          ...visitor,
        }),
      );

      print('response confirm ${response.body}');
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Confirmbookingscreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 30,
        toolbarHeight: 60,
        title: Text(
          "Visitors",
          style: TextStyle(fontWeight: FontWeight.w800, color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.totalTickets,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          spreadRadius: 2,
                          blurRadius: 2.0,
                          offset: Offset(2, 1),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text("Visitor ${index + 1}"),
                        TextField(
                          controller: nameControllers[index],
                          decoration: InputDecoration(labelText: "Name"),
                        ),
                        TextField(
                          controller: emailControllers[index],
                          decoration: InputDecoration(labelText: "Email"),
                        ),
                        TextField(
                          controller: ageControllers[index],
                          decoration: InputDecoration(labelText: "Age"),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                        TextField(
                          controller: contactNumberControllers[index],
                          decoration: InputDecoration(labelText: "Contact"),
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                        DropdownButton<String>(
                          value: genderValues[index],
                          hint: Text('Select Gender'),
                          items: <String>['Male', 'Female', 'Other']
                              .map((String gender) {
                            return DropdownMenuItem<String>(
                              value: gender,
                              child: Text(gender),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              genderValues[index] = newValue;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: submitVisitors,
            child: Text("Continue"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Dispose of all controllers
    for (var controller in nameControllers) controller.dispose();
    for (var controller in emailControllers) controller.dispose();
    for (var controller in ageControllers) controller.dispose();
    for (var controller in contactNumberControllers) controller.dispose();
    super.dispose();
  }
}
