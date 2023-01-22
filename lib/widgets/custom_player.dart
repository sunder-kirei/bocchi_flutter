import "dart:convert";

import 'package:chewie/chewie.dart';
import '../helpers/http_helper.dart';
import '../providers/user_preferences.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class CustomPlayer extends StatefulWidget {
  final List<dynamic> streams;
  // final List<dynamic> subtitles;
  const CustomPlayer({
    super.key,
    required this.streams,
    // required this.subtitles,
  });

  @override
  State<CustomPlayer> createState() => _CustomPlayerState();
}

class _CustomPlayerState extends State<CustomPlayer> {
  int? quality;
  bool hasLoaded = false;

  VideoPlayerController? _videoPlayerController;
  ChewieController? _controller;

  @override
  void initState() {
    initPlayer(
      index: 0,
    );
    super.initState();
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _controller?.dispose();
    super.dispose();
  }

  Future<void> toggleQuality(int index) async {
    _videoPlayerController?.pause();
    final position = await _controller?.videoPlayerController.position;
    setState(() {
      hasLoaded = false;
    });
    initPlayer(index: index, position: position!);
    return;
  }

  void initPlayer({
    Duration position = Duration.zero,
    required int index,
  }) async {
    setState(() {
      quality = index;
    });
    final url = Uri.parse(widget.streams[0]["url"]);
    print(url);
    _videoPlayerController = VideoPlayerController.contentUri(url);

    await _videoPlayerController!.initialize();

    _controller = customChewieController(
      streams: widget.streams,
      position: position,
    );

    setState(() {
      hasLoaded = true;
    });
  }

  ChewieController customChewieController({
    Duration position = Duration.zero,
    required List<dynamic> streams,
  }) {
    return ChewieController(
      // subtitle: Subtitles(
      //   [
      //     Subtitle(
      //       text: widget.subtitles[0],
      //       index: 0,
      //       start: Duration.zero,
      //       end: Duration(
      //         minutes: 20,
      //       ),
      //     ),
      //   ],
      // ),
      videoPlayerController: _videoPlayerController!,
      showControlsOnInitialize: true,
      deviceOrientationsAfterFullScreen: [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
      startAt: position,
      aspectRatio: 16 / 9,
      materialProgressColors: ChewieProgressColors(
        backgroundColor: Colors.grey[900] as Color,
        bufferedColor: Colors.grey[300] as Color,
        handleColor: const Color.fromRGBO(243, 198, 105, 1),
        playedColor: const Color.fromRGBO(243, 198, 105, 1),
      ),
      additionalOptions: (context) => [
        OptionItem(
          onTap: () {
            Navigator.of(context).pop();
            showModalBottomSheet(
              context: context,
              builder: (context) => SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ...(streams).asMap().entries.map((item) {
                      int index = item.key;
                      dynamic height = item.value["quality"];
                      return ListTile(
                        leading: Icon(
                          Icons.check_rounded,
                          color: quality == index
                              ? Theme.of(context).colorScheme.onBackground
                              : Colors.transparent,
                        ),
                        title: Text(height + 'p'),
                        onTap: () {
                          toggleQuality(index);
                          Navigator.of(context).pop();
                        },
                        trailing: height == "1080" || height == "720"
                            ? Icon(
                                Icons.hd_outlined,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onBackground,
                              )
                            : null,
                      );
                    }),
                  ],
                ),
              ),
            );
          },
          iconData: Icons.settings,
          title: "Quality",
          subtitle: "${streams[quality!]["quality"]}p",
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return hasLoaded
        ? Chewie(controller: _controller!)
        : Container(
            color: Theme.of(context).colorScheme.surface,
            child: Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
          );
  }
}
