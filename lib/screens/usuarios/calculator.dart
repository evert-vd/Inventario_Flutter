import 'package:flutter/material.dart';
//import 'package:math_expressions/math_expressions.dart';
import 'package:inventario/screens/usuarios/user_conteo_producto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:inventario/models/conteo.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:inventario/models/producto.dart';


/*class Calculator extends StatelessWidget {

  @override
  MyHomePage createState() => new MyHomePage();


  /*
  @override
  Widget build(BuildContext context) {
    /*return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),*/
      home: new MyHomePage(title: 'Calculator'),
    );
  }*/
}*/

class CalculadoraConteo extends StatefulWidget {
  CalculadoraConteo({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Calculadora createState() => new Calculadora();
}

class Calculadora extends State<CalculadoraConteo> {
  String puntoDecimal = "";

  var resultado = "";
  String operation = "";
  int contadorIgual = 0;

  buttonPressed(String buttonText) {
    if (buttonText == "C") {
      //print("eliminado:"+ listNumber.clear());
      puntoDecimal = "0";
      contadorIgual = 0;
      operation = operation.substring(0, operation.length - 1);
    } else if (buttonText == "+" ||
        buttonText == "-" ||
        buttonText == "/" ||
        buttonText == "*") {
      operation += buttonText;
      puntoDecimal = "0";
      //evualua si ya se ha igualado una operacion
      if (contadorIgual > 0) {
        operation = resultado +
            buttonText; //concatena el resultado + el operador pulsado
        resultado = ""; //limpia el resultado
        contadorIgual = 0; //se setea el contadorigual
      }
    } else if (buttonText == ".") {
      if (puntoDecimal.contains(".")) {
        print("el numero ya tiene punto decimal asignado");
        return;
      } else {
        puntoDecimal = puntoDecimal + buttonText;
        operation += buttonText;
        //operation+=output;
      }
    } else if (buttonText == "=") {
      try {
        resultado = calucularResultado(operation).toString();
        contadorIgual++;
      } on Error {
        resultado = 'Error. Verifica la operación';
      }
    } else if (buttonText == "Guardar") {
      if (resultado != "") {
        //guardar
        saveConteoProducto(resultado);

        Navigator.of(context).pop(new MaterialPageRoute(
            builder: (context) => new UserConteoProducto()));
      }
    } else {
      operation += buttonText;
    }
    print(resultado);
    setState(() {
      //resultado = double.parse(operation).toStringAsFixed(3).toString();
    });
  }

  double calucularResultado(String numero) {
    /*try {
      Parser p = new Parser();
      Expression exp = p.parse(numero);
      print(exp);
      ContextModel cm = new ContextModel();
      var resultado = exp.evaluate(EvaluationType.REAL, cm);
      print("Resultado:" + resultado.toString());
      return resultado;
    }on Error{
      return 0;
    }
*/

    /*Parser p = new Parser();
    //Expression exp = p.parse("x * 2*2.5");
    Expression exp = p.parse(numero);

    print(exp);

    ContextModel cm = new ContextModel();
    cm.bindVariableName('x', new Number(1.0));

    if (numero.trim().length <= 0) {
      return null;
    }
    double eval = exp.evaluate(EvaluationType.REAL, cm);
    return eval;*/
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

  Future<String> saveConteoProducto(var resultado) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    print("token" + token);
    int idproducto = prefs.getInt("idproducto");
    int idzona = prefs.getInt("idzona");
    //print("idproducto " + idproducto.toString());
    String IPLHOST = "10.0.2.2";
    String IPFIA = "172.28.13.60";
    String IPMOLICOM = "128.1.10.26";

    final Conteo conteo = new Conteo();
    conteo.idinventario = 1;
    conteo.idproducto = idproducto;
    conteo.idzona = idzona;
    conteo.cantidad = 13.0;
    conteo.fregistro = new DateTime.now().toString();

    print(conteo.toJson());
    String url = "http://$IPMOLICOM:2010/api/inventario/Conteo/PostConteo";
    var jsonProductos = await http.post(url, headers: {
      "Accept": "application/json",
      "Token": "$token"
    }, body: {
      "idinventario": '1',
      "idproducto": '$idproducto',
      "idzona": '$idzona',
      "cantidad": '$resultado',
      "eliminado": 'false',
      "fregistro": new DateTime.now().toString(),
    });
    //final jsonResponse = json.decode(jsonProductos.body);
    //ConteoList productoList = ConteoList.fromJson(jsonResponse);
    print("resultado: " + jsonProductos.body);
    return jsonProductos.body;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(

        /*appBar: new AppBar(
          title: new Text(widget.title),
        ),*/
        body: new Container(
          color: Colors.black54,
      //padding: EdgeInsets.only(top: 20.0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[

          Container(
            color: Colors.black54,
            alignment: Alignment.topLeft,
            padding: new EdgeInsets.only(top: 30.0, right: 20.0, left: 10.0),
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
                    new TextStyle(fontSize: 11.0, color: Colors.white),
                  );
                }),
          ),

          Container(
            color: Colors.black54,
            alignment: Alignment.topLeft,
            padding: new EdgeInsets.only(top: 5.0, right: 20.0, left: 10.0, bottom: 8.0),
            child: new FutureBuilder(
                future: getProducto(),
                initialData: new Producto(),
                builder: (context, snapShot) {
                  Producto producto = snapShot.data;
                  String descripcion = producto.descripcion.toString();
                  return new Text(
                    descripcion.toUpperCase(),
                    /*"adsadasd asdasda dasdasda adsasdadasdadasdasdadsad".toUpperCase()*/
                    style:
                    new TextStyle(fontSize: 13.0, color: Colors.white),
                  );
                }),
          ),


          new Container(
            color: Colors.white,
            alignment: Alignment.centerRight,
            padding: new EdgeInsets.only(top: 25.0, right: 20.0, left: 10.0),
            // new EdgeInsets.symmetric(vertical: 24.0, horizontal: 12.0),
            child: new Text(operation,
                style: new TextStyle(
                  fontSize: 23.0,
                  //fontWeight: FontWeight.bold,
                )),
          ),
          new Container(
            color: Colors.white,
            alignment: Alignment.centerRight,
            padding:
                //new EdgeInsets.symmetric(vertical: 12.0, horizontal: 6.0),
                new EdgeInsets.only(
                    top: 30.0, right: 30.0, left: 10.0, bottom: 20.0,),
            child: new Text(resultado,
                style: new TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                )),
          ),
          /*new Expanded(
          //flex: 20,
          child: new Divider(/*color: Colors.white*/),
        ),*/
          Expanded(
            child: Container(
                color: Colors.black54,
              padding:
                  //new EdgeInsets.symmetric(vertical: 12.0, horizontal: 6.0),
              new EdgeInsets.only(top: 20.0),
              child: Column(children: [
                new Row(children: [
                  buildButton("7"),
                  buildButton("8"),
                  buildButton("9"),
                  buildButton("/")
                ]),
                new Row(children: [
                  buildButton("4"),
                  buildButton("5"),
                  buildButton("6"),
                  buildButton("*")
                ]),
                new Row(children: [
                  buildButton("1"),
                  buildButton("2"),
                  buildButton("3"),
                  buildButton("-")
                ]),
                new Row(children: [
                  buildButton("."),
                  buildButton("0"),
                  buildButton("C"),
                  buildButton("+")
                ]),
                new Row(children: [
                  buildButton("="),
                  buildButton("Guardar"),
                ])
              ])))
        ],
      ),
    ));
  }

  Widget buildButton(String buttonText) {
    return new Expanded(
      //child: new OutlineButton(
      child: new FlatButton(
        //color: Colors.black38,
        padding: new EdgeInsets.all(24.0),
        child: new Text(
          buttonText,
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white ),
        ),
        onPressed: () => buttonPressed(buttonText),
      ),
    );
  }
}
