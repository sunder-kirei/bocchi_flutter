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
          style: Theme.of(context).textTheme.titleSmall,
        ),
        if (synonyms.isNotEmpty)
          Text(
            "Alternate Title",
            style: Theme.of(context).textTheme.caption,
          ),
        if (synonyms.isNotEmpty)
          Text(
            synonyms[0],
            style: Theme.of(context).textTheme.titleSmall,
          ),
        Text(
          "Release Date",
          style: Theme.of(context).textTheme.caption,
        ),
        Text(
          releaseDate.toString(),
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
          rating.toString(),
          style: Theme.of(context).textTheme.titleSmall,
        ),
      ],
    );
  }
}
