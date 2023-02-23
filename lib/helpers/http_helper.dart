// ignore_for_file: constant_identifier_names

import 'dart:convert';
import 'package:http/http.dart' as http;

enum GetLanding {
  recent,
  popular,
  trending,
}

class HttpHelper {
  static const baseUrl = "anime-api-vnkr.onrender.com";

  //broken
  static Future<Map<String, dynamic>> searchApi({
    required String query,
  }) async {
    final url = Uri.https(baseUrl, "/search/$query");
    final response = await http.get(url);
    return json.decode(response.body) as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>> getInfo({
    required int malID,
  }) async {
    final url = Uri.https(baseUrl, "/info/$malID");
    final response = await http.get(url);
    return json.decode(response.body) as Map<String, dynamic>;
  }

  static Future<List<dynamic>> getVideoSources({
    required String episodeID,
    required String animeId,
  }) async {
    final url = Uri.https(baseUrl, "/watch/$animeId/$episodeID");
    final response = await http.get(url);
    return json.decode(response.body) as List<dynamic>;
  }

  static Future<Map<String, dynamic>> getEpisodeList({
    required String title,
    required int releasedYear,
    String? season = "unknown",
  }) async {
    final url = Uri.https(baseUrl, "$title/$releasedYear/$season");
    final response = await http.get(url);
    return json.decode(response.body) as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>> getLanding({
    required GetLanding landing,
  }) async {
    final url = Uri.https(baseUrl, landing.name);
    final response = await http.get(url);
    return json.decode(response.body);
  }
}
