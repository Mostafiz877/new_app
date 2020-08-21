import 'package:flutter/material.dart';

class Wid extends StatefulWidget {
  @override
  _WidState createState() => _WidState();
}

class _WidState extends State<Wid> {
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

  void _saveForm() {
    print(name);
    print(bkashPhoneNumber);
    print(transactionId);
    _form.currentState.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _form,
        child: ListView(
          children: <Widget>[
            TextFormField(
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
              decoration: InputDecoration(labelText: 'bKash Number'),
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              focusNode: _bkashFocusNode,
              onSaved: (value) {
                bkashPhoneNumber = value;
              },
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_transactionIdFocusNode);
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Transaction Id'),
              textInputAction: TextInputAction.done,
              focusNode: _transactionIdFocusNode,
              onSaved: (value) {
                transactionId = value;
              },
              onFieldSubmitted: (_) {
                _saveForm();
              },
            ),
            FlatButton(
              onPressed: _saveForm,
              child: Text("Set"),
            )
          ],
        ),
      ),
    );
  }
}
