import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:inventario/auth.dart';
import 'package:inventario/data/database_helper.dart';
import 'package:inventario/models/respuesta.dart';
import 'package:inventario/models/usuario.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:inventario/models/usuario.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen> {
  BuildContext _ctx;

  bool _isLoading = false;
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  String _password, _username, token;
  Usuario usuario;

  static String IPLHOST = "10.0.2.2";
  static String IPFIA = "172.28.13.60";
  static String IPMOLICOM = "128.1.10.26";
  static final BASE_URL = "http://$IPMOLICOM:2010/api/inventario"; //fia
  //static final BASE_URL = "http://128.1.10.26:5800/api/inventario";
  static final LOGIN_URL = BASE_URL + "/Login/Login?";

  Future<bool> login(String nombre, String password) async {
    final response = await http.post(
        LOGIN_URL + "username=" + nombre + "&password=" + password,
        headers: {"Accept": "application/json"});

    //if (response.statusCode == 200) {
    if (response.statusCode < 200 ||
        response.statusCode > 400 ||
        response.body == null) {
      //print("Loginerror:" + response.body);
      onLoginError("Error. Verifica tu conexión a Internet");
      throw new Exception("Error en la obtencion de datos. Verifica tu conexión a internet");
    }
    //String res= _decoder.convert(response.body);
    //String token=response.headers["token"];
    //String idequipo=response.headers["idequipo"];
    print("Login:" + response.body);
    var jsonResponse = json.decode(response.body);

    if (jsonResponse['error'] == -1) {
      onLoginError(jsonResponse['mensaje'].toString());
      return false;
    } else {
      Respuesta respuesta = new Respuesta.fromJson(jsonResponse);
      //print("RespuestaUser: "+respuesta.data.toString() );
      usuario = respuesta.data;
      print("Password:" + usuario.password);
      onLoginSuccess(jsonResponse['mensaje'].toString(), usuario);
      return true;
    }
  }

  void _submit() {
    final form = formKey.currentState;
    if (form.validate()) {
      setState(() => _isLoading = true);
      form.save();
      login(_username, _password);
      /*.then((Usuario user) {
        onLoginSuccess(user);
      }).catchError((Exception error) => onLoginError(error.toString()));*/
    }
  }

  /*doLogin(String username, String password) {
    login(username, password).then((Usuario user) {
      onLoginSuccess(user);
    }).catchError((Exception error) =>onLoginError(error.toString()));
  }*/

  void _showSnackBar(String text) {
    scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
  }

  /*onAuthStateChanged(AuthState state) {
    if (state == AuthState.LOGGED_IN) {
      Navigator.of(_ctx).pushReplacementNamed("/user_zona");
      //Navigator.of(_ctx).popAndPushNamed("/admin_home");
    }
  }*/

  @override
  Widget build(BuildContext context) {
    _ctx = context;
    var loginBtn = new RaisedButton(
      onPressed: _submit,
      child: new Text("Iniciar Sesión"),
      color: Theme.of(context).primaryColor,
    );
    var loginForm = new Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: new Text(
            "Inventario",
            textScaleFactor: 2.0,
          ),
        ),
        new Form(
          key: formKey,
          child: new Column(
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.only(
                    top: 8.0, left: 15.0, right: 15.0, bottom: 8.0),
                child: new TextFormField(
                  onSaved: (val) => _username = val,
                  validator: (val) {
                    return val.length <= 0 ? "Ingresar el usuario" : null;
                  },
                  decoration: new InputDecoration(labelText: "Usuario Molicom"),
                ),
              ),
              new Padding(
                padding:
                    const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 8.0),
                child: new TextFormField(
                  onSaved: (val) => _password = val,
                  validator: (val) {
                    return val.length <= 0 ? "Ingresar la contraseña" : null;
                  },
                  decoration: new InputDecoration(labelText: "Contraseña"),
                ),
              ),
            ],
          ),
        ),
        Container(
            //margin: EdgeInsets.only(top: 30.0),
            padding: const EdgeInsets.only(top: 25.0),
            child: _isLoading ? new CircularProgressIndicator() : loginBtn),
      ],
      crossAxisAlignment: CrossAxisAlignment.center,
    );

    return new Scaffold(
      appBar: null,
      key: scaffoldKey,
      body: new Container(
        decoration: new BoxDecoration(
          image: new DecorationImage(
              image: new AssetImage("assets/login.png"), fit: BoxFit.cover),
        ),
        child: new Center(
          child: new ClipRect(
            child: new BackdropFilter(
              filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: new Container(
                child: loginForm,
                height: 300.0,
                width: 300.0,
                decoration: new BoxDecoration(
                    color: Colors.grey.shade200.withOpacity(0.5)),
              ),
            ),
          ),
        ),
      ),
    );
  }

  //@override
  void onLoginError(String errorTxt) {
    _showSnackBar(errorTxt);
    setState(() => _isLoading = false);
  }

  //@override
  void onLoginSuccess(String mensaje, Usuario user) async {
    _showSnackBar(mensaje);
    setState(() => _isLoading = false);
    //var db = new DatabaseHelper();
    //await db.saveNote(user);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', user.password);
    await prefs.setInt('idusuario', user.idusuario);
    await prefs.setInt('idequipo', user.idequipo);
    prefs.commit();
    print("Token Shared" + prefs.getString("token"));
    //var authStateProvider = new AuthStateProvider();
    //authStateProvider.notify(AuthState.LOGGED_IN);

    await Navigator.of(_ctx).pushReplacementNamed("/user_zona");
  }
}
