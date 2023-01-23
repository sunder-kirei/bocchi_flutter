import 'package:anime_api/providers/user_preferences.dart';
import 'package:anime_api/screens/video_player_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';

import '../widgets/custom_drawer.dart';
import '../widgets/bocchi_rich_text.dart';
import '../widgets/row_item.dart';
import '../widgets/search_button.dart';
import 'package:flutter/material.dart';

import '../helpers/http_helper.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/row_sliver.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = "/";

  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: const SearchButton(),
      drawer: const CustomDrawer(),
      body: CustomScrollView(
        slivers: [
          CustomAppBar(
            image: Image.asset(
              "assets/landing.jpg",
              fit: BoxFit.cover,
              alignment: Alignment.centerRight,
            ),
            title: const BocchiRichText(fontSize: 20),
          ),
          if (Provider.of<Watchlist>(context).getHistory.isNotEmpty) ...[
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
              child: SizedBox(
                height: 120,
                child: ListView.separated(
                  separatorBuilder: (context, index) => SizedBox(
                    width: 10,
                  ),
                  itemBuilder: (context, index) {
                    final data =
                        Provider.of<Watchlist>(context).getHistory[index];
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
                                    Navigator.of(context).pushNamed(
                                      VideoPlayerScreen.routeName,
                                      arguments: {
                                        
                                      },
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
                  itemCount: Provider.of<Watchlist>(context).getHistory.length,
                  scrollDirection: Axis.horizontal,
                  reverse: true,
                ),
              ),
            )
          ],
          if (Provider.of<Watchlist>(context).getWatchlist.isNotEmpty) ...[
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
                  itemCount:
                      Provider.of<Watchlist>(context).getWatchlist.length,
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
      ),
    );
  }
}
