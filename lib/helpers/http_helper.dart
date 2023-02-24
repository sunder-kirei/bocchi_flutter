// ignore_for_file: constant_identifier_names

import 'dart:convert';
import 'package:anime_api/helpers/http_exception.dart';
import 'package:http/http.dart' as http;

enum GetLanding {
  recent,
  popular,
  trending,
}

class HttpHelper {
  static const baseUrl = "anime-api-vnkr.onrender.com";

  static Future<Map<String, dynamic>> searchApi({
    required String query,
  }) async {
    final url = Uri.https(baseUrl, "/search/$query");
    try {
      final response = await http.get(url);
      return json.decode(response.body) as Map<String, dynamic>;
    } catch (err) {
      throw ApiException(
        error: err.toString(),
        message: "Failed to search.",
      );
    }
  }

  static Future<Map<String, dynamic>> getInfo({
    required int malID,
  }) async {
    final url = Uri.https(baseUrl, "/info/$malID");
    try {
      final response = await http.get(url);
      return json.decode(response.body) as Map<String, dynamic>;
    } catch (err) {
      throw ApiException(
        error: err.toString(),
        message: "Failed to load info.",
      );
    }
  }

  static Future<List<dynamic>> getVideoSources({
    required String episodeID,
    required String animeId,
  }) async {
    final url = Uri.https(baseUrl, "/watch/$animeId/$episodeID");
    try {
      final response = await http.get(url);
      return json.decode(response.body) as List<dynamic>;
    } catch (err) {
      throw ApiException(
        error: err.toString(),
        message: "Failed to load streaming info.",
      );
    }
  }

  static Future<Map<String, dynamic>> getEpisodeList({
    required String title,
    required int releasedYear,
    String? season = "unknown",
  }) async {
    final url = Uri.https(baseUrl, "$title/$releasedYear/$season");
    try {
      final response = await http.get(url);
      return json.decode(response.body) as Map<String, dynamic>;
    } catch (err) {
      throw ApiException(
        error: err.toString(),
        message: "Failed to load episode info.",
      );
    }
  }

  static Future<Map<String, dynamic>> getLanding({
    required GetLanding landing,
  }) async {
    final url = Uri.https(baseUrl, landing.name);
    try {
      final response = await http.get(url);
      return json.decode(response.body);
    } catch (err) {
      throw ApiException(
        error: err.toString(),
        message: "Looks like there was a network failure.",
      );
    }
  }
}
