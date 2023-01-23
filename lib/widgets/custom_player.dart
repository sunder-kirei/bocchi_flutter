import "dart:convert";
import 'dart:ffi';

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
    var streams = widget.streams;

    streams = streams.map((item) {
      return {
        ...item,
        "url":
            "${item["url"].toString().substring(0, 15)}files${item["url"].toString().substring(20)}",
      };
    }).toList();

    final url = Uri.parse(streams[quality!]["url"]);

    _videoPlayerController = VideoPlayerController.contentUri(url);

    await _videoPlayerController!.initialize();

    _controller = customChewieController(
      streams: streams,
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
      videoPlayerController: _videoPlayerController!,
      showControlsOnInitialize: true,
      // autoPlay: true,
      deviceOrientationsAfterFullScreen: [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
      deviceOrientationsOnEnterFullScreen: [
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ],
      zoomAndPan: true,
      startAt: position,
      maxScale: 2,
      aspectRatio: 16 / 9,
      materialProgressColors: ChewieProgressColors(
        backgroundColor: Colors.grey[900] as Color,
        bufferedColor: Colors.grey[300] as Color,
        handleColor: Theme.of(context).colorScheme.primary,
        playedColor: Theme.of(context).colorScheme.primary,
      ),
      customControls: LayoutBuilder(
        builder: (context, constraints) => Stack(
          children: [
            Positioned.fill(
              child: MaterialControls(
                showPlayButton: true,
              ),
            ),
            Positioned(
              left: constraints.maxWidth / 4,
              top: constraints.maxHeight / 2 - 25,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Material(
                  color: Colors.transparent,
                  child: IconButton(
                    tooltip: "Rewind",
                    icon: const Icon(Icons.keyboard_double_arrow_left_rounded),
                    onPressed: () async {
                      final position =
                          await _controller!.videoPlayerController.position;
                      final seekTo = position!.inSeconds - 10;
                      _controller!.seekTo(
                        Duration(
                          seconds: seekTo,
                        ),
                      );
                      return;
                    },
                  ),
                ),
              ),
            ),
            Positioned(
              right: constraints.maxWidth / 4,
              top: constraints.maxHeight / 2 - 25,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Material(
                  color: Colors.transparent,
                  child: IconButton(
                    tooltip: "Seek",
                    icon: const Icon(Icons.keyboard_double_arrow_right_rounded),
                    onPressed: () async {
                      final position =
                          await _controller!.videoPlayerController.position;
                      final seekTo = position!.inSeconds + 10;
                      _controller!.seekTo(
                        Duration(
                          seconds: seekTo,
                        ),
                      );
                      return;
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
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
                      final height = item.value["quality"];
                      dynamic size;
                      if (item.value["size"] != null) {
                        size = ((item.value["size"] / (1024 * 1024)) as double)
                            .toStringAsFixed(2);
                      }
                      return ListTile(
                        leading: Icon(
                          Icons.check_rounded,
                          color: quality == index
                              ? Theme.of(context).colorScheme.onBackground
                              : Colors.transparent,
                        ),
                        title: size == null
                            ? Text("${height}p")
                            : Text("${height}p\t\t(${size}MB)"),
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
