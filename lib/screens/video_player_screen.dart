import 'dart:convert';
import 'dart:math';

import 'package:anime_api/constants/app_colors.dart';
import 'package:anime_api/helpers/http_helper.dart';
import 'package:anime_api/providers/user_preferences.dart';
import 'package:anime_api/screens/details_screen.dart';
import 'package:anime_api/widgets/custom_player.dart';
import 'package:anime_api/widgets/custom_tile.dart';
import 'package:anime_api/widgets/hero_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String id;
  final String image;
  final int episode;
  final List<dynamic> gogoDetails;
  final int position;
  final Map<String, dynamic> title;
  final int releasedYear;
  final String? season;
  const VideoPlayerScreen({
    super.key,
    required this.id,
    required this.image,
    required this.episode,
    required this.gogoDetails,
    this.position = 0,
    required this.title,
    required this.releasedYear,
    this.season,
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
  Map<String, dynamic>? animepaheData;
  bool hasError = false;

  Future<void> fetchEpisodeList() async {
    try {
      final result = await HttpHelper.getEpisodeList(
        title: widget.title["romaji"] ?? "",
        releasedYear: widget.releasedYear,
        season: widget.season,
        page: (currentEpisode! / 30).ceil(),
      );
      setState(() {
        animepaheData = result;
      });
      getEpisode(
        episode: currentEpisode!,
        position: widget.position,
      );
    } catch (err) {
      setState(() {
        hasError = true;
      });
    }
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
      itemId: widget.id,
      title: json.encode(widget.title),
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
    try {
      final response = await HttpHelper.getVideoSources(
        episodeID: animepaheData!["episodes"][(episode - 1) % 30]["episodeId"],
        animeId: animepaheData!["animeId"],
      );
      setState(() {
        videoSources = response;
        isLoading = false;
      });
    } catch (err) {
      setState(() {
        hasError = true;
      });
    }
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
      itemId: widget.id,
      title: json.encode(widget.title),
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
    fetchEpisodeList();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    int currentLength = widget.gogoDetails.length;
    final prefferedTitle =
        Provider.of<Watchlist>(context, listen: false).prefferedTitle;
    PrefferedTitle subtitle;
    if (prefferedTitle == PrefferedTitle.english) {
      subtitle = PrefferedTitle.romaji;
    } else {
      subtitle = PrefferedTitle.english;
    }
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
                  child: hasError
                      ? Center(
                          child: Text(
                            "Sorry, Anime not found????",
                            style: Theme.of(context).textTheme.displayLarge,
                          ),
                        )
                      : animepaheData == null
                          ? SpinKitRipple(
                              color: Theme.of(context).colorScheme.primary)
                          : isLoading == false && videoSources != null
                              ? CustomPlayer(
                                  streams: videoSources!,
                                  callback: callback,
                                  initialPosition:
                                      currentEpisode == widget.episode
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
                                    child: SpinKitWave(
                                      color:
                                          Theme.of(context).colorScheme.primary,
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
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            DetailsScreen.routeName,
                            (route) {
                              return route.isFirst;
                            },
                            arguments: {
                              "id": widget.id,
                              "image": widget.image,
                              "tag": widget.id,
                            },
                          );
                        },
                        child: HeroImage(
                          imageUrl: widget.image,
                          tag: widget.id,
                        ),
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
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Text(
                              widget.title[prefferedTitle.name] ??
                                  widget.title[subtitle.name],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .displayLarge
                                  ?.copyWith(
                                    fontSize: 15,
                                  ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Episode",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Text(
                              currentEpisode.toString(),
                              style: Theme.of(context).textTheme.displayLarge,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                "Up Next",
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: 24,
                    ),
              ),
            ),
            const SizedBox(
              height: 6,
            ),
            Flexible(
              child: ListView.builder(
                controller: _controller,
                itemBuilder: (context, index) {
                  final data = widget.gogoDetails[index];

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
                          ? AppColors.grey
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
                itemCount: widget.gogoDetails.length,
              ),
            )
          ],
        ),
      ),
    );
  }
}
