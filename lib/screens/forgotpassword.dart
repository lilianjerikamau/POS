import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:posapp/database/sessionpreferences.dart';
import 'package:posapp/screens/home.dart';
import 'package:posapp/screens/login_screen.dart';
import 'package:posapp/utils/config.dart' as Config;
import 'package:http/http.dart' as http;

class NewForgotPassword extends StatefulWidget {
  @override
  _NewForgotPasswordState createState() => _NewForgotPasswordState();
}

class _NewForgotPasswordState extends State<NewForgotPassword> {
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _userNameController = new TextEditingController();
  GlobalKey<FormState> _formKey = new GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reset Password"),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          },
        ),
        backgroundColor: Colors.red,
        elevation: 0.0,
      ),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                "Enter your username  in the inputs below to reset your password",
                style: TextStyle(color: Colors.teal, fontSize: 16),
              ),
            ),
            Container(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                        padding: EdgeInsets.all(10.0),
                        child: TextFormField(
                          controller: _userNameController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter your username';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              border:
                                  OutlineInputBorder(borderSide: BorderSide()),
                              labelText: 'Username'),
                        )),
                  ],
                ),
              ),
            ),
            Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _resetPassword();
                          }
                        },
                        child: Text(
                          'Reset Password',
                          style: TextStyle(fontSize: 16),
                        )),
                  ],
                ))
          ],
        ),
      ),
    );
  }

  _resetPassword() async {
    String username = _userNameController.text.trim();
    String url = await Config.getBaseUrl();

    final response = await http
        .get(Uri.parse(url + 'mobileuser/forgotPassword?username=$username'));
    if (response != null) {
      var jsonData = jsonDecode(response.body);
      print(jsonData.toString());
      var resp = response.statusCode;
      if (resp == 200) {
        _showDialog(context);
      } else {
        _showAlertDialog(context);
      }
    }
  }
}

_showAlertDialog(BuildContext context) {
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  AlertDialog alert = AlertDialog(
    title: Text(
      "Please! Try Again",
      style: TextStyle(color: Colors.red),
    ),
    content: Text("Reset password sent failed, please try again"),
    actions: [
      okButton,
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

_showDialog(BuildContext context) {
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.of(context).pop();
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => Home(0,"",0)));
    },
  );

  AlertDialog alert = AlertDialog(
    title: Text(
      "Success!",
      style: TextStyle(color: Colors.green),
    ),
    content: Text("Reset password has been successfully sent to your email"),
    actions: [
      okButton,
    ],
  );
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
