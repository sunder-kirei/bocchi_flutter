import 'dart:convert';

import 'package:anime_api/helpers/custom_route.dart';
import 'package:anime_api/screens/video_player_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class HistoryTile extends StatefulWidget {
  const HistoryTile({
    super.key,
    required this.data,
  });

  final Map<String, dynamic> data;

  @override
  State<HistoryTile> createState() => _HistoryTileState();
}

class _HistoryTileState extends State<HistoryTile> {
  bool focused = false;
  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (value) {
        setState(() {
          focused = value;
        });
      },
      child: ClipRRect(
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
                      "Episode ${widget.data["episode"]}",
                      textAlign: TextAlign.center,
                    ),
                  ),
                  child: Card(
                    child: AnimatedScale(
                      scale: focused ? 0.95 : 1,
                      duration: const Duration(milliseconds: 200),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: CachedNetworkImage(
                          imageUrl: widget.data["episodeImage"],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
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
                          builder: (context) => VideoPlayerScreen(
                            id: widget.data["id"],
                            image: widget.data["image"],
                            episode: widget.data["episode"],
                            details: json.decode(widget.data["details"]),
                            position: widget.data["position"],
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
      ),
    );
  }
}
