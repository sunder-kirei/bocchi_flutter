import 'dart:ffi';

import 'package:anime_api/helpers/db_helper.dart';
import 'package:flutter/foundation.dart';

class Watchlist with ChangeNotifier {
  List<Map<String, dynamic>> watchlist = [];

  Future<void> fetchWatchlist() async {
    final result = await DBHelper.queryAll();
    watchlist = [...result];
    notifyListeners();
    return;
  }

  List<Map<String, dynamic>> get getWatchlist {
    return [...watchlist];
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
}
