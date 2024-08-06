import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:goffix/constants.dart';
import 'package:goffix/main.dart';
import 'package:goffix/screens/home/homeScreen.dart';
import 'package:goffix/screens/login/login.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class CameraPage extends StatefulWidget {
  final String? uid;
  @override
  const CameraPage({Key? key, this.uid}) : super(key: key);
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late File _selectedFile;
  bool _inProcess = false;
  late String _profileImage;
  Widget getImageWidget() {
    if (_selectedFile != null) {
      _convertImageDataUrl(_selectedFile);
      return Image.file(
        _selectedFile,
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
  }

  // _convertImageStringDataUrl(String _imageFile) async {
  //   Directory dbDir = await getApplicationDocumentsDirectory();
  //   var dbPath = join(dbDir.path, _imageFile);
  //   ByteData data = await rootBundle.load(_imageFile);
  //   final bytes = File(_imageFile).readAsBytesSync();
  //   String head = "data:image/jpeg;base64,";
  //   String _base64 = base64.encode(bytes);
  //   String img = head + _base64;
  //   print(img);
  //   setState(() {
  //     _profileImage = img;
  //   });
  // }

  getImage(ImageSource source) async {
    this.setState(() {
      _inProcess = true;
    });
    final picker = ImagePicker();
    final image = await picker.getImage(source: source);
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
      this.setState(() {
        _selectedFile = cropped!;
      });
    } else {
      this.setState(() {
        _inProcess = false;
      });
    }
  }

//Upload Image
  Future<dynamic> _upload() async {
    // BuildContext context;
    if (_selectedFile != null) {
      var requestBody = {
        "service_name": "addProfileImage",
        "param": {"u_id": 25, "u_img": _profileImage}
      };
      var jsonRequest = json.encode(requestBody);
      print(jsonRequest);
      var response = await http.post(baseUrl,
          headers: {
            'Accept': 'application/json',
          },
          body: jsonRequest);
      var jsonResponse = null;

      if (response.statusCode == 200) {
        jsonResponse = json.decode(response.body);
        print(jsonResponse);
        if (jsonResponse["response"]["status"] == 200) {
          // Navigator.push(
          //   context,
          //   new MaterialPageRoute(
          //       builder: (context) =>
          //           // HomeScreen(uid: uid, username: username),
          //           // SettingsScreen(),
          //           HomeScreen()),
          // );
          // Navigator.push(context,
          //     MaterialPageRoute(builder: () => LoginOtpScreen()));
          // print("success");
        } else {
          print("Image not Uploaded");
        }
      }
    } else {
      print("Please Select image");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Image.asset(
              "assets/images/logo.png",
              height: 70,
            ),
            SizedBox(
              height: 50,
            ),
            getImageWidget(),
            SizedBox(
              height: 20,
            ),
            _selectedFile != null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 50,
                        width: 150,
                        child: ElevatedButton(
                          // shape: RoundedRectangleBorder(
                          //   borderRadius: BorderRadius.circular(25.0),
                          // ),
                          // elevation: 10,
                          // textColor: Colors.white,
                          onPressed: () => {_upload()},
                          // color: mainBlue,
                          // splashColor: mainBlue,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[Text("Upload")],
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Container(
                        height: 50,
                        width: 150,
                        child: ElevatedButton(
                          // shape: RoundedRectangleBorder(
                          //   borderRadius: BorderRadius.circular(25.0),
                          // ),
                          // elevation: 10,
                          // textColor: Colors.white,
                          onPressed: () => {
                            this.setState(() {
                              // _selectedFile = null;
                              // _inProcess = false;
                            })
                          },
                          // color: mainBlue,
                          // splashColor: mainBlue,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[Text("Clear")],
                          ),
                        ),
                      ),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 50,
                        width: 150,
                        child: ElevatedButton(
                          // shape: RoundedRectangleBorder(
                          //   borderRadius: BorderRadius.circular(25.0),
                          // ),
                          // elevation: 10,
                          // textColor: Colors.white,
                          onPressed: () => {getImage(ImageSource.camera)},
                          // color: mainBlue,
                          // splashColor: mainBlue,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[Text("Camera")],
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Container(
                        height: 50,
                        width: 150,
                        child: ElevatedButton(
                          // shape: RoundedRectangleBorder(
                          //   borderRadius: BorderRadius.circular(25.0),
                          // ),
                          // elevation: 10,
                          // textColor: Colors.white,
                          onPressed: () => {getImage(ImageSource.gallery)},
                          // color: mainBlue,
                          // splashColor: mainBlue,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[Text("Gallery")],
                          ),
                        ),
                      ),
                    ],
                  ),
            SizedBox(
              height: 30,
            ),
            _selectedFile != null
                ? Container()
                : Container(
                    child: Center(
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              right: 50, top: 10, bottom: 10),
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () {
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) => SignupScreen()));
                                    _convertImageDataUrl(
                                        File("assets/images/male.png"));
                                  },
                                  child: Text(
                                    " Skip for now",
                                    style: TextStyle(
                                        color: mainBlue,
                                        fontFamily: "Lato",
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
          ],
        ),
        (_inProcess)
            ? Container(
                color: Colors.white,
                height: MediaQuery.of(context).size.height * 0.95,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : Center()
      ],
    ));
  }
}
