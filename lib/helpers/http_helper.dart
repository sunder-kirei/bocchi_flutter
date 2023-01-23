// ignore_for_file: constant_identifier_names

import 'dart:convert';
import 'package:http/http.dart' as http;

enum GetLanding {
  recent_episodes,
  popular,
  trending,
}

enum Stream {
  animepahe,
  zoro,
  gogoanime,
}

class HttpHelper {
  static const baseUrl = "api.consumet.org";

  static Future<Map<String, dynamic>> searchApi({
    required String query,
  }) async {
    final url = Uri.https(baseUrl, "/meta/anilist/advanced-search", {
      "query": query,
    });
    final response = await http.get(url);
    return json.decode(response.body) as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>> getInfo({
    required int malID,
    Stream provider = Stream.gogoanime,
  }) async {
    final url = Uri.https(baseUrl, "/meta/anilist/info/$malID", {
      "provider": provider.name,
    });
    final response = await http.get(url);
    return json.decode(response.body) as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>> getVideo({
    required String episodeID,
    Stream provider = Stream.gogoanime,
  }) async {
    final url = Uri.https(baseUrl, "/meta/anilist/watch/$episodeID", {
      "provider": provider.name,
    });
    final response = await http.get(url);
    return json.decode(response.body) as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>> getLanding({
    required GetLanding landing,
    Stream provider = Stream.animepahe,
  }) async {
    final identifier = landing.name.split('_').join('-').toString();
    final url = Uri.https(baseUrl, "/meta/anilist/$identifier", {
      "provider": provider.name,
      "perPage": "40",
    });
    final response = await http.get(url);
    return json.decode(response.body);
  }
}
