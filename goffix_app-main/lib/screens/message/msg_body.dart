import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:goffix/constants.dart';
import 'package:goffix/models/post_model.dart';
import 'package:goffix/providers/db_provider.dart';
import 'package:goffix/screens/layout/layout.dart';
// import 'package:jiffy/jiffy.dart';
import 'msg_model.dart';
import 'package:goffix/screens/login/login.dart' as Login;
import 'package:http/http.dart' as http;

// import 'package:flutter_chat_ui/models/user_model.dart';

class MessageScreen extends StatefulWidget {
  // final User user;

  // ChatScreen({this.user});
  int? uid;
  int? fdid;
  int? pid;
  String? userimage;
  String? username;

  @override
  MessageScreen(
      {Key? key, this.uid, this.fdid, this.pid, this.userimage, this.username})
      : super(key: key);
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  String TestUsername = "SQL Database Projects extension";
  late Map userPostDetails;
  late String uImg;
  late String uName;
  late int userid;
  late String token;
  late List listOfMsgs;
  bool SndBtnIsEnabaled = false;
  bool IsMsgRead = false;

  Future<dynamic> param() async {
    int? _uid = await Login.User().getUID();
    String? _token = await Login.User().getToken();
    if (this.mounted) {
      setState(() {
        userid = _uid!;
        token = _token!;
      });
    }
  }

  Future<dynamic> _fetchUser() async {
    List<Map<String, dynamic>> queryRows =
        await DBProvider.db.getUidDetails(widget.fdid, widget.pid);
    if (this.mounted) {
      setState(() {
        userPostDetails = queryRows.asMap();
      });
    }
    uName = userPostDetails[0]['u_nm'];
    uImg = userPostDetails[0]['u_img'];
    print(userPostDetails[0]['u_img']);
  }

