import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:inventario/models/conteo.dart';
import 'dart:convert';

class ConteoApi{

  static String IPLHOST="10.0.2.2";
  static String IPFIA="172.28.13.60";
  static String IPMOLICOM="128.1.10.26";
  static final BASE_URL = "http://$IPMOLICOM:2010/api/inventario";//fia

  //static final BASE_URL = "http://128.1.10.26:5800/api/inventario";
  static final LOGIN_URL = BASE_URL + "/Login/Login?";

  List<Conteo> listConteo;

  Future<List<Conteo>> getConteoProducto() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    print("token"+token);
    int idproducto = prefs.getInt("idproducto");
    //print("idproducto " + idproducto.toString());
    String IPFIA="172.28.13.60";
    String IPMOLICOM="128.1.10.26";
    String IPLHOST="10.0.2.2";
    var jsonProductos = await http.get(
        Uri.encodeFull("http://$IPMOLICOM:2010/api/inventario/Conteo/GetConteoProducto?idproducto=" + idproducto.toString()),
        headers: {
          "Accept": "application/json",
          "Token": "$token"
        });
    final jsonResponse = json.decode(jsonProductos.body);
    ConteoList productoList = ConteoList.fromJson(jsonResponse);
    listConteo=productoList.conteos;
    return listConteo;
  }
}