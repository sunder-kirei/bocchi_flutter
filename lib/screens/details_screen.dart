import 'package:anime_api/helpers/custom_route.dart';
import 'package:anime_api/providers/user_preferences.dart';
import 'package:anime_api/screens/video_player_screen.dart';
import 'package:anime_api/widgets/custom_tile.dart';
import 'package:anime_api/widgets/row_item.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

import '../helpers/http_helper.dart';
import '../widgets/bocchi_rich_text.dart';
import '../widgets/hero_image.dart';
import '../widgets/info_pane.dart';

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
      malID: (int.parse(
        (ModalRoute.of(context)?.settings.arguments
            as Map<String, dynamic>)["id"],
      )),
    ).then(
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
        title: const BocchiRichText(
          fontSize: 20,
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: fetchedData != null
                      ? Stack(
                          children: [
                            Positioned.fill(
                              child: FadeInImage(
                                placeholder: MemoryImage(kTransparentImage),
                                image: CachedNetworkImageProvider(
                                  fetchedData!["cover"],
                                ),
                                fit: BoxFit.cover,
                                fadeInCurve: Curves.easeIn,
                                fadeInDuration:
                                    const Duration(milliseconds: 300),
                              ),
                            ),
                            if (fetchedData!["episodes"].length != 0)
                              Positioned.fill(
                                child: Material(
                                  color: Colors.transparent,
                                  child: IconButton(
                                    icon: const Icon(Icons.play_arrow_rounded),
                                    onPressed: () {
                                      final data = fetchedData!["episodes"][0];
                                      Navigator.of(context).push(
                                        CustomRoute(
                                          builder: (context) =>
                                              VideoPlayerScreen(
                                            details: fetchedData!["episodes"],
                                            episode: data["number"],
                                            image: fetchedData!["image"],
                                            id: fetchedData!["id"],
                                          ),
                                        ),
                                      );
                                    },
                                    iconSize: 80,
                                    splashRadius: 50,
                                  ),
                                ),
                              )
                          ],
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
                              rating: fetchedData!["rating"] ?? 0,
                              releaseDate: fetchedData!["releaseDate"] ?? 0,
                              studio: fetchedData!["studios"].length != 0
                                  ? fetchedData!["studios"][0]
                                  : "Unknown",
                              synonyms: fetchedData!["synonyms"] ?? "Unknown",
                              title: fetchedData!["title"] ?? "Unknown",
                            ),
                    ),
                  ],
                ),
                const Divider(
                  height: 10,
                ),
                if (fetchedData != null) ...[
                  Buttons(fetchedData: fetchedData),
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
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                  ),
                  if (fetchedData!["description"] != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 5,
                      ),
                      child: Text(
                        parse(fetchedData!["description"]).body?.text as String,
                        maxLines: 10,
                        overflow: TextOverflow.ellipsis,
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
                  if (fetchedData!["episodes"].length != 0)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 10,
                      ),
                      child: Text(
                        "Episodes",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
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
                  return InkWell(
                    onTap: () => Navigator.of(context).push(
                      CustomRoute(
                        builder: (context) => VideoPlayerScreen(
                          details: fetchedData!["episodes"],
                          episode: data["number"],
                          image: fetchedData!["image"],
                          id: fetchedData!["id"],
                        ),
                      ),
                    ),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 100,
                      child: CustomTile(
                        image: data["image"],
                        episodeNumber: data["number"],
                        airDate: data["airDate"],
                        description: data["description"],
                        key: ValueKey(data["number"]),
                        title: data["title"],
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
                    const SizedBox(
                      height: 10,
                    ),
                    const Divider(
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
                              color: Theme.of(context).colorScheme.primary,
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
                                      padding: const EdgeInsets.symmetric(
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
            if (fetchedData!["recommendations"].length != 0) ...[
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    const Divider(
                      height: 0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 10,
                      ),
                      child: Text(
                        "Recommendations",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
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
                          final data = fetchedData!["recommendations"][index];
                          return SizedBox(
                            child: Stack(
                              children: [
                                RowItem(
                                  title: data["title"],
                                  tag: data["id"].toString(),
                                  image: data["image"],
                                  id: data["id"].toString(),
                                  disabled: (data["status"]
                                                  .toString()
                                                  .toLowerCase() ==
                                              "not yet aired" ||
                                          data["malId"] == null) ||
                                      data["episodes"] == null,
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
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 5,
                                        vertical: 3,
                                      ),
                                      child: Text(
                                        data["type"],
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
                        itemCount: fetchedData!["recommendations"].length,
                      ),
                    ),
                  ],
                ),
              ),
            ]
          ]
        ],
      ),
    );
  }
}

class Buttons extends StatelessWidget {
  const Buttons({
    Key? key,
    required this.fetchedData,
  }) : super(key: key);

  final Map<String, dynamic>? fetchedData;

  @override
  Widget build(BuildContext context) {
    final isPresent = !(Provider.of<Watchlist>(context).getWatchlist.indexWhere(
              (element) => element["id"] == fetchedData!["id"],
            ) ==
        -1);
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: OutlinedButton.icon(
              icon: isPresent
                  ? const Icon(Icons.done)
                  : const Icon(Icons.watch_later_outlined),
              label: isPresent
                  ? const Text("On Watchlist")
                  : const Text("Watchlist"),
              onPressed: () async {
                await Provider.of<Watchlist>(
                  context,
                  listen: false,
                ).toggle(
                  id: fetchedData!["id"],
                  titleRomaji: fetchedData!["title"]["romaji"],
                  image: fetchedData!["image"],
                );
              },
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: fetchedData!["status"] == "Ongoing"
                    ? Colors.greenAccent[400]
                    : Colors.redAccent,
              ),
              onPressed: () {},
              child: Text(fetchedData!["status"]),
            ),
          ),
        ),
      ],
    );
  }
}
