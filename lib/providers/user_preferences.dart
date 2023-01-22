import '../helpers/db_helper.dart';
import '../helpers/http_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum FilterType {
  tag,
  brand,
  blacklist,
}

enum VideoQuality {
  highest,
  normal,
  lowest,
}

class UserPreferences with ChangeNotifier {
  List<dynamic> _blacklist = [];
  List<dynamic> _tags = [];
  List<dynamic> _brands = [];
  List<Map<String, dynamic>> favourites = [];
  OrderBy orderBy = OrderBy.released_at_unix;
  Ordering ordering = Ordering.desc;
  VideoQuality quality = VideoQuality.highest;

  Future<void> setVideoQuality({required VideoQuality videoQuality}) async {
    quality = videoQuality;
    notifyListeners();
    final data = await SharedPreferences.getInstance();
    data.setInt("quality", quality.index);
    return;
  }

  Future<void> setOrderBy(OrderBy order) async {
    orderBy = order;
    notifyListeners();
    final data = await SharedPreferences.getInstance();
    data.setInt("orderBy", orderBy.index);
    return;
  }

  Future<void> setOrdering(Ordering order) async {
    ordering = order;
    notifyListeners();
    final data = await SharedPreferences.getInstance();
    data.setInt("ordering", ordering.index);
    return;
  }

  Future<void> fetchPreferences() async {
    final data = await SharedPreferences.getInstance();
    final prefsOrderBy = data.getInt("orderBy");
    final prefsOrdering = data.getInt("ordering");
    final prefsVideoQuality = data.getInt("quality");

    if (prefsOrderBy != null) {
      orderBy = OrderBy.values[prefsOrderBy];
    }
    if (prefsOrdering != null) {
      ordering = Ordering.values[prefsOrdering];
    }
    if (prefsVideoQuality != null) {
      quality = VideoQuality.values[prefsVideoQuality];
    }
    notifyListeners();
    return;
  }

  List<dynamic> get(FilterType filterType) {
    switch (filterType) {
      case FilterType.tag:
        return [..._tags];
      case FilterType.brand:
        return [..._brands];
      case FilterType.blacklist:
        return [..._blacklist];
      default:
        break;
    }
    return [];
  }

  Future<List<Map<String, dynamic>>> fetchFromDB() async {
    final data = await DBHelper.queryAll();
    favourites = data;
    notifyListeners();
    return data;
  }

  Future<int> addToFavourites({
    required Map<String, dynamic> data,
  }) async {
    int id = await DBHelper.insert(data: data);
    fetchFromDB();
    return id;
  }

  Future<int> removeFromFavourites({
    required Map<String, dynamic> data,
  }) async {
    int id = await DBHelper.delete(data: data);
    fetchFromDB();
    return id;
  }

  Future<void> toggleFavourites({
    required Map<String, dynamic> data,
  }) async {
    final result = await DBHelper.query(slug: data["slug"]);
    if (result.isEmpty) {
      await addToFavourites(data: data);
    } else {
      await removeFromFavourites(data: data);
    }
    await fetchFromDB();
    return;
  }

  void toggle(String tag, FilterType filterType) {
    switch (filterType) {
      case FilterType.tag:
        if (_tags.contains(tag)) {
          _tags = _tags.where((element) => element != tag).toList();
        } else {
          _tags = [..._tags, tag];
        }
        break;
      case FilterType.brand:
        if (_brands.contains(tag)) {
          _brands = _brands.where((element) => element != tag).toList();
        } else {
          _brands = [..._brands, tag];
        }
        break;
      case FilterType.blacklist:
        if (_blacklist.contains(tag)) {
          _blacklist = _blacklist.where((element) => element != tag).toList();
        } else {
          _blacklist = [..._tags, tag];
        }
        break;
      default:
        break;
    }
    notifyListeners();
    return;
  }

  void remove(String tag, FilterType filterType) {
    switch (filterType) {
      case FilterType.tag:
        _tags.remove(tag);
        break;
      case FilterType.brand:
        _brands.remove(tag);
        break;
      case FilterType.blacklist:
        _blacklist.remove(tag);
        break;
      default:
        break;
    }
    notifyListeners();
    return;
  }

  void add(String tag, FilterType filterType) {
    switch (filterType) {
      case FilterType.tag:
        _tags.add(tag);
        break;
      case FilterType.brand:
        _brands.add(tag);
        break;
      case FilterType.blacklist:
        _blacklist.add(tag);
        break;
      default:
        break;
    }
    notifyListeners();
    return;
  }
}
