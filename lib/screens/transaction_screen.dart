import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/wid.dart';

class TransactionScreen extends StatefulWidget {
  static const routeName = '/transaction';

  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  var userInfo;
  bool _progressController = true;
  bool isSetText = true;
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
    return userInfoList;
  }

  void _saveFormForSet() {
    _form.currentState.validate();
    _form.currentState.save();

    print(name);
    print(bkashPhoneNumber);
    print(transactionId);
  }

  void formWidget() {
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
              onPressed: isSetText
                  ? () {
                      _saveFormForSet();
                    }
                  : null,
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

  @override
  void didChangeDependencies() {
    getThisUserInfo().then((value) {
      setState(() {
        userInfo = value;
        _progressController = false;
      });
    });

    // TODO: implement didChangeDependencies
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
                                      formWidget();
                                    },
                                    child: Text(
                                      "Set",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  )
                                : RaisedButton(
                                    color: Colors.blue,
                                    onPressed: () {
                                      formWidget();
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
                )
              ],
            ),
    );
  }
}

// class TransactionScreen extends StatefulWidget {
//   static const routeName = '/transaction';

//   @override
//   _TransactionScreenState createState() => _TransactionScreenState();
// }

// class _TransactionScreenState extends State<TransactionScreen> {
//   var UserInformation;
//   var UserPhoneNumber;
//   final databaseReference = FirebaseDatabase.instance.reference();
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   FirebaseUser firebaseUser;

//   Future<List> readChapersData() async {
//     var videolists;
//     var valueToBack = await databaseReference
//         .child("data")
//         .child("chapters")
//         .once()
//         .then((DataSnapshot snapshot) {
//       List<dynamic> extractedData = snapshot.value;
//       videolists = extractedData;
//       return videolists;

//       // allVideoList = extractedData;
//     });
//     return valueToBack;
//   }

//   Future<FirebaseUser> isAlreadyAuthenticated() async {
//     firebaseUser = await _auth.currentUser();
//     setState(() {
//       UserInformation = firebaseUser.phoneNumber;
//     });

//     print(firebaseUser.phoneNumber + "inside Is authenticated");
//     return firebaseUser;
//     // if (firebaseUser != null) {
//     //   return true;
//     // } else {
//     //   return false;
//     // }
//   }

//   @override
//   void didChangeDependencies() {
//     // printValue();
//     kk();
//     printValue();

//     super.didChangeDependencies();
//   }

//   void kk() async {
//     var p = await isAlreadyAuthenticated();
//   }

//   void printValue() {
//     print(this.UserPhoneNumber);
//     print("from printValue function");
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body:
//     );
//   }
// }
