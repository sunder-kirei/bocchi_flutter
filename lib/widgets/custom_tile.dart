import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomTile extends StatelessWidget {
  final String image;
  final String? airDate;
  final int episodeNumber;
  final String? title;
  final String? description;
  const CustomTile({
    super.key,
    required this.image,
    this.airDate,
    required this.episodeNumber,
    this.title,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Flex(
      key: key,
      direction: Axis.horizontal,
      mainAxisSize: MainAxisSize.max,
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: Card(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: CachedNetworkImage(
                imageUrl: image,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                airDate == null
                    ? Text(
                        "Episode $episodeNumber",
                      )
                    : Text(
                        "E$episodeNumber \u2022 ${airDate!.substring(0, 10)}",
                      ),
                title != null
                    ? Text(
                        title!,
                        maxLines: 2,
                      )
                    : const Text(
                        "\n",
                      ),
                description != null
                    ? Text(
                        description!,
                        maxLines: 2,
                        style:
                            Theme.of(context).textTheme.labelMedium?.copyWith(
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
    );
  }
}