  image_64(String _img64) {
    if (_img64 != null) {
      List img = _img64.split(",");
      Uint8List _bytesImage;
      _bytesImage = Base64Decoder().convert(img[1]);
      return _bytesImage;
    }
  }

//read Status
  Future<dynamic> _changeReadStatus() async {
    String? token = await Login.User().getToken();
    int? uid = await Login.User().getUID();
    var requestBody = {
      "service_name": "checkNewMsgschange",
      "param": {
        "u_id": uid,
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
      if (jsonResponse["response"]["status"] == 200) {
        if (jsonResponse.length != null) {
          if (jsonResponse['response']['result']['data'] == "true") {
            if (mounted) {
              setState(() {
                IsMsgRead = true;
              });
            }
            print("Msg found:" + IsMsgRead.toString());
          }
          // print("ads");
        } else if (jsonResponse["response"]["status"] == 108) {
          print("msgs not found");
        }
      } else {
        print("Something Went Wrong");
      }
      print(IsMsgRead);
      return IsMsgRead;
    }
  }

  Future<dynamic> _getMsg() async {
    int? _uid = await Login.User().getUID();
    String? _token = await Login.User().getToken();
    var requestBody = {
      "service_name": "getmsg",
      "param": {"pid": widget.pid, "uid": widget.uid, "rid": widget.fdid}
    };
    var jsonRequest = json.encode(requestBody);
    print(jsonRequest);
    var response = await http.post(baseUrl,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $_token',
        },
        body: jsonRequest);
    var jsonResponse = null;
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse["response"]["status"] == 200) {
        if (jsonResponse['response']['result']['data'] != null) {
          if (this.mounted) {
            setState(() {
              listOfMsgs = jsonResponse['response']['result']['data'];
            });
          }
          listOfMsgs.sort((a, b) {
            var adate = a['m_dt']; //before -> var adate = a.expiry;
            var bdate = b['m_dt']; //var bdate = b.expiry;
            return -adate.compareTo(bdate);
          });
        }
      } else if (jsonResponse["response"]["status"] == 108) {
        // _showMyDialog("Error", "Username/Password not found", "login");
        print("No Message found");
      } else {
        print("Something Went Wrong");
      }
    }
  }

  Future<dynamic> _getLastMsg() async {
    int? _uid = await Login.User().getUID();
    String? _token = await Login.User().getToken();
    var requestBody = {
      "service_name": "chatLastActivity",
      "param": {"pid": widget.pid, "sid": widget.uid, "rid": widget.fdid}
    };
    var jsonRequest = json.encode(requestBody);
    print(jsonRequest);
    var response = await http.post(baseUrl,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $_token',
        },
        body: jsonRequest);
    var jsonResponse = null;
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse["response"]["status"] == 200) {
        if (this.mounted) {
          setState(() {
            //   listOfMsgs = jsonResponse['response']['result']['data'];
            listOfMsgs.add(jsonResponse['response']['result']['data']);
          });
        }
        // listOfMsgs.add(jsonResponse['response']['result']['data']);
        // listOfMsgs.sort((a, b) {
        //   var adate = a['m_dt']; //before -> var adate = a.expiry;
        //   var bdate = b['m_dt']; //var bdate = b.expiry;
        //   return -adate.compareTo(bdate);
        // });
      } else if (jsonResponse["response"]["status"] == 108) {
        // _showMyDialog("Error", "Username/Password not found", "login");
        print("No Message found");
      } else {
        print("Something Went Wrong");
      }
    }
  }

  Future<dynamic> _sendMsg(msgBody) async {
    int? _uid = await Login.User().getUID();
    String? _token = await Login.User().getToken();
    int? pid = widget.pid;
    var requestBody = {
      "service_name": "addMessage",
      "param": {
        "m_body": msgBody,
        "m_pid": pid,
        "m_sid": widget.uid,
        "m_rid": widget.fdid
      }
    };
    var jsonRequest = json.encode(requestBody);
    print(jsonRequest);
    var response = await http.post(baseUrl,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $_token',
        },
        body: jsonRequest);
    var jsonResponse = null;
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse["response"]["status"] == 200) {
        print(msgBody);
        // bool isMe = true;
        // var msgPush = {"m_body": msgBody, "m_dt": DateTime.now()};
        // _buildMessage(msgPush, isMe);
        _getMsg();
        _msgController.clear();
        if (this.mounted) {
          setState(() {
            SndBtnIsEnabaled = false;
          });
        }
        // setState(() {});
      }
    }
  }

  bool isStopped = false; //global
  sec5Timer() {
    Timer.periodic(Duration(seconds: 5), (timer) {
      if (isStopped) {
        timer.cancel();
      }
      // _getLastMsg();
      _getMsg();
      // print("Dekhi 5 sec por por kisu hy ni :/");
    });
  }
  // }

  // Future.delayed(Duration(seconds: 1), () {
  //           print('yo hey');
  //         });
  _buildMessage(message, bool isMe) {
    final Container msg = Container(
      margin: isMe
          ? EdgeInsets.only(
              top: 8.0,
              bottom: 8.0,
              left: 80.0,
            )
          : EdgeInsets.only(
              top: 8.0,
              bottom: 8.0,
            ),
      padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
      width: MediaQuery.of(context).size.width * 0.75,
      decoration: BoxDecoration(
        color: isMe ? mainBlue : Color(0xFFFFEFEE),
        borderRadius: isMe
            ? BorderRadius.only(
                topLeft: Radius.circular(15.0),
                bottomLeft: Radius.circular(15.0),
              )
            : BorderRadius.only(
                topRight: Radius.circular(15.0),
                bottomRight: Radius.circular(15.0),
              ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Text(
          //   Jiffy(message['m_dt']).fromNow(),
          //   style: TextStyle(
          //     color: isMe ? Colors.white : mainBlue,
          //     fontSize: 16.0,
          //     fontWeight: FontWeight.w600,
          //   ),
          // ),
          SizedBox(height: 8.0),
          Text(
            message['m_body'],
            style: TextStyle(
              color: isMe ? Colors.white : mainBlue,
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
    if (isMe) {
      return msg;
    }
    return Row(
      children: <Widget>[
        msg,
        // IconButton(
        //   icon: message.isLiked
        //       ? Icon(Icons.favorite)
        //       : Icon(Icons.favorite_border),
        //   iconSize: 30.0,
        //   color: message.isLiked
        //       ? Theme.of(context).primaryColor
        //       : Colors.blueGrey,
        //   onPressed: () {},
        // )
      ],
    );
  }

  final TextEditingController _msgController = new TextEditingController();
  _buildMessageComposer() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      height: 70.0,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          // IconButton(
          //   icon: Icon(Icons.photo),
          //   iconSize: 25.0,
          //   color: Theme.of(context).primaryColor,
          //   onPressed: () {},
          // ),
          Expanded(
            child: TextField(
              textCapitalization: TextCapitalization.sentences,
              controller: _msgController,
              style: TextStyle(color: mainBlue),
              onChanged: (value) {
                if (value != null || value != "") {
                  print("test");
                  if (this.mounted) {
                    setState(() {
                      SndBtnIsEnabaled = true;
                    });
                  }
                } else {
                  if (this.mounted) {
                    setState(() {
                      SndBtnIsEnabaled = false;
                    });
                  }
                }
              },
              keyboardType: TextInputType.multiline,
              minLines: 1,
              maxLines: 5,
              decoration: InputDecoration.collapsed(
                hintText: 'Send a message...',
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            iconSize: 25.0,
            color: mainOrange,
            onPressed: SndBtnIsEnabaled
                ? () {
                    print(_msgController.text);
                    _sendMsg(_msgController.text);
                  }
                : null,
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    this._getMsg();
    this.param();
    this._changeReadStatus();
    // this.sec5Timer();

    // this._fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainBlue,
      appBar: AppBar(
        title: Container(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              // InkWell(
              //   onTap: () {
              //     Navigator.pushReplacement(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) =>
              //             // HomeScreen(uid: uid, username: username),
              //             Layout(),
              //       ),
              //     );
              //   },
              //   child: Icon(Icons.arrow_back_ios),
              // ),
              // SizedBox(
              //   width: 10,
              // ),
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: widget.userimage != null
                    ? Image.memory(
                        image_64(widget.userimage!),
                        height: 40,
                      )
                    : Image.asset('assets/images/profile.jpg', height: 40),
                // MemoryImage(image_64(uImg)),
              ),
              SizedBox(
                width: 10,
              ),
              // AutoSizeText(
              //   widget.username,
              //   maxLines: 1,
              //   softWrap: true,
              //   minFontSize: 10,
              //   overflow: TextOverflow.ellipsis,
              //   style: TextStyle(
              //     fontSize: 20.0,
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
              Text(
                widget.username!.length > 20
                    ? widget.username!.substring(0, 20) + '...'
                    : widget.username!,
                // TestUsername.length > 20
                //     ? TestUsername.substring(0, 20) + '...'
                //     : TestUsername,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
        elevation: 10.0,
        // actions: <Widget>[
        //   IconButton(
        //     icon: Icon(Icons.more_horiz),
        //     iconSize: 30.0,
        //     color: Colors.white,
        //     onPressed: () {},
        //   ),
        // ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: <Widget>[
            // Container(
            //   child: Text("Test Job Title"),
            // ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 0.0),
                    child: Container(
                      child: listOfMsgs == null
                          ? Center(
                              child: Container(
                                child: Text("No Messages"),
                              ),
                            )
                          : ListView.builder(
                              reverse: true,
                              padding: EdgeInsets.only(top: 15.0),
                              itemCount: listOfMsgs.length,
                              itemBuilder: (BuildContext context, int index) {
                                final msg = listOfMsgs[index];
                                // final bool isMe =
                                //     listOfMsgs[index]['m_sid'] == widget.uid
                                //         ? true
                                //         : false;
                                bool isMe = false;
                                print(listOfMsgs[index]['m_sid']);
                                if (listOfMsgs[index]['m_sid'].toString() ==
                                    widget.uid.toString()) {
                                  isMe = true;
                                }
                                // final Message message = messages[index];
                                // final bool isMe = message.sender.id == currentUser.id;
                                return _buildMessage(msg, isMe);
                              },
                            ),
                    ),
                  ),
                ),
              ),
            ),
            _buildMessageComposer(),
          ],
        ),
      ),
    );
  }
}
