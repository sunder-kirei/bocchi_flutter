import 'package:anime_api/helpers/db_helper.dart';
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
                              studio: fetchedData!["studios"].length != 0
                                  ? fetchedData!["studios"][0]
                                  : "Unknown",
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
                  return InkWell(
                    onTap: () => Navigator.of(context).pushNamed(
                      VideoPlayerScreen.routeName,
                      arguments: {
                        "id": fetchedData!["id"],
                        "image": fetchedData!["image"],
                        "episode": data!["number"],
                        "details": fetchedData!["episodes"],
                      },
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
            if (fetchedData!["recommendations"].length != 0) ...[
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
                        "Recommendations",
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
                          final data = fetchedData!["recommendations"][index];
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
                  ? Icon(Icons.done)
                  : Icon(Icons.watch_later_outlined),
              label: isPresent
                  ? const Text("On Watchlist")
                  : const Text("Watchlist"),
              onPressed: () async {
                await Provider.of<Watchlist>(
                  context,
                  listen: false,
                ).addToWatchlist(
                  id: fetchedData!["id"],
                  titleRomaji: fetchedData!["title"]["romaji"],
                  image: fetchedData!["image"],
                );
                print(Provider.of<Watchlist>(
                  context,
                  listen: false,
                ).getWatchlist);
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
