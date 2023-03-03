// ignore_for_file: unnecessary_const

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:posapp/database/sessionpreferences.dart';
import 'package:posapp/models/usermodels.dart';

import 'package:posapp/screens/home.dart';

import 'package:posapp/utils/config.dart' as Config;

class SideMenu extends StatefulWidget {
  @override
  _SideMenuState createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  @override
  initState() {
    SessionPreferences().getLoggedInStatus().then((loggedIn) {
      if (loggedIn == null) {
        setState(() {
          _loggedIn = false;
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(builder: (context) => LoginPage()),
          // );
          print("logged in is null");
        });
      } else {
        setState(() {
          _loggedIn = loggedIn;
          print("logged in not null");
        });
      }
      SessionPreferences().getLoggedInUser().then((user) {
        setState(() {
          _loggedInUser = user;
          _username = user.username;
          _memberno = user.memberno;
        });
      });
    });

    super.initState();
  }

  bool _loggedIn = false;
  late User _loggedInUser;
  String? _memberno;
  String? _username;
  BuildContext? _context;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Drawer(
          backgroundColor: Colors.white,
          child: Column(
            children: [
              DrawerHeader(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: const Icon(
                              Icons.person,
                              color: Colors.grey,
                              size: 100,
                            ),
                          ),
                          color: Theme.of(context).primaryColorDark),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(2, 1, 2, 1),
                      child: _username != null
                          ? Text('User Name : ' + _loggedInUser.username!,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16))
                          : const Text("user",
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16)),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(2, 1, 2, 1),
                      child: _memberno != null
                          ? Text('Member No : ' + _loggedInUser.memberno!,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16))
                          : const Text("Member No",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16)),
                    )
                  ],
                ),
                decoration:
                    BoxDecoration(color: Theme.of(context).primaryColorDark),
              ),
              ListTile(
                leading: const Icon(
                  Icons.home,
                  color: Colors.black,
                ),
                title: const Text('Home',
                    style: TextStyle(color: Colors.black, fontSize: 16)),
                onTap: () => {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Home(0,"",0)),
                  )
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.person,
                  color: Colors.black,
                ),
                title: const Text('Profile',
                    style: TextStyle(color: Colors.black, fontSize: 16)),
                onTap: () => {
                  // Navigator.pushReplacement(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => ProfilePage()),
                  // )
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.menu_open,
                  color: Colors.black,
                ),
                title: const Text('Menu',
                    style: TextStyle(color: Colors.black, fontSize: 16)),
                onTap: () => {
                  // Navigator.pushReplacement(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => CategoriesPage()),
                  // )
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.lock_open,
                  color: Colors.black,
                ),
                title: const Text('Change Password',
                    style: TextStyle(color: Colors.black, fontSize: 16)),
                onTap: () => {
                  // Navigator.pushReplacement(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => NewPass(Config.changePass)),
                  // ),
                },
              ),
              Expanded(
                child: Align(
                  alignment: FractionalOffset.center,
                  child: ListTile(
                    hoverColor: Colors.black,
                    dense: true,
                    visualDensity: const VisualDensity(vertical: -4),
                    leading: const Icon(
                      Icons.power_settings_new,
                      color: Colors.black,
                    ),
                    title: const Text('Logout',
                        style: TextStyle(color: Colors.black, fontSize: 16)),
                    onTap: () {
                      // Navigator.pushReplacement(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => LoginPage()),
                      // );
                      setState(() {
                        SessionPreferences().setLoggedInStatus(false);
                        _loggedIn = false;
                      });
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
