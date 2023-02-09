import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:html/parser.dart';
import 'package:provider/provider.dart';

import '../helpers/custom_route.dart';
import '../helpers/http_helper.dart';
import '../screens/video_player_screen.dart';
import '../providers/user_preferences.dart';
import '../widgets/row_item.dart';
import '../widgets/custom_tile.dart';
import '../widgets/hero_image.dart';
import '../widgets/info_pane.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key});
  static const routeName = "/details";

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen>
    with TickerProviderStateMixin {
  Map<String, dynamic>? fetchedData;
  late final AnimationController _animationController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 500))
    ..forward();
  late final Animation<double> _animation = CurvedAnimation(
    parent: _animationController,
    curve: Curves.easeInCubic,
  );

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

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
    final history = Provider.of<Watchlist>(context).getHistory;
    int index = -1;
    bool isPresent = false;
    if (fetchedData != null) {
      index = history.indexWhere((item) => item["id"] == fetchedData!["id"]);
      isPresent = !(Provider.of<Watchlist>(context).getWatchlist.indexWhere(
                (element) => element["id"] == fetchedData!["id"],
              ) ==
          -1);
    }
    return Scaffold(
      floatingActionButton: fetchedData != null
          ? FloatingActionButton(
              onPressed: () async {
                await Provider.of<Watchlist>(
                  context,
                  listen: false,
                ).toggle(
                  id: fetchedData!["id"],
                  title: json.encode(fetchedData!["title"]),
                  image: fetchedData!["image"],
                );
              },
              tooltip: "Add to watchlist",
              child: isPresent
                  ? const Icon(
                      Icons.done_rounded,
                    )
                  : const Icon(
                      Icons.history_outlined,
                    ),
            )
          : null,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).size.height * 0.4,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  Positioned.fill(
                    child: HeroImage(
                      imageUrl: (ModalRoute.of(context)?.settings.arguments
                          as Map<String, dynamic>)["image"],
                      tag: (ModalRoute.of(context)?.settings.arguments
                          as Map<String, dynamic>)["tag"],
                    ),
                  ),
                  Positioned.fill(
                    child: FadeTransition(
                      opacity: _animation,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context)
                                  .scaffoldBackgroundColor
                                  .withOpacity(0.3),
                              Theme.of(context).scaffoldBackgroundColor
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (fetchedData != null)
                    Positioned(
                      bottom: 0,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: InfoPane(
                          status: fetchedData!["status"],
                          episodes: fetchedData!["totalEpisodes"].toString(),
                          season: fetchedData!["season"],
                          genres: fetchedData!["genres"],
                          releaseDate: fetchedData!["releaseDate"] ?? 0,
                          title: fetchedData!["title"] ?? "Unknown",
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Flex(
              direction: Axis.vertical,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                const SizedBox(
                  height: 30,
                ),
                if (fetchedData == null)
                  Center(
                    child: SpinKitFoldingCube(
                      color: Theme.of(context).colorScheme.primary,
                      size: 50,
                    ),
                  ),
                if (fetchedData != null) ...[
                  ElevatedButton(
                    onPressed: () {
                      final data = fetchedData!["episodes"][0];
                      Navigator.of(context).push(
                        CustomRoute(
                          builder: (context) {
                            return VideoPlayerScreen(
                              details: fetchedData!["episodes"],
                              episode: index != -1
                                  ? history[index]["episode"]
                                  : data["number"],
                              image: fetchedData!["image"],
                              id: fetchedData!["id"],
                              position:
                                  index != -1 ? history[index]["position"] : 0,
                            );
                          },
                        ),
                      );
                    },
                    child: Text(
                      index != -1
                          ? "Continue Watching \u2022 E${history[index]["episode"]}"
                          : "Start Watching",
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  if (fetchedData!["description"] != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                      ),
                      child: RichText(
                        maxLines: 15,
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          text: "Overview: ",
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Colors.amber,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 13,
                                  ),
                          children: [
                            TextSpan(
                              text: parse(fetchedData!["description"])
                                  .body
                                  ?.text as String,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: Colors.grey,
                                    fontSize: 13,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (fetchedData!["episodes"].length != 0)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 10,
                      ),
                      child: Text(
                        "Episodes",
                        style:
                            Theme.of(context).textTheme.displayLarge?.copyWith(
                                  fontSize: 24,
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
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 10,
                      ),
                      child: Text(
                        "Related Media",
                        style:
                            Theme.of(context).textTheme.displayLarge?.copyWith(
                                  fontSize: 24,
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
                                  disabled: data["episodes"] == null ||
                                      data["malId"] == null,
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
                                            .titleMedium,
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
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 10,
                      ),
                      child: Text(
                        "Recommendations",
                        style:
                            Theme.of(context).textTheme.displayLarge?.copyWith(
                                  fontSize: 24,
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
                                            .titleMedium,
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
