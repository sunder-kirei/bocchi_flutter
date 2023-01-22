import '../providers/user_preferences.dart';
import '../screens/details_screen.dart';
import '../widgets/hero_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RowItem extends StatelessWidget {
  final Map<String, dynamic> title;
  final String image;
  final String id;
  final String tag;
  final bool disabled;
  const RowItem({
    super.key,
    required this.title,
    required this.tag,
    required this.image,
    required this.id,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: GridTile(
          footer: GridTileBar(
            title: Text(
              title["romaji"],
              maxLines: 2,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.black54,
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: HeroImage(
                  imageUrl: image,
                  tag: tag,
                ),
              ),
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(5),
                    onTap: () {
                      if (disabled) return;
                      Navigator.of(context).pushNamed(
                        DetailsScreen.routeName,
                        arguments: {
                          "id": id,
                          "image": image,
                          "tag": tag,
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
