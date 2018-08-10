import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:inventario/screens/usuarios/user_calculadora_conteo.dart';
import 'package:inventario/models/conteo.dart';
import 'package:inventario/models/producto.dart';
import 'swipe_widget.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:inventario/screens/usuarios/calculator.dart';

class UserConteoProducto extends StatefulWidget {
  // In the constructor, require a Todo

  @override
  InitScreenConteoProducto createState() => new InitScreenConteoProducto();
}

class InitScreenConteoProducto extends State<UserConteoProducto> {
  final GlobalKey<ScaffoldState> scaffoldStatte =
      new GlobalKey<ScaffoldState>();

  List<Conteo> listConteo;

  //Producto producto=new Producto();
  Future<List<Conteo>> loadConteosProducto() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    print("token" + token);
    int idproducto = prefs.getInt("idproducto");
    //print("idproducto " + idproducto.toString());
    String IPFIA = "172.28.13.60";
    String IPMOLICOM = "128.1.10.26";
    String IPLHOST = "10.0.2.2";
    var jsonProductos = await http.get(
        Uri.encodeFull(
            "http://$IPMOLICOM:2010/api/inventario/Conteo/GetConteoProducto?idproducto=" +
                idproducto.toString()),
        headers: {"Accept": "application/json", "Token": "$token"});
    final jsonResponse = json.decode(jsonProductos.body);
    ConteoList productoList = ConteoList.fromJson(jsonResponse);
    listConteo = productoList.conteos;
    return listConteo;
  }

  eliminarConteo(int idconteo) async {
    print("Id Conteo: " + idconteo.toString());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    String IPLHOST = "10.0.2.2";
    String IPFIA = "172.28.13.60";
    String IPMOLICOM = "128.1.10.26";
    //print("token"+token);
    //int idproducto = prefs.getInt("idproducto");
    //print("idproducto " + idproducto.toString());
    var jsonProductos = await http.delete(
        Uri.encodeFull(
            "http://$IPMOLICOM:2010/api/inventario/Conteo/DeleteConteo/" +
                idconteo.toString()),
        headers: {"Accept": "application/json", "Token": "$token"});
    final jsonResponse = json.decode(jsonProductos.body);
    return true;
  }

  Future<String> getConteoProducto() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    int idproducto = prefs.getInt("idproducto");
    //print("token"+token);
    //print("idzona " + idzona.toString());
    String IPLHOST = "10.0.2.2";
    String IPFIA = "172.28.13.60";
    String IPMOLICOM = "128.1.10.26";
    var jsonProductos = await http.get(
        Uri.encodeFull(
            "http://$IPMOLICOM:2010/api/inventario/Conteo/GetTotalConteoProducto?idproducto=" +
                idproducto.toString()),
        headers: {"Accept": "application/json", "Token": "$token"});
    final jsonResponse = json.decode(jsonProductos.body);
    return jsonResponse.toString();
  }

  Future<Producto> getProducto() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    int idproducto = prefs.getInt("idproducto");
    //print("token"+token);
    //print("idzona " + idzona.toString());
    String IPLHOST = "10.0.2.2";
    String IPFIA = "172.28.13.60";
    String IPMOLICOM = "128.1.10.26";
    var jsonProductos = await http.get(
        Uri.encodeFull(
            "http://$IPMOLICOM:2010/api/inventario/Producto/GetProducto/" +
                idproducto.toString()),
        headers: {"Accept": "application/json", "Token": "$token"});
    final jsonResponse = json.decode(jsonProductos.body);
    Producto producto = Producto.fromJson(jsonResponse);
    print("Producto1: " + jsonResponse['stock'].toString());
    print("Producto2: " + jsonResponse.toString());
    //print("Producto: "+producto.descripcion);
    return producto;
  }

  @override
  void initState() {
    super.initState();
    this.loadConteosProducto();
    this.getConteoProducto();
    this.getProducto();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //key: scaffoldStatte,
        appBar: AppBar(
          //backgroundColor: Colors.black54,
          title: Text("Conteos del Producto"),
          elevation: 0.0,
          actions: <Widget>[
            // action button
            IconButton(
              icon: Icon(Icons.camera_alt),
              onPressed: () {},
            ),
          ],

          /* bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                    height: 60.0,
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.only(left: 20.0, top: 5.0),
                    child: new FutureBuilder(
                        future: getConteoProducto(),
                        initialData: "0",
                        builder: (context, snapShot) {
                          final String total = snapShot.data;
                          //return snapShot.hasData? new Text("Total Productos: "+snapShot.data.toString()): new CircularProgressIndicator();
                          return new Text("Total Conteo: " + total.toString(),
                              style: new TextStyle(
                                  fontSize: 15.0, color: Colors.white));
                        })),
                Container(
                    height: 40.0,
                    alignment: Alignment.bottomLeft,
                    padding: const EdgeInsets.only(left: 20.0, top: 5.0, bottom: 30.0),
                    child: new FutureBuilder(
                        future: getConteoProducto(),
                        initialData: "0",
                        builder: (context, snapShot) {
                          final String total = snapShot.data;
                          //return snapShot.hasData? new Text("Total Productos: "+snapShot.data.toString()): new CircularProgressIndicator();
                          return new Text("Total Conteo: " + total.toString(),
                              style: new TextStyle(
                                  fontSize: 15.0, color: Colors.white));
                        })),
              ],
            ),
          ),*/
        ),
        body: new Container(
            child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                //mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
              Container(
                alignment: Alignment.topLeft,
                color: Theme.of(context).primaryColor,
                padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                  child: new FutureBuilder(
                      future: getProducto(),
                      initialData: new Producto(),
                      //getproduto devuelve un objeto
                      builder: (context, snapShot) {
                        Producto producto = snapShot.data;
                        String codigo = producto.codigo.toString();
                        //return snapShot.hasData? new Text("Total Productos: "+snapShot.data.toString()): new CircularProgressIndicator();
                        return new Text(
                          "Código: $codigo",
                          style:
                          new TextStyle(fontSize: 15.0, color: Colors.white),
                        );
                      }),
              ),
              Container(
                alignment: Alignment.topLeft,
                color: Theme.of(context).primaryColor,
                padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                child: new FutureBuilder(
                    future: getProducto(),
                    initialData: new Producto(),
                    builder: (context, snapShot) {
                      Producto producto = snapShot.data;
                      String descripcion = producto.descripcion.toString();
                     return new Text(
                        descripcion.toUpperCase(),
                        style:
                            new TextStyle(fontSize: 15.0, color: Colors.white),
                      );
                    }),
              ),
              Container(
                  alignment: Alignment.topLeft,
                  color: Theme.of(context).primaryColor,
                  padding:
                      const EdgeInsets.only(left: 8.0, top: 8.0, bottom: 10.0),
                  child: new FutureBuilder(
                      future: getConteoProducto(),
                      initialData: "0",
                      builder: (context, snapShot) {
                        final String total = snapShot.data;
                        //return snapShot.hasData? new Text("Total Productos: "+snapShot.data.toString()): new CircularProgressIndicator();
                        return new Text(
                          "Total Unidades: " + total.toString(),
                          style: new TextStyle(
                              fontSize: 15.0, color: Colors.white),
                        );
                      })),
              new Expanded(
                child: FutureBuilder<List<Conteo>>(
                  future: loadConteosProducto(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) print(snapshot.error);
                    if (snapshot.hasData) {
                      return Container(
                        //decoration: new BoxDecoration(color: Colors.black12),
                        child: ListView.builder(
                          itemCount: listConteo.length,
                          //padding: const EdgeInsets.all(8.0),
                          itemBuilder: (BuildContext context, int index) {
                            //this.context=context;
                            return new OnSlide(
                                items: <ActionItems>[
                                  new ActionItems(
                                      icon: new IconButton(
                                        icon: new Icon(Icons.delete),
                                        onPressed: () {},
                                        color: Colors.red,
                                      ),
                                      onPress: () {
                                        dialogEliminar(
                                            listConteo[index]
                                                .cantidad
                                                .toString(),
                                            index);
                                      },
                                      backgroudColor: Colors.white),
                                  new ActionItems(
                                      icon: new IconButton(
                                        icon: new Icon(Icons.edit),
                                        onPressed: () {},
                                        color: Colors.green,
                                      ),
                                      onPress: () {},
                                      backgroudColor: Colors.white),
                                ],
                                child: new Column(
                                  //crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    new ListTile(
                                      title: new Text("Cantidad: " +
                                          listConteo[index]
                                              .cantidad
                                              .toString()),
                                      subtitle: Text("Fec. Registro: " +
                                          listConteo[index]
                                              .fregistro
                                              .toString()),
                                    ),
                                    new Divider(color: Colors.black54),
                                  ],
                                ));
                          },
                          //itemCount: 10,
                        ),
                      );
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            ])),
        floatingActionButton: FloatingActionButton(
          tooltip: 'Conteo', // used by assistive technologies
          child: Icon(Icons.album),
          backgroundColor: Colors.black,
          onPressed: () {
            Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) => new CalculadoraConteo()));
            //builder: (context) => new UserCalculadoraConteoProductoZona ()));
          },
        ));
  }

  void dialogEliminar(String cantidad, int position){
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Eliminar"),
          content: new Text(
              "¿Eliminar el Conteo $cantidad" + " pos: " + position.toString()),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Eliminar"),
              onPressed: (){
                 eliminarConteo(listConteo[position].idconteo);
                setState(() {
                  listConteo.removeAt(position);
                });
                //listConteo.removeAt(position);
                //scaffoldStatte.currentState.showSnackBar(new SnackBar(content: new Text("Cantidad eliminada")));
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class ProductoListTile extends StatelessWidget {
  BuildContext context;
  final List<Conteo> listConteo;

  ProductoListTile({Key key, this.listConteo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      //decoration: new BoxDecoration(color: Colors.black12),
      child: ListView.builder(
        itemCount: listConteo.length,
        //padding: const EdgeInsets.all(8.0),
        itemBuilder: (BuildContext context, int index) {
          this.context = context;
          return new OnSlide(
              items: <ActionItems>[
                new ActionItems(
                    icon: new IconButton(
                      icon: new Icon(Icons.delete),
                      onPressed: () {},
                      color: Colors.red,
                    ),
                    onPress: () {
                      dialogEliminar(
                          listConteo[index].cantidad.toString(), index);
                    },
                    backgroudColor: Colors.white),
                new ActionItems(
                    icon: new IconButton(
                      icon: new Icon(Icons.edit),
                      onPressed: () {},
                      color: Colors.green,
                    ),
                    onPress: () {},
                    backgroudColor: Colors.white),
              ],
              child: new Column(
                children: <Widget>[
                  new ListTile(
                    title: new Text(
                        "Cantidad: " + listConteo[index].cantidad.toString()),
                    subtitle: Text("Fec. Registro: " +
                        listConteo[index].fregistro.toString()),
                  ),
                  new Divider(color: Colors.indigo),
                ],
              ));
        },
        //itemCount: 10,
      ),
    );
  }

  void dialogEliminar(String cantidad, int position) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Eliminar"),
          content: new Text(
              "¿Eliminar el Conteo $cantidad" + " pos: " + position.toString()),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Eliminar"),
              onPressed: () {
                eliminarConteo(listConteo[position].idconteo);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  //void deleteConteo(int idconteo) async{
  Future<bool> eliminarConteo(int idconteo) async {
    print("Id Conteo: " + idconteo.toString());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    String IPLHOST = "10.0.2.2";
    String IPFIA = "172.28.13.60";
    String IPMOLICOM = "128.1.10.26";
    //print("token"+token);
    //int idproducto = prefs.getInt("idproducto");
    //print("idproducto " + idproducto.toString());
    var jsonProductos = await http.delete(
        Uri.encodeFull(
            "http://$IPMOLICOM:2010/api/inventario/Conteo/DeleteConteo/" +
                idconteo.toString()),
        headers: {"Accept": "application/json", "Token": "$token"});
    final jsonResponse = json.decode(jsonProductos.body);
    return true;
  }

//}

// user defined function

}


