import 'package:anime_api/helpers/db_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum PrefferedTitle {
  english,
  romaji,
}

class Watchlist with ChangeNotifier {
  List<Map<String, dynamic>> watchlist = [];
  List<Map<String, dynamic>> history = [];
  String preferredQuality = "720";
  PrefferedTitle prefferedTitle = PrefferedTitle.english;

  Future<void> setQuality({required String quality}) async {
    final preferences = await SharedPreferences.getInstance();
    preferences.setString("preferredQuality", quality);
    preferredQuality = quality;
    notifyListeners();
    return;
  }

  Future<void> fetchQuality() async {
    final preferences = await SharedPreferences.getInstance();
    final data = preferences.getString("preferredQuality");
    preferredQuality = data ?? "360";
    notifyListeners();
    return;
  }

  Future<void> setTitle({required PrefferedTitle title}) async {
    final preferences = await SharedPreferences.getInstance();
    preferences.setInt("prefferedTitle", title.index);
    prefferedTitle = title;
    notifyListeners();
    return;
  }

  Future<void> fetchTitle() async {
    final preferences = await SharedPreferences.getInstance();
    final data = preferences.getInt("prefferedTitle");
    if (data == null) {
      prefferedTitle = PrefferedTitle.values[0];
    } else {
      prefferedTitle = PrefferedTitle.values[data];
    }
    notifyListeners();
    return;
  }

  Future<void> fetchWatchlist() async {
    final result = await DBHelper.queryAll();
    watchlist = [...result];
    notifyListeners();
    return;
  }

  Future<void> fetchHistory() async {
    final result = await DBHelper.queryAllHistory();
    history = [...result];
    notifyListeners();
    return;
  }

  Future<void> fetchAll() async {
    await fetchWatchlist();
    await fetchHistory();
    await fetchQuality();
    await fetchTitle();
    return;
  }

  List<Map<String, dynamic>> get getWatchlist {
    return [...watchlist];
  }

  List<Map<String, dynamic>> get getHistory {
    return [...history];
  }

  Future<void> addToWatchlist({
    required String id,
    required String image,
    required String titleRomaji,
  }) async {
    await DBHelper.insert(
      itemId: id,
      titleRomaji: titleRomaji,
      image: image,
    );
    await fetchWatchlist();
    return;
  }

  Future<void> addToHistory({
    required String itemId,
    required String episodeImage,
    required String image,
    required int episode,
    required String details,
    required int position,
    required String title,
  }) async {
    await DBHelper.insertHistory(
      itemId: itemId,
      episodeImage: episodeImage,
      image: image,
      episode: episode,
      details: details,
      position: position,
      title: title,
    );
    await fetchHistory();
    return;
  }

  Future<void> removeFromWatchlist({
    required String id,
  }) async {
    await DBHelper.delete(itemId: id);
    await fetchWatchlist();
    return;
  }

  Future<void> toggle({
    required String id,
    required String image,
    required String titleRomaji,
  }) async {
    bool isPresent = watchlist.indexWhere(
          (element) => element["id"] == id,
        ) !=
        -1;
    if (isPresent) {
      await removeFromWatchlist(id: id);
      return;
    }
    await addToWatchlist(
      id: id,
      image: image,
      titleRomaji: titleRomaji,
    );
    return;
  }
}
