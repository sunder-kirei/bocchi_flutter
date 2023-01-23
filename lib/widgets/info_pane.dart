import 'package:flutter/material.dart';

class InfoPane extends StatelessWidget {
  final Map<String, dynamic> title;
  final int releaseDate;
  final List<dynamic> synonyms;
  final String studio;
  final int rating;
  const InfoPane({
    super.key,
    required this.title,
    required this.releaseDate,
    required this.synonyms,
    required this.studio,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Title",
          style: Theme.of(context).textTheme.caption,
        ),
        Text(
          title["romaji"],
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        if (synonyms.isNotEmpty)
          Text(
            "Alternate Title",
            style: Theme.of(context).textTheme.caption,
          ),
        if (synonyms.isNotEmpty || title["english"] != null)
          Text(
            title["english"] ?? synonyms[0],
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleSmall,
          ),
        Text(
          "Release Date",
          style: Theme.of(context).textTheme.caption,
        ),
        Text(
          releaseDate != 0 ? releaseDate.toString() : "Unknown",
          style: Theme.of(context).textTheme.titleSmall,
        ),
        Text(
          "Studio",
          style: Theme.of(context).textTheme.caption,
        ),
        Text(
          studio,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        Text(
          "MAL Rating",
          style: Theme.of(context).textTheme.caption,
        ),
        Text(
          rating != 0 ? rating.toString() : "Unknown",
          style: Theme.of(context).textTheme.titleSmall,
        ),
      ],
    );
  }
}
