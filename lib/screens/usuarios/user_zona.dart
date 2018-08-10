import 'package:flutter/material.dart';
import 'package:inventario/data/database_helper.dart';
import 'package:inventario/models/usuario.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:inventario/models/zona.dart';
import 'package:inventario/screens/usuarios/user_producto_zona.dart';
import 'package:inventario/screens/home/steep.dart';

class UserZonas extends StatefulWidget {
// In the constructor, require a Todo
  @override
  InitScreenZonas createState() => new InitScreenZonas();
}

class InitScreenZonas extends State<UserZonas> {
  //List dataJson;
  int _id;
  Usuario usuario = null;
  int totalProductos = 0;
  Choice _selectedChoice = choices[0];
  int positionMenu = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Future<List<Zona>> loadZonasEquipo() async {
    var db = new DatabaseHelper();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //usuario=await db.getUsuario(prefs.getString("token"));
    String token = prefs.get("token");
    int idequipo = prefs.get("idequipo");

    //print("idequipo"+usuario.idequipo.toString());
    String IPLHOST = "10.0.2.2";
    String IPFIA = "172.28.13.60";
    String IPMOLICOM = "128.1.10.26";
    var jsonZonas = await http.get(
        Uri.encodeFull(
            "http://$IPMOLICOM:2010/api/inventario/Zona/GetZonaEquipo?idequipo=" +
                idequipo.toString()),
        headers: {"Accept": "application/json", "Token": "$token"});

    final jsonResponse = json.decode(jsonZonas.body);
    ZonaList zonaList = ZonaList.fromJson(jsonResponse);
    return zonaList.zonas;
  }

  @override
  void initState() {
    super.initState();
    this.loadZonasEquipo();
  }

  void cardClickSelection(int idzona) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("idzona", idzona);
  }

  void _select(Choice choice) {
    // Causes the app to rebuild with the new _selectedChoice.
    positionMenu=choice.position;
    switch(positionMenu){
      case 0:
        print("actualizar");
        break;
      case 1:
        print("Cerrar Inventario");
        Navigator.of(context).push(new MaterialPageRoute(
            builder: (context) => new MyStep()));

        break;
      case 2:
        print("Agregar producto");
        break;
      case 3:
        print("Cerrar Sesión");
        closeSession();
        break;
      default:
        print("actualizar2");
        break;
    }

    setState(() {
      _selectedChoice = choice;
      positionMenu=choice.position;
      print("choice: "+choice.title);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          //backgroundColor: Colors.black54,
          title: Text("Zonas asignadas"),
          actions: <Widget>[
            IconButton(
              icon: Icon(choices[0].icon),
              onPressed: () {
                _select(choices[0]);
              },
            ),
            // overflow menu
            PopupMenuButton<Choice>(
              onSelected: _select,
              itemBuilder: (BuildContext context) {
                return choices.skip(1).map((Choice choice) {
                  return PopupMenuItem<Choice>(
                    value: choice,
                    child: Text(choice.title),
                  );
                }).toList();
              },
            ),

          ],
        ),
        body: FutureBuilder<List<Zona>>(
          future: loadZonasEquipo(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print(snapshot.error);
            }
            return snapshot.hasData
                ? ProductoListCard(listaZonas: snapshot.data)
                : Center(child: CircularProgressIndicator());
          },
        ));
  }

  void closeSession()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //usuario=await db.getUsuario(prefs.getString("token"));
    await prefs.setString('token', null);
    await prefs.setInt('idusuario', null);
    Navigator.of(context).pushReplacementNamed('/login_screen');
  }

  void itemClickZona(int idzona) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setInt("idzona", idzona);
  }

  Future<String> totalProductosZona(String idzona) async {
    var db = new DatabaseHelper();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Usuario usuario = await db.getUsuario(prefs.getString("token"));
    String token = usuario.password;
    print("idequipo" + usuario.idequipo.toString());
    //10.0.2.2:2010
    String IPLHOST = "10.0.2.2";
    String IPFIA = "172.28.13.60";
    String IPMOLICOM = "128.1.10.26";
    var jsonZonas = await http.get(
        Uri.encodeFull(
            "http://$IPMOLICOM:2010/api/inventario/Producto/GetTotalProductosZona?idzona=" +
                idzona.toString()),
        headers: {"Accept": "application/json", "Token": "$token"});
    final jsonResponse = json.decode(jsonZonas.body);
    print("Zonas EQ: $jsonZonas");
    return jsonResponse.toString();
  }
}

