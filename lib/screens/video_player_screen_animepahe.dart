import 'dart:convert';

import 'package:anime_api/helpers/http_helper.dart';
import 'package:anime_api/providers/user_preferences.dart';
import 'package:anime_api/widgets/custom_player.dart';
import 'package:anime_api/widgets/custom_tile.dart';
import 'package:anime_api/widgets/hero_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String id;
  final String image;
  final int episode;
  final List<dynamic> details;
  final int position;
  final String title;
  const VideoPlayerScreen({
    super.key,
    required this.id,
    required this.image,
    required this.episode,
    required this.details,
    this.position = 0,
    required this.title,
  });
  static const routeName = "/watch";

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  final ScrollController _controller = ScrollController();
  List<dynamic>? videoSources;
  int? currentEpisode;
  bool isLoading = true;

  Future<void> getEpisode({
    int episode = 1,
    required Stream provider,
  }) async {
    Provider.of<Watchlist>(
      context,
      listen: false,
    ).addToHistory(
      episode: episode,
      image: widget.image,
      episodeImage: widget.details[episode - 1]["image"],
      itemId: widget.id,
      details: json.encode(widget.details),
      position: 0,
    );
    setState(() {
      isLoading = true;
    });
    scrollToEpisode(
      episode: currentEpisode!,
      duration: const Duration(milliseconds: 300),
    );
    final response = await HttpHelper.getVideo(
      episodeID: widget.details[episode - 1]["id"],
      provider: provider,
    );
    setState(() {
      videoSources = response["sources"];
      isLoading = false;
    });
  }

  void scrollToEpisode({
    int episode = 1,
    Duration duration = Duration.zero,
  }) {
    _controller.animateTo(
      100 * (episode - 1),
      duration: duration == Duration.zero
          ? Duration(
              milliseconds: ((episode) * 60),
            )
          : duration,
      curve: Curves.easeOut,
    );
  }

  Future<void> callback({required int? position}) async {
    int episode = currentEpisode ?? 1;
    await Provider.of<Watchlist>(
      context,
      listen: false,
    ).addToHistory(
      episode: episode,
      image: widget.image,
      episodeImage: widget.details[episode - 1]["image"],
      itemId: widget.id,
      details: json.encode(widget.details),
      position: position ?? 0,
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    setState(() {
      currentEpisode = widget.episode;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToEpisode(episode: currentEpisode!);
    });
    getEpisode(
      provider: Stream.animepahe,
      episode: currentEpisode!,
    );
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Flex(
          direction: Axis.vertical,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: isLoading == false && videoSources != null
                      ? CustomPlayer(
                          streams: videoSources!,
                          callback: callback,
                          initialPosition: widget.position,
                        )
                      : Container(
                          color: Theme.of(context).colorScheme.surface,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                          ),
                        ),
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  height: 140,
                  child: Flex(
                    direction: Axis.horizontal,
                    children: [
                      HeroImage(
                        imageUrl: widget.image,
                        tag: widget.id,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Currently Watching",
                              style: Theme.of(context).textTheme.caption,
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Text(
                              widget.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Episode",
                              style: Theme.of(context).textTheme.caption,
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Text(
                              currentEpisode.toString(),
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                "Up Next",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(
              height: 6,
            ),
            Flexible(
              child: ListView.builder(
                controller: _controller,
                itemBuilder: (context, index) {
                  final data = widget.details[index];
                  return InkWell(
                    onTap: () {
                      getEpisode(
                        episode: data["number"],
                        provider: Stream.animepahe,
                      );
                    },
                    child: Container(
                      color: data["number"] == currentEpisode
                          ? Theme.of(context).colorScheme.background
                          : null,
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
                itemCount: widget.details.length,
              ),
            )
          ],
        ),
      ),
    );
  }
}
