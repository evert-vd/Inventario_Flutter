import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:inventario/models/usuario.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart' as http;

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startTime() async {
    var _duration = new Duration(seconds: 2);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    int idusuario = prefs.getInt("idusuario");
    print("token: $token");
    print("IdUser: $idusuario");
    //print("idequipo"+usuario.idequipo.toString());
    String IPLHOST = "10.0.2.2";
    String IPFIA = "172.28.13.60";
    String IPMOLICOM = "128.1.10.26";
    var jsonToken = await http.get(
        Uri.encodeFull(
            "http://$IPMOLICOM:2010/api/inventario/Token/ValidarToken?nombre=" +
                token.toString() +
                "&idusuario=" +
                idusuario.toString()),
        headers: {
          "Accept": "application/json",
          //"Token": "$token"
        });
    print("Rsp TOKEN: " + jsonToken.body.toString());
    if (jsonToken.statusCode < 200 ||
        jsonToken.statusCode > 400 ||
        jsonToken.body == null) {
      openPage(-1);
      Navigator.of(context).pushReplacementNamed('/login_screen');
      throw new Exception(
          "Error en la obtencion de datos. Verifica tu conexión a internet");
    }


    print("Rsp TOKEN: " + jsonToken.body.toString());
    var jsonResponse = json.decode(jsonToken.body);
    var respuesta=jsonResponse['error'];
    //String respuesta=jsonToken.body['error'].toString();
    openPage(respuesta);

  }

  void openPage(int respuesta){
    switch (respuesta){
      case -1:
        Navigator.of(context).pushReplacementNamed('/login_screen');
        break;
      case 1:
        Navigator.of(context).pushReplacementNamed('/user_zona');
        break;
      default:
        Navigator.of(context).pushReplacementNamed('/login_screen');
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Container(
        decoration: new BoxDecoration(
          image: new DecorationImage(
              image: new AssetImage("assets/login.png"), fit: BoxFit.cover),
        ),
        child: new Center(
          //child: new ClipRect(
          //child: new BackdropFilter(
          //filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(),
              Container(
                padding: EdgeInsets.only(top: 25.0),
                child: Text("Cargando..."),
              )
            ],
          ),

          //child: loginForm,
          //height: 300.0,
          //width: 300.0,
          //decoration: new BoxDecoration(
          //color: Colors.grey.shade200.withOpacity(0.5)),
          //),
          // ),
          //),
        ),
      ),
    );
  }
}
