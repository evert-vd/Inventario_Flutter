
class Usuario {
  int _iduser;
  String _nombre, _password;
  int _idequipo;
  Usuario(this._iduser,this._nombre, this._password, this._idequipo);


  Usuario.map(dynamic obj) {
    this._iduser=obj['idusuario'];
    this._idequipo=obj['idequipo'];
    this._nombre = obj['nombre'];
    this._password = obj['password'];
  }

  int get idusuario => _iduser;
  String get nombre => _nombre;
  String get password => _password;
  int get idequipo=>_idequipo;
  /*factory Usuario.fromJson(Map<String, dynamic> json){
    return Usuario(_nombre: json['nombre'], _password: json['password'])
  }*/

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    /*if (_nombre != null) {
      map['nombre'] = _nombre;
    }*/
    map['idusuario'] = idusuario;
    map['idequipo'] = idequipo;
    map['nombre'] = nombre;
    map['password'] = password;

    return map;
  }



/*
  Usuario.fromMap(Map map) {
    nombre = map['nombre'];
    password = map['password'];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["nombre"] = nombre;
    map["password"] = password;

    return map;
  }
*/



}