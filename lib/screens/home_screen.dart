import 'dart:convert';

import 'package:anime_api/providers/user_preferences.dart';
import 'package:anime_api/screens/search_screen.dart';
import 'package:anime_api/screens/video_player_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';

import '../helpers/custom_route.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/bocchi_rich_text.dart';
import '../widgets/row_item.dart';
import '../widgets/search_button.dart';
import 'package:flutter/material.dart';

import '../helpers/http_helper.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/row_sliver.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = "/";

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Flex(
        direction: Axis.horizontal,
        mainAxisSize: MainAxisSize.max,
        children: [
          NavigationRail(
            onDestinationSelected: (value) {
              setState(() {
                currentIndex = value;
              });
            },
            extended: true,
            leading: Column(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage("assets/branding.jpg"),
                  radius: 30,
                ),
                SizedBox(
                  height: 10,
                ),
                BocchiRichText(fontSize: 16),
                Divider(
                  height: 0,
                  thickness: 1,
                ),
              ],
            ),
            minExtendedWidth: 200,
            destinations: [
              NavigationRailDestination(
                icon: Icon(Icons.home_rounded),
                label: Text("Home"),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.search_rounded),
                label: Text("Search"),
              ),
            ],
            selectedIndex: currentIndex,
          ),
          Flexible(
            child: currentIndex == 0
                ? CustomScrollView(
                    slivers: [
                      CustomAppBar(
                        image: Image.asset(
                          "assets/landing.jpg",
                          fit: BoxFit.cover,
                          alignment: Alignment.centerRight,
                        ),
                        title: const BocchiRichText(fontSize: 20),
                      ),
                      if (Provider.of<Watchlist>(context)
                          .getHistory
                          .isNotEmpty) ...[
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 5.0,
                              top: 10,
                              bottom: 5,
                            ),
                            child: Text(
                              "Continue Watching",
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Container(
                            height: 120,
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: ListView.separated(
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                width: 5,
                              ),
                              itemBuilder: (context, index) {
                                final data = Provider.of<Watchlist>(context)
                                    .getHistory
                                    .reversed
                                    .toList()[index];
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: AspectRatio(
                                    aspectRatio: 16 / 9,
                                    child: Stack(
                                      children: [
                                        Positioned.fill(
                                          child: GridTile(
                                            footer: Container(
                                              color: Colors.black,
                                              child: Text(
                                                "Episode ${data["episode"]}",
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            child: CachedNetworkImage(
                                              imageUrl: data["episodeImage"],
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Positioned.fill(
                                          child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.of(context).push(
                                                  CustomRoute(
                                                    builder: (context) =>
                                                        VideoPlayerScreen(
                                                      id: data["id"],
                                                      image: data["image"],
                                                      episode: data["episode"],
                                                      details: json.decode(
                                                          data["details"]),
                                                      position:
                                                          data["position"],
                                                      //Uncomment this is using video_player_screen_animepahe.dart file"
                                                      // title: data["title"]["romaji"],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                              itemCount: Provider.of<Watchlist>(context)
                                  .getHistory
                                  .length,
                              scrollDirection: Axis.horizontal,
                            ),
                          ),
                        )
                      ],
                      if (Provider.of<Watchlist>(context)
                          .getWatchlist
                          .isNotEmpty) ...[
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 5.0,
                              top: 10,
                              bottom: 5,
                            ),
                            child: Text(
                              "Your Watchlist",
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: SizedBox(
                            height: 250,
                            child: ListView.builder(
                              itemBuilder: (context, index) {
                                final data = Provider.of<Watchlist>(
                                  context,
                                ).getWatchlist[index];
                                return RowItem(
                                  id: data["id"],
                                  image: data["image"],
                                  title: {
                                    "romaji": data["romaji"],
                                  },
                                  tag: "watchlist${data["id"]}",
                                );
                              },
                              itemCount: Provider.of<Watchlist>(context)
                                  .getWatchlist
                                  .length,
                              scrollDirection: Axis.horizontal,
                              itemExtent: 170,
                            ),
                          ),
                        ),
                      ],
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 5.0,
                            top: 10,
                            bottom: 5,
                          ),
                          child: Text(
                            "Recent Uploads",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                      ),
                      const RowSliver(
                        option: GetLanding.recent_episodes,
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 5.0,
                            top: 10,
                            bottom: 5,
                          ),
                          child: Text(
                            "Trending",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                      ),
                      const RowSliver(
                        option: GetLanding.trending,
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 5.0,
                            top: 10,
                            bottom: 5,
                          ),
                          child: Text(
                            "Popular",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                      ),
                      const RowSliver(
                        option: GetLanding.popular,
                      ),
                    ],
                  )
                : SearchScreen(),
          ),
        ],
      ),
    );
  }
}