class ProductoListCard extends StatelessWidget {
  final List<Zona> listaZonas;

  ProductoListCard({Key key, this.listaZonas}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(color: Colors.black12),
      child: ListView.builder(
          itemCount: listaZonas.length,
          padding: const EdgeInsets.only(top: 3.0),
          itemBuilder: (context, position) {
            return new GestureDetector(
                child: new Card(
                  color: Colors.white,
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.only(left: 8.0, top: 12.0),
                        child: new Text(
                            "Zona: " + listaZonas[position].descripcion),
                      ),
                      Container(
                          padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                          child: new FutureBuilder(
                              future: totalProductosZona(
                                  listaZonas[position].idzona.toString()),
                              initialData: "0",
                              builder: (context, snapShot) {
                                final String total = snapShot.data;
                                //return snapShot.hasData? new Text("Total Productos: "+snapShot.data.toString()): new CircularProgressIndicator();
                                return new Text(
                                    "Total Productos: " + total.toString());
                              })),
                      Container(
                          padding: const EdgeInsets.only(
                              left: 8.0, top: 8.0, bottom: 12.0),
                          child: new FutureBuilder(
                              future: totalConteoZona(
                                  listaZonas[position].idzona.toString()),
                              initialData: "0.0",
                              builder: (context, snapShot) {
                                final String total = snapShot.data;
                                if (total == "null" ||
                                    total == null ||
                                    total == 'null') {
                                  return new Text("Total Inventario: 0.0");
                                } else {
                                  return new Text(
                                      "Total Inventario: " + total.toString());
                                }
                              })),
                    ],
                  ),
                ),
                onTap: () {
                  itemClickZona(
                      listaZonas[position].idzona); //guarda el id de la zana
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (context) => new UserProductoZona()));
                });
          }),
    );
  }

  void itemClickZona(int idzona) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setInt("idzona", idzona);
  }

  Future<String> totalProductosZona(String idzona) async {
    var db = new DatabaseHelper();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Usuario usuario = await db.getUsuario(prefs.getString("token"));
    String token = usuario.password;
    //print("idequipo"+usuario.idequipo.toString());
    String IPLHOST = "10.0.2.2";
    String IPFIA = "172.28.13.60";
    String IPMOLICOM = "128.1.10.26";
    var jsonZonas = await http.get(
        Uri.encodeFull(
            "http://$IPMOLICOM:2010/api/inventario/Producto/GetTotalProductosZona?idzona=" +
                idzona.toString()),
        headers: {"Accept": "application/json", "Token": "$token"});

    final jsonResponse = json.decode(jsonZonas.body);
    //print("Total producto Zona "+ idzona+":"+jsonResponse.toString());
    return jsonResponse.toString();
  }

  Future<String> totalConteoZona(String idzona) async {
    var db = new DatabaseHelper();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Usuario usuario = await db.getUsuario(prefs.getString("token"));
    String token = usuario.password;
    //print("idequipo"+usuario.idequipo.toString());
    String IPLHOST = "10.0.2.2";
    String IPFIA = "172.28.13.60";
    String IPMOLICOM = "128.1.10.26";
    var jsonZonas = await http.get(
        Uri.encodeFull(
            "http://$IPMOLICOM:2010/api/inventario/Conteo/GetTotalConteoZona?idzona=" +
                idzona.toString()),
        headers: {"Accept": "application/json", "Token": "$token"});
    final jsonResponse = json.decode(jsonZonas.body);
    print("total" + jsonResponse.toString());

    // if (jsonZonas.statusCode < 200 || jsonZonas.statusCode > 400 || jsonResponse.body == null){
    //return "0";
    //}else{
    return jsonResponse.toString();
    //}
    //print("Total conteo Zona "+ idzona+":"+jsonResponse.toString());
  }
}


class Choice {
  const Choice({this.position,this.title, this.icon});
  final int position;
  final String title;
  final IconData icon;
}
const List<Choice> choices = const <Choice>[
  const Choice(position:0,title: 'Actualizar', icon: Icons.refresh),
  const Choice(position:1,title: 'Cerrar Inventario', icon: Icons.home),
  const Choice(position:2,title: 'Agregar Producto', icon: Icons.add_circle),
  const Choice(position:3,title: 'Cerrar Sesión', icon: Icons.exit_to_app),
];
