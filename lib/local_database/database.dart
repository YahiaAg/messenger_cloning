import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class MyDatabase {
  static Future<sql.Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(
      path.join(dbPath, 'messenger.db'),
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE user(uid TEXT PRIMARY KEY, email TEXT, username TEXT, password TEXT, image BLOB)',
        );
        await db.execute(
          'CREATE TABLE contacts(uid TEXT PRIMARY KEY, email TEXT, username TEXT, image BLOB)',
        );
      },
      version: 1,
    );
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await MyDatabase.database();
    await db.insert(
      table,
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await MyDatabase.database();
    return db.query(table);
  }
}
