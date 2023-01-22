import 'dart:convert';

import 'package:anime_api/screens/video_player_screen.dart';
import 'package:anime_api/widgets/row_item.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:video_player/video_player.dart';

import '../providers/user_preferences.dart';
import '../screens/browse_tag_screen.dart';
import '../screens/web_view.dart';
import '../widgets/custom_player.dart';
import '../widgets/info_pane.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';

import '../widgets/hanime_rich_text.dart';
import '../widgets/hero_image.dart';
import '../helpers/http_helper.dart';
import 'package:provider/provider.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key});
  static const routeName = "/details";

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  Map<String, dynamic>? fetchedData;

  @override
  void didChangeDependencies() {
    HttpHelper.getInfo(
            malID: (int.parse((ModalRoute.of(context)?.settings.arguments
                as Map<String, dynamic>)["id"])))
        .then(
      (value) {
        setState(() {
          fetchedData = value;
        });
      },
    );
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const HanimeRichText(
          fontSize: 20,
        ),
      ),
      // floatingActionButton: fetchedData == null
      //     ? null
      //     : Consumer<UserPreferences>(
      //         builder: (context, value, child) {
      //           final data = {
      //             "slug": (ModalRoute.of(context)?.settings.arguments
      //                 as Map<String, dynamic>)["slug"],
      //             "posterUrl": (ModalRoute.of(context)?.settings.arguments
      //                 as Map<String, dynamic>)["poster"],
      //             "coverUrl": (ModalRoute.of(context)?.settings.arguments
      //                 as Map<String, dynamic>)["cover_url"],
      //             "tag": (ModalRoute.of(context)?.settings.arguments
      //                 as Map<String, dynamic>)["tag"],
      //             //"title":fetchedData["hentai_video"]["name"],
      //             "title": fetchedData["title"],
      //           };
      //           bool isFavourite = value.favourites.indexWhere(
      //                     (element) => element["slug"] == data["slug"],
      //                   ) ==
      //                   -1
      //               ? false
      //               : true;
      //           return FloatingActionButton(
      //             onPressed: () {
      //               value.toggleFavourites(data: data);
      //             },
      //             backgroundColor: Theme.of(context).colorScheme.onBackground,
      //             child: Icon(
      //               isFavourite
      //                   ? Icons.favorite
      //                   : Icons.favorite_border_outlined,
      //               color: Colors.red,
      //             ),
      //           );
      //         },
      //       ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: fetchedData != null
                      ? FadeInImage(
                          placeholder: MemoryImage(kTransparentImage),
                          image:
                              CachedNetworkImageProvider(fetchedData!["cover"]),
                          fit: BoxFit.cover,
                          fadeInCurve: Curves.easeIn,
                          fadeInDuration: const Duration(milliseconds: 300),
                        )
                      : Image.memory(kTransparentImage),
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 170,
                      child: Card(
                        child: HeroImage(
                          imageUrl: (ModalRoute.of(context)?.settings.arguments
                              as Map<String, dynamic>)["image"],
                          tag: (ModalRoute.of(context)?.settings.arguments
                              as Map<String, dynamic>)["tag"],
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 170,
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 5,
                      ),
                      height: 240,
                      child: fetchedData == null
                          ? Center(
                              child: CircularProgressIndicator(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                            )
                          : InfoPane(
                              rating: fetchedData!["rating"],
                              releaseDate: fetchedData!["releaseDate"],
                              studio: fetchedData!["studios"][0],
                              synonyms: fetchedData!["synonyms"],
                              title: fetchedData!["title"],
                            ),
                    ),
                  ],
                ),
                const Divider(
                  height: 10,
                ),
                if (fetchedData != null) ...[
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.watch_later_outlined),
                            label: const Text("Watchlist"),
                            onPressed: () {},
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor:
                                  fetchedData!["status"] == "Ongoing"
                                      ? Colors.greenAccent[400]
                                      : Colors.redAccent,
                            ),
                            onPressed: () {},
                            child: Text(fetchedData!["status"]),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 6,
                    ),
                    child: Text(
                      "Description",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: const Color.fromRGBO(243, 198, 105, 1),
                          ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 5,
                    ),
                    child: Text(
                      parse(fetchedData!["description"]).body?.text as String,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(fontSize: 14),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(
                    height: 0,
                    thickness: 1,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 10,
                    ),
                    child: Text(
                      "Episodes",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: const Color.fromRGBO(243, 198, 105, 1),
                          ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (fetchedData != null)
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final data = fetchedData!["episodes"][index];
                  return GestureDetector(
                    onTap: () => Navigator.of(context).pushNamed(
                      VideoPlayerScreen.routeName,
                      arguments: {
                        "id": fetchedData!["id"],
                        "episode": data!["number"],
                      },
                    ),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 100,
                      child: Flex(
                        direction: Axis.horizontal,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Card(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: CachedNetworkImage(
                                  imageUrl: data["image"],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  data["airDate"] == null
                                      ? Text(
                                          "Episode ${data["number"]}",
                                        )
                                      : Text(
                                          "E${data["number"]} \u2022 ${data["airDate"].toString().substring(0, 10)}",
                                        ),
                                  data["title"] != null
                                      ? Text(
                                          data["title"],
                                          maxLines: 2,
                                        )
                                      : const Text(
                                          "\n",
                                        ),
                                  data["description"] != null
                                      ? Text(
                                          data["description"],
                                          maxLines: 2,
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelMedium
                                              ?.copyWith(
                                                color: Colors.white60,
                                              ),
                                          overflow: TextOverflow.ellipsis,
                                        )
                                      : const Text(
                                          "\n",
                                        ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                childCount: fetchedData!["episodes"].length,
              ),
            ),
          if (fetchedData != null) ...[
            if (fetchedData!["relations"].length != 0) ...[
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Divider(
                      height: 0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 10,
                      ),
                      child: Text(
                        "Related Media",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: const Color.fromRGBO(243, 198, 105, 1),
                            ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 250,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemExtent: 170,
                        itemBuilder: (context, index) {
                          final data = fetchedData!["relations"][index];
                          return SizedBox(
                            child: Stack(
                              children: [
                                RowItem(
                                  title: data["title"],
                                  tag: data["id"].toString(),
                                  image: data["image"],
                                  id: data["id"].toString(),
                                  disabled: data["episodes"] == null,
                                ),
                                Positioned(
                                  top: 20,
                                  right: 4,
                                  child: FittedBox(
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.horizontal(
                                          left: Radius.circular(5),
                                        ),
                                        color: Colors.red,
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 5,
                                        vertical: 3,
                                      ),
                                      child: Text(
                                        data["relationType"][0] +
                                            data["relationType"]
                                                .toString()
                                                .toLowerCase()
                                                .substring(1),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        itemCount: fetchedData!["relations"].length,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ]
        ],
      ),
    );
  }
}
