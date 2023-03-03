import 'package:flutter/material.dart';
import 'package:posapp/provider/cart_provider.dart';
import 'package:posapp/screens/home.dart';
import 'package:posapp/screens/login_screen.dart';
import 'package:provider/provider.dart';
void main() {
  runApp(MyApp());
}

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class MyApp extends StatelessWidget {
  MaterialColor mycolor = MaterialColor(
    Color.fromRGBO(128, 0, 0, 1).value,
    <int, Color>{
      50: Color.fromRGBO(128, 0, 0, 0.1),
      100: Color.fromRGBO(128, 0, 0, 0.2),
      200: Color.fromRGBO(128, 0, 0, 0.3),
      300: Color.fromRGBO(128, 0, 0, 0.4),
      400: Color.fromRGBO(128, 0, 0, 0.5),
      500: Color.fromRGBO(128, 0, 0, 0.6),
      600: Color.fromRGBO(128, 0, 0, 0.7),
      700: Color.fromRGBO(128, 0, 0, 0.8),
      800: Color.fromRGBO(128, 0, 0, 0.9),
      900: Color.fromRGBO(128, 0, 0, 1),
    },
  );
  @override
  Widget build(BuildContext context) {
    return
    ChangeNotifierProvider(
      create: (_) => CartProvider(),
      child: Builder(builder: (context) {
        return MaterialApp(
            theme: ThemeData(
                primarySwatch: Colors.red,
                scaffoldBackgroundColor: Colors.white,
                primaryColor: Colors.white),
          home:  LoginPage(),
        );
      }),
    );
  }
}
