import 'package:anime_api/helpers/http_helper.dart';
import 'package:anime_api/widgets/custom_player.dart';
import 'package:anime_api/widgets/hero_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key});
  static const routeName = "/watch";

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  ScrollController _controller = ScrollController();
  Map<String, dynamic>? fetchedData;
  List<dynamic>? details;
  List<dynamic>? videoSources;
  int? currentEpisode;
  bool isLoading = true;

  Future<void> getStreamInfo({required Stream provider}) async {
    final response = await HttpHelper.getInfo(
      malID: int.parse(
        (ModalRoute.of(context)!.settings.arguments
            as Map<String, dynamic>)["id"],
      ),
      provider: provider,
    );
    setState(() {
      fetchedData = response;
    });

    await getEpisode(
      episode: currentEpisode!,
      provider: provider,
    );
  }

  Future<void> getEpisode({int episode = 1, required Stream provider}) async {
    setState(() {
      isLoading = true;
      currentEpisode = episode;
    });
    final response = await HttpHelper.getVideo(
      episodeID: fetchedData!["episodes"][episode - 1]["id"],
      provider: provider,
    );
    setState(() {
      videoSources = response["sources"];
      // subtitles = response["subtitles"];
      isLoading = false;
    });
  }

  void scrollToEpisode({int episode = 1}) {
    _controller.animateTo(
      100 * (episode - 1),
      duration: Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    setState(() {
      currentEpisode = (ModalRoute.of(context)!.settings.arguments
          as Map<String, dynamic>)["episode"];
      details = (ModalRoute.of(context)!.settings.arguments
          as Map<String, dynamic>)["details"];
    });
    getStreamInfo(provider: Stream.animepahe);
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
                          // subtitles: subtitles!,
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
                        imageUrl: (ModalRoute.of(context)!.settings.arguments
                            as Map<String, dynamic>)["image"],
                        tag: (ModalRoute.of(context)!.settings.arguments
                            as Map<String, dynamic>)["id"],
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      if (fetchedData != null)
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Currently Watching",
                                style: Theme.of(context).textTheme.caption,
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Text(
                                fetchedData!["title"]["romaji"],
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Episode",
                                style: Theme.of(context).textTheme.caption,
                              ),
                              SizedBox(
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
                Divider(),
              ],
            ),
            // if (details != null) ...[
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                "Up Next",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            SizedBox(
              height: 6,
            ),
            Flexible(
              child: ListView.builder(
                controller: _controller,
                itemBuilder: (context, index) {
                  // final data = fetchedData!["episodes"][index];
                  final data = details![index];
                  return InkWell(
                    onTap: () {
                      getEpisode(
                        episode: data["number"],
                        provider: Stream.animepahe,
                      );
                    },
                    child: Container(
                      color: data["number"] == currentEpisode
                          ? Colors.white12
                          : null,
                      width: MediaQuery.of(context).size.width,
                      height: 100,
                      child: Flex(
                        key: ValueKey(data["number"]),
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
                itemCount: details!.length,
              ),
            ),
            // ],
          ],
        ),
      ),
    );
  }
}
