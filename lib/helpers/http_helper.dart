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

enum OrderBy {
  likes,
  created_at_unix,
  views,
  released_at_unix,
  title_sortable,
}

enum Ordering {
  asc,
  desc,
}

class HttpHelper {
  static const baseUrl = "api.consumet.org";

  static Future<Map<String, dynamic>> searchApi({
    required String query,
  }) async {
    final url = Uri.https(baseUrl, '"/meta/anilist/$query"');
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

  static Future<Map<String, dynamic>> getLanding(
      {required GetLanding landing, Stream provider = Stream.gogoanime}) async {
    final identifier = landing.name.split('_').join('-').toString();
    final url = Uri.https(baseUrl, "/meta/anilist/$identifier", {
      "provider": provider.name,
    });
    final response = await http.get(url);
    return json.decode(response.body);
  }
}

// class HttpHelper {
//   static const baseUrl = "hani.nsdev.ml";

//   static Future<http.Response> searchApi({
//     required String searchQuery,
//     OrderBy orderBy = OrderBy.created_at_unix,
//     Ordering ordering = Ordering.desc,
//     int page = 0,
//     List<dynamic> tags = const [],
//     List<dynamic> brands = const [],
//     List<dynamic> blacklist = const [],
//   }) {
//     final searchUri = Uri.https(baseUrl, "/search");
//     final reqBody = json.encode({
//       "search": searchQuery,
//       "tags": tags,
//       "tags-mode": "AND",
//       "brands": brands,
//       "blacklist": blacklist,
//       "order_by": orderBy.name,
//       "ordering": ordering.name,
//       "page": page,
//     });
//     final response = http.post(
//       searchUri,
//       body: reqBody,
//     );
//     return response;
//   }

//   static Future<http.Response> getVideo({required String slug}) {
//     final url = Uri.https(baseUrl, "/getVideo/$slug");
//     return http.get(url);
//   }

//   static Future<http.Response> getInfo({required String slug}) {
//     final url = Uri.https(baseUrl, "/getInfo/$slug");
//     return http.get(url);
//   }

//   static Future<http.Response> getLanding({required GetLanding option}) {
//     final url = Uri.http(baseUrl, "/getLanding/${option.name}");
//     return http.get(url);
//   }

//   static Future<http.Response> getBrowsePage() {
//     final url = Uri.http(baseUrl, "/browse");
//     return http.get(url);
//   }

//   static Future<http.Response> getTag({
//     required String tag,
//     int page = 0,
//     OrderBy orderBy = OrderBy.created_at_unix,
//     Ordering ordering = Ordering.desc,
//   }) {
//     final url = Uri.parse(
//       "https://hanime.tv/api/v8/browse/hentai-tags/$tag?page=$page&order_by=${orderBy.name}&ordering=${ordering.name}",
//     );

//     return http.get(url, headers: {
//       "X-Signature-Version": "web2",
//       "X-Signature": "7f0481406743cee083a7d01dc0530d98",
//     });
//   }

//   static Future<http.Response> getBrand({
//     required String brand,
//     int page = 0,
//     OrderBy orderBy = OrderBy.created_at_unix,
//     Ordering ordering = Ordering.desc,
//   }) {
//     final url = Uri.parse(
//       "https://hanime.tv/api/v8/browse/brands/$brand?page=$page&order_by=${orderBy.name}&ordering=${ordering.name}",
//     );
//     return http.get(url, headers: {
//       "X-Signature-Version": "web2",
//       "X-Signature": "7f0481406743cee083a7d01dc0530d98",
//     });
//   }
// }


