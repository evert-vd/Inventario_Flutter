

import 'dart:async';
import 'dart:convert';
import 'package:inventario/models/respuesta.dart';
import 'package:inventario/models/usuario.dart';
import 'package:http/http.dart' as http;



class RestDatasource {

  /*NetworkUtil _netUtil = new NetworkUtil();
  static final BASE_URL = "http://10.0.2.2:2010/api/inventario";
  static final LOGIN_URL = BASE_URL + "/Login?";

  Future<User> login(String username, String password) {
    return _netUtil.post(LOGIN_URL+"username="+username+"&password="+password,
        headers: {"Accept": "application/json"}).then((dynamic res) {
      print(res.toString());
      if(res["error"]) throw new Exception(res["error_msj"]);
      return null;
      //return new User.map(res["usuario"]);
    });
  }*/

  //NetworkUtil _netUtil = new NetworkUtil();
  //static final BASE_URL = "http://128.1.10.26:2010/api/inventario";//molicom
  static String IPLHOST="10.0.2.2";
  static String IPFIA="172.28.13.60";
  static String IPMOLICOM="128.1.10.26";
  static final BASE_URL = "http://$IPMOLICOM:2010/api/inventario";//fia
  //static final BASE_URL = "http://128.1.10.26:5800/api/inventario";
  static final LOGIN_URL = BASE_URL + "/Login/Login?";
  static final _API_KEY = "somerandomkey";

  Future<Usuario> login(String nombre, String password) async {
    final response =
    await http.post(LOGIN_URL+"username="+nombre+"&password="+password,
        headers: {"Accept": "application/json"});

    //if (response.statusCode == 200) {
    if (response.statusCode < 200 || response.statusCode > 400 || response.body == null) {
      print("Loginerror:"+response.body);

      throw new Exception("Error while fetching data");
    }
      //String res= _decoder.convert(response.body);
      //String token=response.headers["token"];
      //String idequipo=response.headers["idequipo"];
      print("Login:"+response.body);


      var jsonResponse = json.decode(response.body);

      Respuesta respuesta = new Respuesta.fromJson(jsonResponse);
      print("RespuestaUser: "+respuesta.data.toString() );
      return  respuesta.data;

      }
}