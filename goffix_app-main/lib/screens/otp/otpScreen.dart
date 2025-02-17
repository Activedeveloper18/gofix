import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:goffix/screens/home/homeScreen.dart';
import 'package:goffix/screens/layout/layout.dart';
import 'package:goffix/screens/onboarding/onbarding.dart';
import 'package:goffix/screens/signup/fixture.dart';
import 'package:http/http.dart' as http;
import 'package:awesome_otp_screen/awesome_otp_screen.dart';
import 'package:goffix/constants.dart';
import 'package:goffix/screens/ForgotPassword/changePassword.dart';
import 'package:goffix/screens/config/configScreen.dart';
import 'package:goffix/screens/login/login.dart';

import '../../models/logincredentialsmodel.dart';
import '../../models/loginuser_model.dart';
import '../custom_widegt/popmessager.dart';

class OtpScreenMobile extends StatefulWidget {
  final String? uid;
  final String? otp;
  final String? phn;
  final String? oTyp;
  final String? screen;

  const OtpScreenMobile(
      {Key? key, this.uid, this.otp, this.phn, this.oTyp, this.screen})
      : super(key: key);

  @override
  _OtpScreenMobileState createState() => _OtpScreenMobileState();
}

class _OtpScreenMobileState extends State<OtpScreenMobile> {
  // Future<String> validateOtp(String otp) async {
  //   await Future.delayed(const Duration(milliseconds: 2000));
  //   var requestBody = {};
  //   var jsonRequest = json.encode(requestBody);
  //   print(jsonRequest);
  //   Uri url = Uri.parse(otpValidateUrl+"phnumber=${widget.phn}&otp=${otp}");
  //   // Uri url = Uri.parse(
  //   //     "http://ec2-16-171-139-167.eu-north-1.compute.amazonaws.com:5000/auth/signinwithotp");
  //   print(url);
  //   var response = await http.post(
  //     url,
  //     headers: {'Accept': 'application/json'},
  //     body: requestBody,
  //   );
  //   print(response.statusCode);
  //   print(response.body);
  //
  //   // var jsonResponse = json.decode(response.body);
  //
  //   if (response.statusCode == 200) {
  //     if (widget.oTyp == "1") {
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => Layout(),
  //         ),
  //       );
  //     }
  //   } else {
  //     setState(() {});
  //     print("error otp");
  //     popMessage(context, "Please enter a valid OTP number");
  //     final snackBar = SnackBar(
  //       backgroundColor: Colors.green,
  //       margin: EdgeInsets.symmetric(vertical: 300),
  //       behavior: SnackBarBehavior.floating,
  //       content: Text("Please enter a valid OTP number"),
  //       action: SnackBarAction(
  //         label: 'Undo',
  //         onPressed: () {
  //           // Code to execute when the "Undo" action is pressed
  //         },
  //       ),
  //     );
  //
  //     // Use ScaffoldMessenger to show the Snackbar
  //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //   }
  //   return "";
  // }

  Future<String> validateOtp(otp) async {
    //Check mobile
    try {
      var requestBody = {"phnumber": widget.phn, "otp": otp};

      var jsonRequest = json.encode(requestBody);
      print(jsonRequest);

      Uri url = Uri.parse(
          "$signWithOTPUrl");
      // Uri url = Uri.parse(
      //     "https://admin.goffix.com/api/auth/validateOtp.php");
      print(url);

      var response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json', // Add this header
        },
        body: jsonRequest,
      );
      final jsonString = jsonDecode(response.body);
      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('hello1');
            // var jsonResponse = jsonDecode(response.body);
        // SignInResponse signInResponse = SignInResponse.fromJson(jsonString);
        print('json responce $jsonString');
        SignInResponse signInResponse = SignInResponse.fromJson(jsonString);
        print('email:-  ${signInResponse.email}');
        print('hello2');

        // LoginCredentialsModel loginCredentialsModel = LoginCredentialsModel.fromJson(jsonDecode(response.body));
        print('hello 3');
        setState(() {});
        // print(loginCredentialsModel.token);
            final jsonResponse = jsonDecode(response.body);

    // Extract the token value
    String? token = jsonResponse['token'];

  if (token != null) {
    // Decode the base64 string
    String decodedString = utf8.decode(base64Url.decode(base64.normalize(token)));

    // Convert the decoded string to a Map
    Map<String, dynamic> decodedJson = jsonDecode(decodedString);

    // Accessing individual fields
    print('User ID: ${decodedJson['uid']}');
    print('Name: ${decodedJson['name']}');
    print('Phone: ${decodedJson['phn']}');
    print('Email: ${decodedJson['email']}');
    print('Expiration: ${decodedJson['exp']}');
        // loginCredentialsModel.uid = decodedJson['uid'];
  

    String responseBody = '''
    {
      "token": "$token",
    
      "usname": "${decodedJson['name']}",
      "phnumber": "${decodedJson['phn']}",
      "email": "${decodedJson['email']}",
      "expirationTime": "${decodedJson['exp']}"
    }
  ''';
  print('here');

  // Decode the JSON string to a Map
  Map<String, dynamic> json = jsonDecode(responseBody);
  print('done decoding');
    LoginCredentialsModel loginCredentialsModel = LoginCredentialsModel.fromJson(json);
         Navigator.push(
            context, MaterialPageRoute(builder: (context) => Layout(loginCredentialsModel: loginCredentialsModel,)));
  } else {
    print('Token is null');
  }
   
      } else {
        return "no user found";
      }
      return "Success";
    } catch (e) {
      // return e.toString();
      return 'Invalid Otp';

    }
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
          topColor: Colors.white,
          bottomColor: Colors.white,
          otpLength: 6,
          validateOtp: validateOtp,
          routeCallback: moveToNextScreen,
          themeColor: mainBlue,
          titleColor: mainBlue,
          title: "Phone Number Verification ",
          subTitle: "Enter the code sent to  otp \n " + widget.phn!,
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
