import 'dart:async';
import 'dart:io' as io;

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:inventario/models/usuario.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;

  static Database _db;

  Future<Database> get db async {
    if(_db != null)
      return _db;
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "inventario.db");
    var theDb = await openDatabase(path, version: 2, onCreate: _onCreate);
    return theDb;
  }


  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute(
        "CREATE TABLE Usuario(id INTEGER PRIMARY KEY,idusuario INTEGER, idequipo INTEGER, nombre TEXT, password TEXT)");
    print("tabla creada");
  }


  void saveEmployee(Usuario usuario) async {
    var dbClient = await db;

    await dbClient.transaction((txn) async {
      return await txn.rawInsert(
          'INSERT INTO Usuario (idequipo,nombre,password) VALUES (\'${usuario.idequipo}\',\'${usuario.nombre}\,\'${usuario.password}\')');});
  }

  Future<int> saveNote(Usuario note) async {
    var dbClient = await db;
    var result = await dbClient.insert("Usuario", note.toMap());
//    var result = await dbClient.rawInsert(
//        'INSERT INTO $tableNote ($columnTitle, $columnDescription) VALUES (\'${note.title}\', \'${note.description}\')');

    return result;
  }



  Future<Usuario> getUsuario(String password) async {
    var dbClient = await db;
    /*List<Map> result = await dbClient.query(tableNote,
        columns: [columnId, columnTitle, columnDescription],
        where: '$columnId = ?',
        whereArgs: [id]);*/
  var result = await dbClient.rawQuery('SELECT * FROM Usuario WHERE password =\'$password\'');

    if (result.length > 0) {
      return new Usuario.map(result.first);
    }
    return null;
  }


  Future<int> deleteUsers() async {
    var dbClient = await db;
    int res = await dbClient.delete("Usuario");
    return res;
  }

  Future<bool> isLoggedIn() async {
    var dbClient = await db;
    var res = await dbClient.query("Usuario");
    return res.length > 0? true: false;
  }

}