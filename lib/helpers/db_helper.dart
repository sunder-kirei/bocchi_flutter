import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static const tableName = "watchlist";

  static Future<Database> openDB() async {
    final path = join(await getDatabasesPath(), "user.db");
    final sql = await openDatabase(
      path,
      onCreate: (db, version) async => await db.execute(
        "CREATE TABLE $tableName (id TEXT PRIMARY KEY, romaji TEXT, image TEXT)",
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
    required String id,
  }) async {
    final sql = await openDB();
    final data = await sql.query(
      tableName,
      distinct: true,
      where: "id = ?",
      whereArgs: [id],
    );
    return data;
  }

  static Future<int> insert({
    required String itemId,
    required String titleRomaji,
    required String image,
  }) async {
    final sql = await openDB();
    final id = await sql.insert(
      tableName,
      {
        "id": itemId,
        "romaji": titleRomaji,
        "image": image,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  static dynamic delete({required String itemId}) async {
    final sql = await openDB();
    final id = await sql.delete(
      tableName,
      where: "id = ?",
      whereArgs: [itemId],
    );
    return id;
  }
}
