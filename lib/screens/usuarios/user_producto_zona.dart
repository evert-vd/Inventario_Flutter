import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:inventario/models/producto.dart';
import 'package:inventario/screens/usuarios/user_conteo_producto.dart';
import 'package:inventario/screens/usuarios/tabbar.dart';


class UserProductoZona extends StatefulWidget  {
// In the constructor, require a Todo

  @override
  InitScreenZonas createState() => new InitScreenZonas();
}


class InitScreenZonas extends State<UserProductoZona> {
  //List dataJson;
  int _id;


  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();


  Future<List<Producto>> loadProductosZona() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    //print("token"+token);
    int idzona = prefs.getInt("idzona");
    //print("idzona " + idzona.toString());
    String IPLHOST="10.0.2.2";
    String IPFIA="172.28.13.60";
    String IPMOLICOM="128.1.10.26";
    var jsonProductos = await http.get(
        Uri.encodeFull("http://$IPMOLICOM:2010/api/inventario/Producto/GetProductoZona?idzona=" + idzona.toString()),
        headers: {
          "Accept": "application/json",
          "Token": "$token"
        });
    final jsonResponse = json.decode(jsonProductos.body);
    ProductoList productoList = ProductoList.fromJson(jsonResponse);
    return productoList.producto;
  }





  @override
  void initState() {
    super.initState();
    this.loadProductosZona();
  }

  void cardClickSelection(int idzona) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("idzona", idzona);
  }

  @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          //backgroundColor: Colors.black54,
          title: Text("Productos en la Zona"),

        ),

          body: FutureBuilder<List<Producto>>(
          future: loadProductosZona(),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            return snapshot.hasData
                ? ProductoListCard(listProducto: snapshot.data)
                : Center(child: CircularProgressIndicator());
          },
        ),

      );
    }
  }

class ProductoListCard extends StatelessWidget {

  final List<Producto> listProducto;
  ProductoListCard({Key key, this.listProducto}) : super(key: key);


  Future<String> getConteoProducto(String idproducto) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    //print("token"+token);
    //print("idzona " + idzona.toString());
    String IPLHOST="10.0.2.2";
    String IPFIA="172.28.13.60";
    String IPMOLICOM="128.1.10.26";
    var jsonProductos = await http.get(
        Uri.encodeFull("http://$IPMOLICOM:2010/api/inventario/Conteo/GetTotalConteoProducto?idproducto=" + idproducto.toString()),
        headers: {
          "Accept": "application/json",
          "Token": "$token"
        });
    final jsonResponse = json.decode(jsonProductos.body);
    return jsonResponse.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(color: Colors.black12),
      child: ListView.builder(
          itemCount: listProducto.length,
          padding: const EdgeInsets.only(top: 5.0, left: 2.0, right: 2.0, bottom: 5.0),
          itemBuilder: (context, position) {
            return new GestureDetector(
                child: new Card(
                  color: Colors.white,
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.only(left: 10.0, top: 12.0, right: 10.0),
                        child: new Text("Código: " + listProducto[position].codigo.toString()),
                      ),
                      Container(
                          padding: const EdgeInsets.only(left: 10.0, top: 8.0,right: 10.0),
                          child: new Text(
                              listProducto[position].descripcion.toUpperCase())
                      ),

                      Container(
                          padding: const EdgeInsets.only(left: 10.0, top: 8.0,bottom: 12.0,right: 10.0),
                          child: new FutureBuilder(
                              future: getConteoProducto(listProducto[position].idproducto.toString()),
                              initialData: "0.0",
                              builder: (context, snapShot) {
                                final String total=snapShot.data;
                                if(total=="null" || total==null || total=='null'){
                                  return new Text("Conteo: 0.0");
                                }else{
                                  return new Text("Conteo: "+total.toString());
                                }

                              }
                          )
                      ),
                    ],
                  ),
                ),
                onTap:(){
                        itemClickProducto(listProducto[position].idproducto);//guarda el id de la zana
                        Navigator.of(context).push(new MaterialPageRoute(
                        builder: (context) => new UserConteoProducto()));
                        //builder: (context) => new AppBarBottomSample()));
                }   
            );   
          }),
    );
  }

  void itemClickProducto(int idproducto) async{
    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    sharedPreferences.setInt("idproducto",idproducto);
  }

}


