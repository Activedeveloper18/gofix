import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:goffix/screens/login/login.dart';
import 'package:goffix/screens/otp/otpScreen.dart';
import 'package:goffix/screens/profile/ProfileScreenNew.dart';
import 'package:goffix/screens/settings/settings.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:goffix/constants.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../profile/model/userprofilemodels.dart';

class SignupEditScreen extends StatefulWidget {
  UserProfileModel? userDetails;
  SignupEditScreen({
    this.userDetails,
  });
  @override
  _SignupEditScreenState createState() => _SignupEditScreenState();
}

class _SignupEditScreenState extends State<SignupEditScreen> {
  //Variables

  String? _unm;
  String? _email;
  String? _desc;
  String? _upfn;
  String? _uimg;
  File? _selectedFile;
  bool _inProcess = false;
  String? _profileImage;
  bool _dummyImg = false;
  //validators
  bool _nmValError = false;
  bool _phnValError = false;
  bool _emValError = false;
  bool _pwdValError = false;
  bool _genValError = false;
  bool _locValError = false;
  bool _proValError = false;

  //Values
  late int _genTextFeild;
  var _gender = ['Male', 'Female'];
  late int _catTextFeild;
  late int _locTextFeild;
  late List listOfLoc;

//Controllers
  final TextEditingController _categoryController = new TextEditingController();
  final TextEditingController _locationController = new TextEditingController();

  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _pwdController = new TextEditingController();
  final TextEditingController _phnController = new TextEditingController();
  image_64(String _img64) {
    if (_img64 != null) {
      List img = _img64.split(",");
      Uint8List _bytesImage;
      _bytesImage = Base64Decoder().convert(img[1]);
      // return Image.memory(_bytesImage);
      return _bytesImage;
    }
  }

