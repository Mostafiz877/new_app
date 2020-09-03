import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TransactionScreen extends StatefulWidget {
  static const routeName = '/transaction';

  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  bool isSetText = true;
  var userInfo;
  var thisUserPhoneNUmber;
  bool _progressController = true;
  final databaseReference = FirebaseDatabase.instance.reference();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser firebaseUser;
  var name;
  var bkashPhoneNumber;
  var transactionId;

  final _bkashFocusNode = FocusNode();
  final _transactionIdFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();

  @override
  void dispose() {
    _bkashFocusNode.dispose();
    _transactionIdFocusNode.dispose();

    super.dispose();
  }

  Future<dynamic> currentUserPhoneNumber() async {
    firebaseUser = await _auth.currentUser();
    return firebaseUser.phoneNumber;
  }

  Future<dynamic> readUserData(String phoneNumber) async {
    var userInfomation;
    var valueToBack = await databaseReference
        .child("data")
        .child(phoneNumber)
        .once()
        .then((DataSnapshot snapshot) {
      var extractedData = snapshot.value;
      userInfomation = extractedData;
      return userInfomation;

      // allVideoList = extractedData;
    });
    return valueToBack;
  }

  Future<dynamic> getThisUserInfo() async {
    final phoneNumber = await currentUserPhoneNumber();
    final userInfoList = await readUserData(phoneNumber);
    return [userInfoList, phoneNumber];
  }

  void setUserData(name, phone, bkash, transactionId) {
    databaseReference.child("data").child(phone).set({
      'name': name,
      'bkash': bkash,
      'transactionId': transactionId,
      'status': "0"
    }).then((_) {
      Navigator.of(context).pushReplacementNamed('/transaction');
    });
  }

  void updateData(name, phone, bkash, transactionId, status) {
    databaseReference.child('data').child(phone).update({
      'name': name,
      'bkash': bkash,
      'transactionId': transactionId,
      'status': status
    }).then((value) {
      Navigator.of(context).pushReplacementNamed('/transaction');
    });
  }

  void _saveFormForSet() {
    if (_form.currentState.validate()) {
      _form.currentState.save();
      Navigator.of(context).pop();
      if (name != "" && bkashPhoneNumber != "" && transactionId != "") {
        setUserData(name, thisUserPhoneNUmber, bkashPhoneNumber, transactionId);
      }
    }
  }

  void formWidgetForSet() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          content: Form(
            key: _form,
            child: Scrollbar(
              child: ListView(
                children: <Widget>[
                  TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please provide name";
                      }
                      return null;
                    },
                    decoration: InputDecoration(labelText: 'Name'),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_bkashFocusNode);
                    },
                    onSaved: (value) {
                      name = value;
                    },
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value.length != 11) {
                        return "Please provide 11 digit bKash number";
                      }
                      return null;
                    },
                    decoration: InputDecoration(labelText: 'bKash Number'),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    focusNode: _bkashFocusNode,
                    onSaved: (value) {
                      bkashPhoneNumber = value;
                    },
                    onFieldSubmitted: (_) {
                      FocusScope.of(context)
                          .requestFocus(_transactionIdFocusNode);
                    },
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please provide transaction Id";
                      }
                      return null;
                    },
                    decoration: InputDecoration(labelText: 'Transaction Id'),
                    textInputAction: TextInputAction.done,
                    focusNode: _transactionIdFocusNode,
                    onSaved: (value) {
                      transactionId = value;
                    },
                    onEditingComplete: _saveFormForSet,
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              color: Colors.blue,
              onPressed: () {
                _saveFormForSet();
              },
              child: Text(
                "Set",
                style: TextStyle(color: Colors.white),
              ),
            ),
            FlatButton(
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

  void _saveFormForEdit() {
    if (_form.currentState.validate()) {
      _form.currentState.save();
      Navigator.of(context).pop();
      if (name != "" && bkashPhoneNumber != "" && transactionId != "") {
        updateData(name, thisUserPhoneNUmber, bkashPhoneNumber, transactionId,
            userInfo['status']);
      }
    }
  }

  void formWidgetForEdit(nameParam, bKashParam, transactionIdParam) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          content: Form(
            key: _form,
            child: Scrollbar(
              child: ListView(
                children: <Widget>[
                  TextFormField(
                    initialValue: nameParam,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please provide name";
                      }
                      return null;
                    },
                    decoration: InputDecoration(labelText: 'Name'),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_bkashFocusNode);
                    },
                    onSaved: (value) {
                      name = value;
                    },
                  ),
                  TextFormField(
                    initialValue: bKashParam,
                    validator: (value) {
                      if (value.length != 11) {
                        return "Please provide 11 digit bKash number";
                      }
                      return null;
                    },
                    decoration: InputDecoration(labelText: 'bKash Number'),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    focusNode: _bkashFocusNode,
                    onSaved: (value) {
                      bkashPhoneNumber = value;
                    },
                    onFieldSubmitted: (_) {
                      FocusScope.of(context)
                          .requestFocus(_transactionIdFocusNode);
                    },
                  ),
                  TextFormField(
                    initialValue: transactionIdParam,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please provide transaction Id";
                      }
                      return null;
                    },
                    decoration: InputDecoration(labelText: 'Transaction Id'),
                    textInputAction: TextInputAction.done,
                    focusNode: _transactionIdFocusNode,
                    onSaved: (value) {
                      transactionId = value;
                    },
                    onEditingComplete: _saveFormForSet,
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              color: Colors.blue,
              onPressed: () {
                _saveFormForEdit();
              },
              child: Text(
                "Save",
                style: TextStyle(color: Colors.white),
              ),
            ),
            FlatButton(
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
    getThisUserInfo().then((value) {
      setState(() {
        userInfo = value[0];
        if (userInfo == null) {
          userInfo = {"name": "", "bkash": "", "transactionId": ""};
        }
        thisUserPhoneNUmber = value[1];
        _progressController = false;
      });
    });

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/transaction');
            },
          ),
        ],
      ),
      body: _progressController
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              children: <Widget>[
                Card(
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Your Name: ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17.0,
                              ),
                            ),
                            Text(userInfo['name']),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "BKASH Phone number: ",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17.0,
                                ),
                              ),
                              Text(userInfo['bkash']),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Transaction Id: ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17.0,
                              ),
                            ),
                            Text(userInfo['transactionId']),
                          ],
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            userInfo['transactionId'] == ""
                                ? RaisedButton(
                                    color: Colors.blue,
                                    onPressed: () {
                                      formWidgetForSet();
                                    },
                                    child: Text(
                                      "Set",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  )
                                : RaisedButton(
                                    color: Colors.blue,
                                    onPressed: () {
                                      formWidgetForEdit(
                                        userInfo['name'],
                                        userInfo['bkash'],
                                        userInfo['transactionId'],
                                      );
                                    },
                                    child: Text(
                                      "Edit",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                      child: Text("Rules", style: TextStyle(fontSize: 23))),
                ),
                Card(
                  child: ListTile(
                    leading: CircleAvatar(child: Text("#1")),
                    title: Text("At first you have to send 199 taka"),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: CircleAvatar(child: Text("#2")),
                    title: Text("At first you have to send 199 taka"),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: CircleAvatar(child: Text("#3")),
                    title: Text("At first you have to send 199 taka"),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Still Confusion??"),
                      SizedBox(width: 7),
                      RaisedButton(
                        onPressed: () {},
                        child: Text(
                          "See Video",
                        ),
                      ),
                    ])
              ],
            ),
    );
  }
}
