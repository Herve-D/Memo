import 'dart:io';
import 'package:memo/model/memo.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  DbHelper._();

  static final DbHelper db = DbHelper._();
  static Database _database;

  String tableMemo = 'table_memo';
  String colId = 'id_memo';
  String colName = 'name';
  String colDetail = 'detail';
  String colCategorie = 'categorie';
  String colDateCreate = 'date_create';
  String colDateUpdate = 'date_update';

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  Future<Database> initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "memo.db");
    return await openDatabase(path,
        version: 1, onOpen: (db) {}, onCreate: _onCreate);
  }

  void _onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE $tableMemo ("
        "$colId INTEGER PRIMARY KEY AUTOINCREMENT, "
        "$colName TEXT, "
        "$colDetail TEXT, "
        "$colCategorie TEXT, "
        "$colDateCreate TEXT, "
        "$colDateUpdate TEXT"
        ")");
  }

  addMemo(Memo memo) async {
    final db = await database;
    var raw = await db.insert(tableMemo, memo.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return raw;
  }

  Future<List<Memo>> getAllMemo() async {
    final db = await database;
    var res = await db.query(tableMemo);
    List<Memo> liste = res.map((e) => Memo.fromMap(e)).toList();
    return liste;
  }

  Future<List<Memo>> getMemoByCat(String categorie) async {
    final db = await database;
    var res = await db
        .query(tableMemo, where: "$colCategorie = ?", whereArgs: [categorie]);
    List<Memo> liste = res.map((e) => Memo.fromMap(e)).toList();
    return liste;
  }

  Future<Memo> getMemo(int id) async {
    final db = await database;
    var res = await db.query(tableMemo, where: "$colId = ?", whereArgs: [id]);
    return res.isNotEmpty ? Memo.fromMap(res.first) : null;
  }

  updateMemo(Memo memo) async {
    final db = await database;
    var res = await db.update(tableMemo, memo.toMap(),
        where: "$colId = ?", whereArgs: [memo.idMemo]);
    return res;
  }

  suppMemo(int id) async {
    final db = await database;
    return db.delete(tableMemo, where: "$colId = ?", whereArgs: [id]);
  }
}
