import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:awesome_otp_screen/awesome_otp_screen.dart';
import 'package:goffix/constants.dart';
import 'package:goffix/screens/ForgotPassword/changePassword.dart';
import 'package:goffix/screens/config/configScreen.dart';
import 'package:goffix/screens/login/login.dart';

class OtpScreenMobile extends StatefulWidget {
  final String? uid;
  final String? otp;
  final String? phn;
  final String? oTyp;
  final String? screen;

  const OtpScreenMobile({
    Key? key,
    this.uid,
    this.otp,
    this.phn,
    this.oTyp,
    this.screen
  }) : super(key: key);

  @override
  _OtpScreenMobileState createState() => _OtpScreenMobileState();
}

class _OtpScreenMobileState extends State<OtpScreenMobile> {
  Future<String> validateOtp(String otp) async {
    await Future.delayed(const Duration(milliseconds: 2000));
    var requestBody = {
      "service_name": "otpcheck",
      "param": {
        "u_id": widget.uid,
        "otp_res": widget.otp,
        "otp": otp,
        "otp_type": widget.oTyp
      }
    };
    var jsonRequest = json.encode(requestBody);
    print(jsonRequest);
    var response = await http.post(
      baseUrl,
      headers: {'Accept': 'application/json'},
      body: jsonRequest,
    );
    var jsonResponse = json.decode(response.body);
    print(jsonResponse);
    if (response.statusCode == 200) {
      if (jsonResponse["response"]["status"] == 200) {
        if (widget.oTyp == "1") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LoginOtpScreen(),
            ),
          );
        } else if (widget.oTyp == "2") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChangePasswordScreen(
                uid: widget.uid!,
                otp: widget.otp!,
                oTyp: widget.oTyp!,
              ),
            ),
          );
        }
      } else {
        print("Otp error");
        return "The entered Otp is wrong";
      }
    }
    return "";
  }

  void moveToNextScreen(context) {
    if (widget.oTyp == "1") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConfigScreen(uid: widget.uid!),
        ),
      );
    } else if (widget.oTyp == "2") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChangePasswordScreen(
            uid: widget.uid!,
            otp: widget.otp!,
            oTyp: widget.oTyp!,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Container(
        padding: EdgeInsets.only(top: 30),
        child: AwesomeOtpScreen.withGradientBackground(
          topColor: Color(0xFFcc2b5e),
          bottomColor: Colors.white,
          otpLength: 6,
          validateOtp: validateOtp,
          routeCallback: moveToNextScreen,
          themeColor: mainBlue,
          titleColor: mainBlue,
          title: "Phone Number Verification",
          subTitle: "Enter the code sent to \n " + widget.phn!,
          icon: Image.asset(
            'assets/images/logo_ls.png',
            height: 50,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
