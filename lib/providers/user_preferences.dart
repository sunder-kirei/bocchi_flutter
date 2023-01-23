import 'dart:ffi';
import 'dart:math';

import 'package:anime_api/helpers/db_helper.dart';
import 'package:flutter/foundation.dart';

class Watchlist with ChangeNotifier {
  List<Map<String, dynamic>> watchlist = [];
  List<Map<String, dynamic>> history = [];

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
    required int position,
  }) async {
    await DBHelper.insertHistory(
      itemId: itemId,
      episodeImage: episodeImage,
      image: image,
      episode: episode,
      position: position,
    );
    await fetchWatchlist();
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
