import 'package:Ict/stores/login_store.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../screens/playlist_screen.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List allVideoList;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser firebaseUser;
  var notification;
  String userStatusInfomation;
  final databaseReference = FirebaseDatabase.instance.reference();
  bool _progressController = true;

  Future<dynamic> currentUserPhoneNumber() async {
    firebaseUser = await _auth.currentUser();
    return firebaseUser.phoneNumber;
  }

  Future<List> readChapersData() async {
    var videolists;
    var valueToBack = await databaseReference
        .child("data")
        .child("chapters")
        .once()
        .then((DataSnapshot snapshot) {
      // print('Data : ${snapshot.value}');
      // List<Map<String, List<Map<dynamic, dynamic>>>> extractedData =
      // json.decode(snapshot.value);
      List<dynamic> extractedData = snapshot.value;
      videolists = extractedData;
      return videolists;

      // allVideoList = extractedData;
    });
    return valueToBack;
  }

  Future<String> readNotificationsData() async {
    var notification;
    var valueToBack = await databaseReference
        .child("data")
        .child("notification")
        .once()
        .then((DataSnapshot snapshot) {
      String extractedData = snapshot.value;
      notification = extractedData;
      return notification;

      // allVideoList = extractedData;
    });
    return valueToBack;
  }

  Future<String> readUserData(var phoneNUmber) async {
    String userInfo;

    String valueToBack = await databaseReference
        .child("data")
        .child(phoneNUmber)
        .child("status")
        .once()
        .then((DataSnapshot snapshot) {
      String extractedData = snapshot.value;
      userInfo = extractedData;
      return userInfo;

      // allVideoList = extractedData;
    });
    return valueToBack;
  }

  Future<dynamic> getAllInfomation() async {
    var chapters = await readChapersData();
    var phone = await currentUserPhoneNumber();
    var userStatus = await readUserData(phone);
    var noti = await readNotificationsData();

    return [chapters, noti, userStatus];
  }

  void _showDialog(var noti) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          content: new Text(
            noti,
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void didChangeDependencies() {
    getAllInfomation().then((value) {
      setState(() {
        allVideoList = value[0];
        notification = value[1];
        userStatusInfomation = value[2];
        _progressController = false;
      });
    });

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginStore>(
      builder: (_, loginStore, __) {
        return Scaffold(
          drawer: Drawer(
            child: ListView(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.contact_mail),
                  title: Text("Your name"),
                  trailing: Icon(Icons.arrow_forward),
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: Text("Log out"),
                  trailing: Icon(Icons.arrow_forward),
                  onTap: () {
                    loginStore.signOut(context);
                  },
                ),
                Divider(),
              ],
            ),
          ),
          appBar: AppBar(
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.refresh,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/home');
                },
              ),
              notification == ""
                  ? IconButton(
                      icon: Icon(
                        Icons.notifications_active,
                        color: Colors.transparent,
                      ),
                      onPressed: null,
                    )
                  : IconButton(
                      icon: Icon(
                        Icons.notifications_active,
                        color: Colors.yellow,
                      ),
                      onPressed: () {
                        _showDialog(notification);
                      },
                    ),
            ],
          ),
          body: _progressController
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  itemBuilder: (cxt, index) {
                    return Card(
                      child: ListTile(
                        onTap: () {
                          ((index >= 1 && userStatusInfomation == '1') ||
                                  index < 1)
                              ? Navigator.of(context).pushNamed(
                                  PlaylistScreen.routeName,
                                  arguments: [
                                      allVideoList[index]['videolists'],
                                      allVideoList[index]['name']
                                    ])
                              : Navigator.of(context).pushNamed('/transaction');
                        },
                        leading: Icon(
                          Icons.video_library,
                          color: Colors.black87,
                        ),
                        title: Text(allVideoList[index]['name']),
                        subtitle:
                            Text(allVideoList[index]['duration_and_lessons']),
                        trailing:
                            ((index >= 1 && userStatusInfomation == '1') ||
                                    index < 1)
                                ? Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.grey,
                                  )
                                : Icon(
                                    Icons.info,
                                    color: Colors.black,
                                  ),
                      ),
                    );
                  },
                  itemCount:
                      allVideoList.length == null ? 0 : allVideoList.length,
                ),
        );
      },
    );
  }
}
