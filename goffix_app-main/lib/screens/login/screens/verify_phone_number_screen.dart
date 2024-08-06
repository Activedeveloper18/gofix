import 'dart:convert';

import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:goffix/constants.dart';
import 'package:goffix/screens/home/homeScreen.dart';
import 'package:goffix/screens/layout/layout.dart';
import 'package:http/http.dart' as http;
import 'package:goffix/screens/login/utils/helpers.dart';
import 'package:goffix/screens/login/widgets/custom_loader.dart';
import 'package:goffix/screens/login/widgets/pin_input_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class VerifyPhoneNumberScreen extends StatefulWidget {
  static const id = 'VerifyPhoneNumberScreen';

  final String? phoneNumber;

  const VerifyPhoneNumberScreen({
    Key? key,
    @required this.phoneNumber,
  }) : super(key: key);

  @override
  State<VerifyPhoneNumberScreen> createState() =>
      _VerifyPhoneNumberScreenState();
}

class _VerifyPhoneNumberScreenState extends State<VerifyPhoneNumberScreen>
    with WidgetsBindingObserver {
  bool isKeyboardVisible = false;

  late ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final bottomViewInsets = WidgetsBinding.instance.window.viewInsets.bottom;
    isKeyboardVisible = bottomViewInsets > 0;
  }

  // scroll to bottom of screen, when pin input field is in focus.
  Future<void> _scrollToBottomOnKeyboardOpen() async {
    while (!isKeyboardVisible) {
      await Future.delayed(const Duration(milliseconds: 50));
    }

    await Future.delayed(const Duration(milliseconds: 250));

    await scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FirebasePhoneAuthHandler(
        phoneNumber: widget.phoneNumber!,
        signOutOnSuccessfulVerification: false,
        linkWithExistingUser: false,
        autoRetrievalTimeOutDuration: const Duration(seconds: 60),
        otpExpirationDuration: const Duration(seconds: 60),
        onCodeSent: () {
          log(VerifyPhoneNumberScreen.id, msg: 'OTP sent!');
        },
        onLoginSuccess: (userCredential, autoVerified) async {
          log(
            VerifyPhoneNumberScreen.id,
            msg: autoVerified
                ? 'OTP was fetched automatically!'
                : 'OTP was verified manually!',
          );

          // showSnackBar('Phone number verified successfully!');
          Toast.show('Phone number verified successfully!',
              duration: Toast.lengthShort, gravity: Toast.bottom);

          logInwithOTp(widget.phoneNumber!);
          log(
            VerifyPhoneNumberScreen.id,
            msg: 'Login Success UID: ${userCredential.user?.uid}',
          );
        },
        onLoginFailed: (authException, stackTrace) {
          log(
            VerifyPhoneNumberScreen.id,
            msg: authException.message,
            error: authException,
            stackTrace: stackTrace,
          );

          switch (authException.code) {
            case 'invalid-phone-number':
              // invalid phone number
              return Toast.show('Phone number verified successfully!',
                  duration: Toast.lengthShort, gravity: Toast.bottom);

            case 'invalid-verification-code':
              // invalid otp entered
              return Toast.show('The entered OTP is invalid!',
                  duration: Toast.lengthShort, gravity: Toast.bottom);

            // handle other error codes
            default:
              Toast.show('Something Went Wrong',
                  duration: Toast.lengthShort, gravity: Toast.bottom);
            // handle error further if needed
          }
        },
        onError: (error, stackTrace) {
          log(
            VerifyPhoneNumberScreen.id,
            error: error,
            stackTrace: stackTrace,
          );

          Toast.show('An error occured',
              duration: Toast.lengthShort, gravity: Toast.bottom);
        },
        builder: (context, controller) {
          return Scaffold(
            appBar: AppBar(
              leadingWidth: 0,
              leading: const SizedBox.shrink(),
              title: const Text('Verify Phone Number'),
              actions: [
                if (controller.codeSent)
                  TextButton(
                    onPressed: controller.isOtpExpired
                        ? () async {
                            log(VerifyPhoneNumberScreen.id, msg: 'Resend OTP');
                            await controller.sendOTP();
                          }
                        : null,
                    child: Text(
                      controller.isOtpExpired
                          ? 'Resend'
                          : '${controller.otpExpirationTimeLeft.inSeconds}s',
                      style: const TextStyle(color: Colors.blue, fontSize: 18),
                    ),
                  ),
                const SizedBox(width: 5),
              ],
            ),
            body: controller.isSendingCode
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      CustomLoader(),
                      SizedBox(height: 50),
                      Center(
                        child: Text(
                          'Sending OTP',
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                    ],
                  )
                : ListView(
                    padding: const EdgeInsets.all(20),
                    controller: scrollController,
                    children: [
                      Text(
                        "We've sent an SMS with a verification code to ${widget.phoneNumber}",
                        style: const TextStyle(fontSize: 25),
                      ),
                      const SizedBox(height: 10),
                      const Divider(),
                      if (controller.isListeningForOtpAutoRetrieve)
                        Column(
                          children: const [
                            CustomLoader(),
                            SizedBox(height: 50),
                            Text(
                              'Listening for OTP',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 15),
                            Divider(),
                            Text('OR', textAlign: TextAlign.center),
                            Divider(),
                          ],
                        ),
                      const SizedBox(height: 15),
                      const Text(
                        'Enter OTP',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 15),
                      PinInputField(
                        length: 6,
                        onFocusChange: (hasFocus) async {
                          if (hasFocus) await _scrollToBottomOnKeyboardOpen();
                        },
                        onSubmit: (enteredOtp) async {
                          final verified =
                              await controller.verifyOtp(enteredOtp);
                          if (verified) {
                            // number verify success
                            // will call onLoginSuccess handler
                          } else {
                            // phone verification failed
                            // will call onLoginFailed or onError callbacks with the error
                          }
                        },
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }

  Future<bool?> logInwithOTp(String mobile) async {
    var requestBody = {
      "service_name": "directlogin",
      "param": {"u_phn": mobile.substring(3)}
    };
    var jsonRequest = json.encode(requestBody);
    print(jsonRequest);
    var response = await http.post(baseUrl,
        headers: {'Accept': 'application/json'}, body: jsonRequest);
    var jsonResponse = null;
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse["response"]["status"] == 200) {
        // _showMyDialog("Success", "User Login Success", "home");
        print("Logged in");

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        String token = jsonResponse['response']['result']['token'].toString();
        // User().setToken(token);
        prefs.setString('token', token);
        String uid = jsonResponse['response']['result']['u_id'].toString();
        int u_id = int.parse(uid);
        // User().setUID(u_id);
        prefs.setInt('uid', u_id);
        // Navigator.of(context).pop();
        // Navigator.of(context).pushReplacement(
        //     new MaterialPageRoute(builder: (context) => Layout()));
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => Layout(),
          ),
          (route) => false,
        );
      } else if (jsonResponse["response"]["status"] == 202) {
        _showMyDialog("Error", "User not found", "login");
        print("User not found");
      }
    } else {
      print("Something Went Wrong");
    }
  }

  Future<void> _showMyDialog(String res, String msg, String route) async {
    // var context;
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(res),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(msg),
                // Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                if (route == "home") {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (BuildContext context) => Layout()),
                  );
                } else if (route == "login") {
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
