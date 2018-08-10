import 'package:inventario/models/usuario.dart';
class Respuesta {
  int error;
  String mensaje;
  Usuario data;

  Respuesta({this.error, this.data, this.mensaje});

  factory Respuesta.fromJson(Map<String, dynamic> parsedJson){
    return Respuesta(
        error: parsedJson['error'],
        mensaje: parsedJson['mensaje'],
        data: Usuario.map(parsedJson['data'])
    );
  }
}