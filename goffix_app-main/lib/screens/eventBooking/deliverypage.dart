import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:goffix/screens/eventBooking/selectedeventscreen.dart';
import 'package:slider_button/slider_button.dart';
import 'package:fluttertoast/fluttertoast.dart'; // For toast messages
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../constants.dart';
import '../add/AddScreen.dart';

class Deliverypagescreen extends StatefulWidget {
  @override
  State<Deliverypagescreen> createState() => _EventscreenState();
}

class _EventscreenState extends State<Deliverypagescreen> {
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 150,
        actions: [],
        backgroundColor: Colors.white,
        elevation: 30,
        toolbarHeight: 60,
        leading: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios),
            ),
            InkWell(
              onTap: () {},
              child: Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.fitWidth,
                height: 80,
                width: 100,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildTextField("Location", _locationController),
              10.verticalSpace,
              _buildTextField("Enter Delivery Address", _addressController, maxLines: 4),
              10.verticalSpace,
              _buildTextField("Additional Details, if any", _detailsController, maxLines: 4),
              10.verticalSpace,
              _buildTextField(
                "Enter Mobile Number",
                _mobileController,
                maxLength: 10,
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]'))],
              ),
              10.verticalSpace,
              _buildOrderSteps(),
              _buildAgreementCheckbox(),
              _buildSliderButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String hintText, TextEditingController controller,
      {int maxLines = 1, int maxLength = 50, List<TextInputFormatter>? inputFormatters}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      maxLength: maxLength,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.grey.shade300,
        counterText: "",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
      ),
    );
  }

  Widget _buildOrderSteps() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildOrderStep(Icons.verified_rounded, "Order", "Confirmed"),
        _buildOrderStep(Icons.pedal_bike, "Started", "Journey"),
        _buildOrderStep(Icons.pin_drop, "Pro", "Reached"),
        _buildOrderStep(Icons.money, "Cash on", "Delivery"),
      ],
    );
  }

  Widget _buildOrderStep(IconData icon, String title, String subtitle) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 30, color: Colors.grey.shade800),
        Text(title),
        Text(subtitle),
      ],
    );
  }

  Widget _buildAgreementCheckbox() {
    return Row(
      children: [
        Checkbox(
          value: _isChecked,
          onChanged: (value) {
            setState(() {
              _isChecked = value!;
            });
          },
        ),
        Expanded(
          child: Row(
            children: [
              Text("I have and agree to the "),
              Text(
                "Terms and Conditions",
                style: TextStyle(color: Colors.blue),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSliderButton() {
    return SliderButton(
      action: () async {
        if (_validateForm()) {
          bool result = await _bookService();
          if (result) {
            Fluttertoast.showToast(msg: "Booking successful");
          } else {
            Fluttertoast.showToast(msg: "Booking failed");
          }
        }
      },
      label: Text(
        "Slide to Book",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 17),
      ),
      icon: Center(
        child: Icon(Icons.add, color: mainOrange, size: 40.0),
      ),
      boxShadow: BoxShadow(
        color: Colors.transparent.withOpacity(.6),
        blurRadius: 10,
      ),
      shimmer: true,
      vibrationFlag: false,
      alignLabel: Alignment(0.0, 0),
      width: 300,
      radius: 20,
      buttonColor: Colors.white.withOpacity(0.8),
      backgroundColor: mainOrange,
      highlightedColor: mainBlue,
      baseColor: Colors.white,
    );
  }

  bool _validateForm() {
    if (_locationController.text.isEmpty ||
        _addressController.text.isEmpty ||
        _detailsController.text.isEmpty ||
        _mobileController.text.isEmpty ||
        !_isChecked) {
      Fluttertoast.showToast(msg: "Please fill all fields and agree to terms");
      return false;
    }
    return true;
  }

  Future<bool> _bookService() async {
    final response = await http.post(
      Uri.parse('https://admin.goffix.com/api/booking/bookOrder.php'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        "location": _locationController.text,
        "deliveryAddress": _addressController.text,
        "additionalDetails": _detailsController.text,
        "mobileNumber": _mobileController.text,
        "agreeTerms": _isChecked,
      }),
    );

    // if (response.statusCode == 200) {
      return true;
    // } else {
      // return false;
    // }
  }
}