  Future<dynamic> _UpdateUser(context) async {
    String? token = await User().getToken();
    int? uid = await User().getUID();
    if (_uimg == null) {
      _uimg == "file:///android_asset/www/images/male.png";
    }
    //Check mobile
    var requestBody = {
      "service_name": "registerupdate",
      "param": {
        "u_nm": _unm,
        "u_id": uid,
        "u_email": _email,
        "u_desc": _desc,
        "u_pfn": _upfn,
        "u_img": _uimg
      }
    };
    var jsonRequest = json.encode(requestBody);
    print(jsonRequest);
    var response = await http.post(baseUrl,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonRequest);
    var jsonResponse = null;

    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if (jsonResponse["response"]["status"] == 200) {
        // Alert(title: "Success",)
        // otp response
//         {
//     "response": {
//         "status": 200,
//         "result": {
//             "otp": "067d40152f03259370a6",
//             "data": "1297"
//         }
//     }
// }
        Alert(
          context: context,
          type: AlertType.success,
          title: "Profile Updated Sucessfully",
          // desc:
          //     "Flutter is more awesome with RFlutter Alert.",

          buttons: [
            DialogButton(
              child: Text(
                "Okay",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () {
                // getImage(ImageSource.camera).then({
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          // HomeScreen(uid: uid, username: username),
                          ProfilePageScreen()),
                );
                // });
              },
              width: 120,
            ),
          ],
        ).show();

        print("success");
      } else {
        print("Post not posted");
      }
    }
  }

  Future<dynamic> _getUserDetails() async {
    String? token = await User().getToken();
    int? uid = await User().getUID();
    var requestBody = {
      "service_name": "userProfileInfo",
      "param": {"uid": uid, "utype": "1"}
    };
    var jsonRequest = json.encode(requestBody);
    print(jsonRequest);
    var response = await http.post(baseUrl,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonRequest);
    var jsonResponse = null;
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse["response"]["status"] == 200) {
        setState(() {
          // userDetails = jsonResponse['response']['result']['data']['profile'];
          // _unm = jsonResponse['response']['result']['data']['profile']['u_nm'];
          // _upfn =
          //     jsonResponse['response']['result']['data']['profile']['u_pfn'];
          // _uimg =
          //     jsonResponse['response']['result']['data']['profile']['u_img'];
          // _desc =
          //     jsonResponse['response']['result']['data']['profile']['u_desc'];
          // _email =
          //     jsonResponse['response']['result']['data']['profile']['u_email'];
        });
      } else if (jsonResponse["response"]["status"] == 108) {
        // _showMyDialog("Error", "Username/Password not found", "login");
        print("Users not found");
      } else {
        print("Something Went Wrong");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    this._getUserDetails();
  }

  getImage(ImageSource source) async {
    this.setState(() {
      _inProcess = true;
    });
    final picker = ImagePicker();
    final image = await picker.pickImage(source: source);
    if (image != null) {
      File? cropped = await ImageCropper().cropImage(
          sourcePath: image.path,
          aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
          compressQuality: 80,
          maxWidth: 200,
          maxHeight: 200,
          compressFormat: ImageCompressFormat.png,
          androidUiSettings: AndroidUiSettings(
            toolbarColor: mainOrange,
            toolbarTitle: "Goffix",
            statusBarColor: Colors.deepOrange.shade900,
            backgroundColor: Colors.white,
          ));
      String img = _convertImageDataUrl(cropped!);
      setState(() {
        _selectedFile = cropped;
        _inProcess = false;
        _uimg = img;
      });
    } else {
      this.setState(() {
        _inProcess = false;
      });
    }
  }

  Widget getImageWidget() {
    if (_selectedFile != null) {
      _convertImageDataUrl(_selectedFile!);
      return Image.file(
        _selectedFile!,
        width: 200,
        height: 200,
        fit: BoxFit.cover,
      );
    } else {
      return Image.asset(
        "assets/images/male.png",
        height: 200,
      );
    }
  }

  _convertImageDataUrl(File _imageFile) {
    final bytes = File(_imageFile.path).readAsBytesSync();
    String head = "data:image/jpeg;base64,";
    String _base64 = base64.encode(bytes);
    String img = head + _base64;
    print(img);
    setState(() {
      _profileImage = img;
    });
    return img;
  }

  // String u_nm = userDetails['u_nm'];
  final TextEditingController _nameController =
      new TextEditingController(text: '_unm');
  // final _nmController = TextEditingController(text: _unm);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: mainBlue, //change your color here
        ),
        elevation: 30,
        bottomOpacity: 0.8,
        toolbarHeight: 60,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            InkWell(
                // onTap: () {
                //   _getPosts();
                // },
                child: Text(
              "Update Profile",
              style: TextStyle(color: mainBlue),
            )),
          ],
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  child: Column(
                    children: <Widget>[
                      // widget.userDetails == null
                      //     ? Container(
                      //         height: size.height,
                      //         width: size.width,
                      //         child: Center(
                      //           child: CircularProgressIndicator(),
                      //         ),
                      //       )
                      //     :
                      Container(
                          padding: EdgeInsets.only(left: 10.0, right: 10.0),
                          width: double.infinity,
                          // height: 650,
                          child: Form(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Container(
                                    height: 80,
                                    width: MediaQuery.of(context).size.width,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.grey,
                                              spreadRadius: 2.0,
                                              blurRadius: 5.0,
                                              offset: Offset(0, 10)),
                                        ]),
                                    child: Text(
                                      "SAVED ADDRESS",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w900,
                                          color: Colors.indigo,
                                          fontSize: 30),
                                    ),
                                  ),
                                ),
                                10.verticalSpace,
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(Icons.home_outlined),
                                        Text(
                                            "Avinash\nplot no 64\nnear gachhiboli\n53002\n9798969594"),
                                      ],
                                    ),
                                    Icon(Icons.delete_outline_sharp),
                                  ],
                                ),

                                Container(
                                  child: Column(children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          border: _nmValError == true
                                              ? Border.all(
                                                  color: Colors.red, width: 1)
                                              : Border.all(
                                                  color: Colors.transparent),
                                          color: Colors.grey[300]),
                                      margin: EdgeInsets.all(8),
                                      child: FormBuilderTextField(
                                        maxLength: 20,
                                        // initialValue: widget.userDetails!.name,
                                        // initialValue: "tre",
                                        onChanged: (String? val) {
                                          if (val!.isNotEmpty) {
                                            setState(() {
                                              _nmValError = false;
                                              _unm = val;
                                            });
                                          }
                                        },

                                        name: 'Name',
                                        // controller: _nameController,

                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          counterText: "",
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey.shade300,
                                                  width: 32.0),
                                              borderRadius:
                                                  BorderRadius.circular(25.0)),
                                          contentPadding: EdgeInsets.fromLTRB(
                                              20.0, 5.0, 20.0, 5.0),
                                          focusColor: Colors.green,
                                          hintText: 'Landmark ',
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(left: 20),
                                      child: _nmValError
                                          ? Row(children: [
                                              Text(
                                                "Please enter Full Name",
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ),
                                            ])
                                          : Row(),
                                    ),
                                  ]),
                                ),
                                // Email
                                Container(
                                  child: Column(children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          border: _emValError == true
                                              ? Border.all(
                                                  color: Colors.red, width: 1)
                                              : Border.all(
                                                  color: Colors.transparent),
                                          color: Colors.grey[300]),
                                      margin: EdgeInsets.all(8),
                                      child: FormBuilderTextField(
                                        // initialValue:
                                        //     widget.userDetails!.email,
                                        onChanged: (String? val) {
                                          if (val!.isNotEmpty) {
                                            setState(() {
                                              _phnValError = false;
                                              _email = val;
                                            });
                                          }
                                        },
                                        name: 'Email',
                                        // controller: _emailController,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0)),
                                          contentPadding: EdgeInsets.fromLTRB(
                                              20.0, 5.0, 20.0, 5.0),
                                          focusColor: Colors.green,
                                          fillColor: Colors.grey,
                                          hintText: 'Plot / House No',
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(left: 20),
                                      child: _emValError
                                          ? Row(children: [
                                              Text(
                                                "Please enter Email",
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ),
                                            ])
                                          : Row(),
                                    ),
                                  ]),
                                ),
                                // Desc
                                Container(
                                  child: Column(children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          border: _emValError == true
                                              ? Border.all(
                                                  color: Colors.red, width: 1)
                                              : Border.all(
                                                  color: Colors.transparent),
                                          color: Colors.grey[300]),
                                      margin: EdgeInsets.all(8),
                                      child: FormBuilderTextField(
                                        maxLength: 6,
                                        // initialValue: widget.userDetails!.mobileNumber,
                                        onChanged: (String? val) {
                                          if (val!.isNotEmpty) {
                                            setState(() {
                                              _phnValError = false;
                                              _desc = val;
                                            });
                                          }
                                        },
                                        name: 'Description',
                                        // controller: _emailController,
                                        decoration: InputDecoration(
                                          counterText: "",
                                          border: InputBorder.none,
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey.shade300,
                                                  width: 32.0),
                                              borderRadius:
                                                  BorderRadius.circular(25.0)),
                                          contentPadding: EdgeInsets.fromLTRB(
                                              20.0, 5.0, 20.0, 5.0),
                                          focusColor: Colors.green,
                                          fillColor: Colors.grey,
                                          hintText: 'Pincode',
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(left: 20),
                                      child: _emValError
                                          ? Row(children: [
                                              Text(
                                                "Please enter Email",
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ),
                                            ])
                                          : Row(),
                                    ),
                                  ]),
                                ),
                                // Update Button
                                Container(
                                  margin: EdgeInsets.all(5),
                                  child: Padding(
                                    padding: const EdgeInsets.all(0.0),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Container(
                                            child: ElevatedButton(
                                              style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          mainBlue)),
                                              // shape: RoundedRectangleBorder(
                                              //   borderRadius:
                                              //       BorderRadius.circular(
                                              //           18.0),
                                              // ),
                                              // elevation: 10,
                                              // textColor: Colors.white,
                                              onPressed: () =>
                                                  {_UpdateUser(context)},
                                              // color: mainOrange,
                                              // splashColor: mainBlue,
                                              // padding: EdgeInsets.all(10.0),
                                              child: Row(
                                                // Replace with a Row for horizontal icon + text
                                                children: <Widget>[
                                                  // Icon(Icons.update),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    "Update",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ]),
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
