import 'dart:convert';

import 'package:anime_api/helpers/http_helper.dart';
import 'package:anime_api/providers/user_preferences.dart';
import 'package:anime_api/widgets/custom_player.dart';
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

    final response = await HttpHelper.getVideo(
      episodeID: fetchedData!["episodes"][episode - 1]["id"],
    );
    setState(() {
      videoSources = response["sources"];
      isLoading = false;
    });
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
    getStreamInfo(provider: Stream.animepahe);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    int currentLength =
        localDetail == null ? widget.details.length : localDetail!.length;
    return Scaffold(
      body: SafeArea(
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: isLoading == false && videoSources != null
              ? CustomPlayer(
                  streams: videoSources!,
                  callback: callback,
                  initialPosition:
                      currentEpisode == widget.episode ? widget.position : 0,
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
      ),
    );
  }
}
