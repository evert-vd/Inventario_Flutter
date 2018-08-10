import 'package:flutter/material.dart';
import 'package:inventario/routes.dart';


void main() => runApp(new InventarioApp());

class InventarioApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Inventario App',
      /*theme: new ThemeData(
        primarySwatch: Colors.lightBlue,
        secondaryHeaderColor: Colors.white,
      ),*/
      routes: routes,
    );
  }
}


/*void main() {
  runApp(new MaterialApp(
    home: new SplashScreen(),
    routes: <String, WidgetBuilder>{
      '/HomeScreen': (BuildContext context) => new HomeScreen()
    },
  ));
}*/


