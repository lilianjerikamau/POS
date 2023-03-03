
import 'dart:convert';
import 'dart:io';
import 'dart:convert' as convert;

import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:query_params/query_params.dart';
import 'package:posapp/database/sessionpreferences.dart';
import 'package:posapp/models/usermodels.dart';
import 'package:posapp/screens/forgotpassword.dart';
import 'package:posapp/screens/home.dart';
import 'package:posapp/screens/selectcompany.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:posapp/utils/config.dart' as Config;
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<LoginPage> {
  var _companyDomainUrl;
  List departmentjson = [];
  var _selectedDepartment=null;
  var deptid=null;
  var form;
  // TextEditingController nameController = TextEditingController();
  // TextEditingController passwordController = TextEditingController();
  final _userNameInput = TextEditingController();
  final _passWordInput = TextEditingController();
  final _loginFormKey = GlobalKey<FormState>();
  late BuildContext _context;
  late User _loggedInUser;
  late bool _passwordVisible;
  late bool _companySettingsDone;
  late bool _loggedIn = false, _loggingIn = false, _showPass = true;
  late String? _imgFromSettings;
  late String _companyURL;
  final imageUrl = "/AnchorERP/erp/images/?file=companylogo.png&pfdrid_c=true";
  final imageHttp = "https://";

  @override
  Future? loadCompanyURL;
  void initState() {
    _fetchDepartments();
    _loadImageFromSettings();
    SessionPreferences().getCompanySettings().then((settings) {
      if (settings.baseUrl != null) {
        loadCompanyURL = _loadCompanyURL();

        setState(() {
          _companySettingsDone = true;
        });
      } else {
        setState(() {
          _companySettingsDone = false;
          Fluttertoast.showToast(msg: 'Set Company URL');
        });
      }
    });
    SessionPreferences().getLoggedInStatus().then((loggedIn) {
      if (loggedIn == null || loggedIn == false || deptid==null) {
        setState(() {
          _loggedIn = false;

          print("logged in is null");
        });
      } else {
        setState(() {
          _loggedIn = loggedIn;
          _loggedIn = true;
          Navigator.pushReplacement<void, void>(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) => Home(0,"",0),
              ));
          print("logged in not null");
        });
        if (loggedIn) {
          SessionPreferences().getLoggedInUser().then((user) {
            setState(() {
              _loggedInUser = user;
            });
          });
        }
      }
    });

    _companySettingsDone = false;
    _companyURL = "";
    _companyDomainUrl = "";
    _passwordVisible = false;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_companySettingsDone != null) {
      if (_companySettingsDone) {
        return Scaffold(
            backgroundColor: Colors.white,
            body: Container(
              color: Colors.white70,
              child: ListView(
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: FutureBuilder(
                          future: loadCompanyURL,
                          // ignore: non_constant_identifier_names
                          builder: (context, ImageUrl) {
                            if ((ImageUrl == null
                                    ? const Center(
                                        child: Text('Loading Logo image ... '))
                                    : CachedNetworkImage(
                                            imageUrl: imageHttp +
                                                _companyURL +
                                                imageUrl,
                                            height: 200,
                                            width: 200) !=
                                        null) ==
                                true) {
                              return Center(
                                  child: CachedNetworkImage(
                                imageUrl: imageHttp + _companyURL + imageUrl,
                                height: 200,
                                width: 200,
                              ));
                            }
                            return CachedNetworkImage(
                              imageUrl: imageHttp + _companyURL + imageUrl,
                              height: 180,
                              width: 180,
                            );
                          })),
                  const SizedBox(
                    height: 20,
                  ),
                  FractionallySizedBox(
                    widthFactor: 0.8,
                    child: Card(
                      elevation: 20,
                      child: Form(
                          key: _loginFormKey,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Login',
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .primaryColorDark)),
                              ),

                              Container(
                                padding: const EdgeInsets.all(10),
                                child: TextFormField(
                                  controller: _userNameInput,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'User Name',
                                    focusColor: Colors.redAccent,
                                  ),
                                  validator: (value) => value!.isEmpty
                                      ? "This field is required"
                                      : null,
                                ),
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                child: TextFormField(
                                  obscureText: !_passwordVisible,
                                  controller: _passWordInput,
                                  decoration: InputDecoration(
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _passwordVisible
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: Theme.of(context)
                                              .primaryColorDark,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _passwordVisible =
                                                !_passwordVisible;
                                          });
                                        },
                                      ),
                                      border: const OutlineInputBorder(),
                                      labelText: 'Password',
                                      focusColor: Colors.redAccent[900]),
                                  validator: (value) => value!.isEmpty
                                      ? "This field is required"
                                      : null,
                                ),
                              ), Container(
                                padding: const EdgeInsets.all(10),
                                child:
                                DropdownButtonFormField(
                                  validator: (value) => value == null ? 'This field is required' : null,
                                  hint: Text('Select Department'),
                                  items: departmentjson.map((val) {
                                    return DropdownMenuItem(
                                      value: val,
                                      child: Text(val['name']),
                                    );
                                  }).toList(),
                                  onChanged: (newValue) {
                                    setState(() {
                                      _selectedDepartment = newValue;
                                      deptid = _selectedDepartment['id'];
                                    });
                                  },
                                  // value: items,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                                    border: OutlineInputBorder(),
                                    // filled: true,
                                    // fillColor: Colors.grey[200],
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctx) => NewForgotPassword()),
                                  );
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.redAccent[900],
                                ),
                                child: const Text('Forgot Password'),
                              ),
                              Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: CupertinoButton(
                                    color: Theme.of(context).primaryColorDark,
                                    child: _loggingIn
                                        ? Container(
                                            child:
                                                const CircularProgressIndicator(
                                                    backgroundColor:
                                                        Colors.white),
                                            height: 20,
                                            width: 20)
                                        : const Text('Login'),
                                    onPressed: () async {
                                      print(_userNameInput.text);
                                      print(_passWordInput.text);
                                      SessionPreferences()
                                          .getCompanySettings()
                                          .then((settings) {
                                        if (settings.baseUrl == null) {
                                          Fluttertoast.showToast(
                                              msg: 'Set Company URL');
                                          setState(() {
                                            _loggingIn = false;
                                          });
                                        }
                                      });
                                      if (_loginFormKey.currentState!
                                          .validate()) {
                                        setState(() {
                                          _loggingIn = true;
                                        });
                                        String username =
                                            _userNameInput.text.trim();
                                        String password =
                                            _passWordInput.text.trim();
                                        var bytes = utf8.encode(password);
                                        String encodedPassword =
                                            base64.encode(bytes);

                                        HttpClient httpClient = HttpClient();
                                        httpClient.badCertificateCallback =
                                            (X509Certificate cert, String host,
                                                    int port) =>
                                                true;
                                        URLQueryParams urqp = URLQueryParams();
                                        urqp.append('username', username);
                                        urqp.append(
                                            'password', encodedPassword);
                                        String url = await Config.getBaseUrl();
                                        Uri uri = Uri.parse(url +
                                            'mobileuser/login?' +
                                            urqp.toString());

                                        print(uri);
                                        var response = await http.get(uri);
                                        // var jsonResponse =
                                        //     convert.jsonDecode(response.body)
                                        //         as Map<String, dynamic>;
                                        var body = response.body;
                                        // HttpClientRequest request =
                                        //     await httpClient.getUrl(uri);
                                        // late HttpClientResponse response;
                                        // String result;
                                        // try {
                                        //   response = await request.close();
                                        // } on SocketException {
                                        //   Fluttertoast.showToast(
                                        //       msg:
                                        //           'You may be offline. Check your connection');
                                        // } on HandshakeException {
                                        //   Fluttertoast.showToast(
                                        //       msg:
                                        //           'Handshake exception occured');
                                        // }
                                        if (response != null) {
                                          // print(response.reasonPhrase);
                                          setState(() {
                                            _loggingIn = false;
                                          });
                                          int statusCode = response.statusCode;

                                          if (statusCode == 200) {
                                            // response
                                            //     .transform(utf8.decoder)
                                            //     .listen((data) {
                                            print("Login response:::" +
                                                response.toString());
                                            // print(data);

                                            User user = User.fromJson(
                                                json.decode(response.body));
                                            print(user.id);
                                            if (user.id! > 0) {
                                              // if (user.hrid! > 0) {
                                              setState(() {
                                                _loggedIn = true;
                                                _loggedInUser = user;
                                              });
                                              print(user.hrid!);

                                              SessionPreferences()
                                                  .setLoggedInUser(user);
                                              SessionPreferences()
                                                  .setLoggedInStatus(true);

                                              setState(() {
                                                _loggedIn = true;
                                                _loggedInUser = user;
                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Home(0,"",deptid)),
                                                );
                                              });
                                              Fluttertoast.showToast(
                                                  msg: 'Welcome $username');
                                              // } else {
                                              //   showDialog(
                                              //       context: context,
                                              //       builder:
                                              //           (BuildContext bc) {
                                              //         return CupertinoAlertDialog(
                                              //           title: const Text(
                                              //               'Account Action Needed'),
                                              //           content: const Text(
                                              //               'Your user account is not attached to any Hr_Employee account. Please contact the administrator with this information'),
                                              //           actions: <Widget>[
                                              //             TextButton(
                                              //                 onPressed: () {
                                              //                   Navigator.pop(
                                              //                       bc);
                                              //                 },
                                              //                 child:
                                              //                     const Text(
                                              //                         'Ok'))
                                              //           ],
                                              //         );
                                              //       });
                                              // }
                                            } else if (user.id! < 0) {
                                              Fluttertoast.showToast(
                                                  msg:
                                                      'The password you entered is incorrect',
                                                  toastLength:
                                                      Toast.LENGTH_LONG);
                                            } else {
                                              Fluttertoast.showToast(
                                                  msg:
                                                      'Please check your username and password',
                                                  toastLength:
                                                      Toast.LENGTH_LONG);
                                            }
                                            // });
                                          } else {
                                            Fluttertoast.showToast(
                                                msg: '$body ');
                                          }
                                        } else {
                                          setState(() {
                                            _loggingIn = false;
                                          });
                                          Fluttertoast.showToast(
                                              msg:
                                                  'No response from the server');
                                        }
                                      }
                                    },
                                  )),
                              Row(
                                children: <Widget>[
                                  const Text('Change company URL?'),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.redAccent[900],
                                    ),
                                    child: const Text(
                                      'Company URL',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    onPressed: () async {
                                      setState(() {
                                        _companySettingsDone = false;
                                      });
                                    },
                                  )
                                ],
                                mainAxisAlignment: MainAxisAlignment.center,
                              )
                            ],
                          )),
                    ),
                  )
                ],
              ),
            ));
      } else {
        return ChooseCompany((imgName) {
          setState(() {
            _loadImageFromSettings();
            _imgFromSettings = imgName;
            _companySettingsDone = true;
          });
        });
      }
    } else {
      return Scaffold(
        appBar: AppBar(title: const Text('Load Company Settings')),
        body: const Center(
          child: const Text('Loading your settings. Please wait ... '),
        ),
      );
    }
  }

  imgName(String p1) {
    _imgFromSettings = imgName as String;
  }

  void _loadImageFromSettings() async {
    CompanySettings settings = await SessionPreferences().getCompanySettings();
    setState(() {
      _imgFromSettings = settings.imageName;
    });
  }

  _loadCompanyURL() async {
    CompanySettings settings = await SessionPreferences().getCompanySettings();
    _loadImageFromSettings();
    // setState(() {
    // print('Im here');
    _companyDomainUrl = settings.baseUrl;
    // });
    var urlDomain = _companyDomainUrl;
    var uri = Uri.parse(urlDomain);
    _companyURL = uri.host;
    print(_companyDomainUrl);
    print(_companyURL);
  }
  _fetchDepartments() async {
    String url = await Config.getBaseUrl();

    final stringurl = (url +
        'mobileuser/department/');


    HttpClientResponse response = await Config.getRequestObject(
      stringurl,
      Config.get,
    ).timeout(Duration(minutes: 10));
    if (response != null) {
      print(stringurl);
      print(response.compressionState);
      response
          .take(5)
          .transform(utf8.decoder)
          .transform(LineSplitter())
          .listen((data) {
        print(response.take(5));
        var jsonResponse = jsonDecode(data);
        print(jsonResponse);
        setState(() {
          departmentjson = jsonResponse;
          // instructionsString = instructionsJson.join(",");
          // saveAssessmentInstructions();
        });

      });
    } else {
      print('response is null ');
    }
  }
}
