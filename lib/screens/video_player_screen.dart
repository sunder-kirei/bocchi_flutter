import 'dart:convert';
import 'dart:math';

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
  const VideoPlayerScreen({
    super.key,
    required this.id,
    required this.image,
    required this.episode,
    required this.details,
    this.position = 0,
  });
  static const routeName = "/watch";

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  final ScrollController _controller = ScrollController();
  Map<String, dynamic>? fetchedData;
  List<dynamic>? localDetail;
  List<dynamic>? videoSources;
  int? currentEpisode;
  bool isLoading = true;

  void fetchDetails() {
    HttpHelper.getInfo(
      malID: int.parse(widget.id),
      provider: Stream.gogoanime,
    ).then((value) {
      setState(() {
        localDetail = value["episodes"];
      });
    });
  }

  Future<void> getStreamInfo({required Stream provider}) async {
    final response = await HttpHelper.getInfo(
      malID: int.parse(widget.id),
      provider: provider,
    );
    setState(() {
      fetchedData = response;
    });

    if (fetchedData!["episodes"].length != widget.details) fetchDetails();

    await getEpisode(
      episode: currentEpisode!,
      position: widget.position,
    );
  }

  Future<void> getEpisode({
    int episode = 1,
    required int position,
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
      position: position,
    );
    setState(() {
      isLoading = true;
      currentEpisode = episode;
    });
    if (_controller.hasClients) {
      scrollToEpisode(
        episode: currentEpisode!,
        duration: const Duration(milliseconds: 300),
      );
    }
    final response = await HttpHelper.getVideo(
      episodeID: fetchedData!["episodes"][episode - 1]["id"],
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
    double position = 100 * (episode - 1);
    if (episode * 60 > 3000) {
      _controller.jumpTo(min(position, _controller.position.maxScrollExtent));
    }
    _controller.animateTo(
      min(position, _controller.position.maxScrollExtent),
      duration: duration == Duration.zero
          ? Duration(
              milliseconds: min(3000, ((episode) * 60)),
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
      details: localDetail == null
          ? json.encode(widget.details)
          : json.encode(localDetail),
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
    getStreamInfo(provider: Stream.animepahe);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    int currentLength =
        localDetail == null ? widget.details.length : localDetail!.length;
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
                          initialPosition: currentEpisode == widget.episode
                              ? widget.position
                              : 0,
                          nextEpisode: () {
                            getEpisode(
                              episode: currentEpisode == currentLength
                                  ? currentLength + 1
                                  : currentEpisode! + 1,
                              position: 0,
                            );
                          },
                          isLast: currentEpisode == currentLength,
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
                      if (fetchedData != null)
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
                                fetchedData!["title"]["romaji"],
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
                  final data = localDetail == null
                      ? widget.details[index]
                      : localDetail![index];
                  return InkWell(
                    onTap: () {
                      if (data["number"] == currentEpisode) return;
                      getEpisode(
                        episode: data["number"],
                        position: 0,
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
                itemCount: localDetail == null
                    ? widget.details.length
                    : localDetail!.length,
              ),
            )
          ],
        ),
      ),
    );
  }
}
