import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DbHelper {
  static DbHelper _dbHelper;
  static Database _database;

  DbHelper._createObject();

  factory DbHelper() {
    if(_dbHelper == null) {
      _dbHelper = DbHelper._createObject();
    }
    return _dbHelper;
  }
    
  Future<Database> initDb() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'cashflow.db';

    var todoDatabase = openDatabase(path, version: 1, onCreate: _createDb);

    return todoDatabase;
  }

  void _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE cash (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        description TEXT,
        price DOUBLE,
        amount DOUBLE,
        type BOOLEAN,
        categoryId INTEGER,
        createdAt DATE DEFAULT (datetime('now','localtime')),
        updatedAt DATE DEFAULT (datetime('now','localtime'))
      )
    ''');
    await db.execute('''
      CREATE TABLE category (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        createdAt DEFAULT CURRENT_TIMESTAMP,
        updatedAt DEFAULT CURRENT_TIMESTAMP        
      )    
    ''');
  }

  Future<Database> get database async {
    if(_database == null) {
      _database = await initDb();
    }
    return _database;
  }

  Future<List<Map<String, dynamic>>> select(String table, {String filter = 'id'}) async {
    Database db = await this.database;
    var mapList = await db.query(table, orderBy: filter);
    return mapList;
  }

  Future<int> insert(String table, Map<String, dynamic> row) async {
    Database db = await this.database;
    int count = await db.insert(table, row);
    return count;
  }

  Future<int> update(String table, Map<String, dynamic> row, int where) async {
    Database db = await this.database;
    int count = await db.update(table, row, where: 'id=?', whereArgs: [where]);
    return count;
  }

  Future<int> delete(String table, int id) async {
    Database db = await this.database;
    int count = await db.delete(table, where: 'id=?', whereArgs: [id]);
    return count;
  }

  Future<List<Map<String, dynamic>>> search(String table, String where, String whereArg, {String order = 'id'}) async {
    Database db = await this.database;
    var mapList = await db.query(table, where: where, whereArgs: [whereArg], orderBy: order);
    return mapList;
  }  
}