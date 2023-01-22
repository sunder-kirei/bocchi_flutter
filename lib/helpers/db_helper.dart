import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static const tableName = "favourites";

  static Future<Database> openDB() async {
    final path = join(await getDatabasesPath(), "user.db");
    final sql = await openDatabase(
      path,
      onCreate: (db, version) async => await db.execute(
        "CREATE TABLE $tableName (slug TEXT PRIMARY KEY,title TEXT, coverUrl TEXT, posterUrl TEXT, tag TEXT)",
      ),
      version: 1,
    );
    return sql;
  }

  static Future<List<Map<String, dynamic>>> queryAll() async {
    final sql = await openDB();
    final data = await sql.query(tableName);
    return data;
  }

  static Future<List<Map<String, dynamic>>> query({
    required String slug,
  }) async {
    final sql = await openDB();
    final data = await sql.query(
      tableName,
      distinct: true,
      where: "slug = ?",
      whereArgs: [slug],
    );
    return data;
  }

  static Future<int> insert({required Map<String, dynamic> data}) async {
    final sql = await openDB();
    final id = await sql.insert(
      tableName,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  static dynamic delete({required Map<String, dynamic> data}) async {
    final sql = await openDB();
    final id = await sql.delete(
      tableName,
      where: "slug = ?",
      whereArgs: [data["slug"]],
    );
    return id;
  }
}
