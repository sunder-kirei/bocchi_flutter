import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static const tableName = "watchlist";
  static const historyTable = "history";

  static Future<Database> openDB() async {
    final path = join(await getDatabasesPath(), "user.db");
    final sql = await openDatabase(
      path,
      onCreate: (db, version) async {
        await db.execute(
          "CREATE TABLE $tableName (id TEXT PRIMARY KEY, romaji TEXT, image TEXT)",
        );
        await db.execute(
          "CREATE TABLE $historyTable (id TEXT PRIMARY KEY, image TEXT, episode INTEGER, episodeImage TEXT, details TEXT, position INTEGER)",
        );
      },
      version: 1,
    );
    return sql;
  }

  static Future<Map<String, List<Map<String, dynamic>>>> getDatabase() async {
    final sql = await openDB();
    final watchlist = await sql.query(tableName);
    final history = await sql.query(historyTable);
    return {
      "watchlist": watchlist,
      "histoy": history,
    };
  }

  static Future<List<Map<String, dynamic>>> queryAll() async {
    final sql = await openDB();
    final data = await sql.query(tableName);
    return data;
  }

  static Future<List<Map<String, dynamic>>> queryAllHistory() async {
    final sql = await openDB();
    final data = await sql.query(historyTable);
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

  static Future<List<Map<String, dynamic>>> queryHistory({
    required String id,
  }) async {
    final sql = await openDB();
    final data = await sql.query(
      historyTable,
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

  static Future<int> insertHistory({
    required String itemId,
    required String episodeImage,
    required String image,
    required int episode,
    required String details,
    required int position,
  }) async {
    final sql = await openDB();
    final id = await sql.insert(
      historyTable,
      {
        "id": itemId,
        "image": image,
        "episode": episode,
        "episodeImage": episodeImage,
        "details": details,
        "position": position,
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

  static dynamic deleteHistory({required String itemId}) async {
    final sql = await openDB();
    final id = await sql.delete(
      historyTable,
      where: "id = ?",
      whereArgs: [itemId],
    );
    return id;
  }
}
