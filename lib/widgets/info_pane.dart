import 'package:anime_api/providers/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    final prefferedTitle = Provider.of<Watchlist>(context).prefferedTitle;
    PrefferedTitle subtitle;
    if (prefferedTitle == PrefferedTitle.english) {
      subtitle = PrefferedTitle.romaji;
    } else {
      subtitle = PrefferedTitle.english;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title[prefferedTitle.name] ?? title[subtitle.name] ?? "Unknown",
          maxLines: 2,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.displayLarge,
        ),
        
        if (title[subtitle.name] != null || synonyms.isNotEmpty)
          Text(
            title[subtitle.name] ?? synonyms[0] ?? "Unknown",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium,
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
