import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class HeroImage extends StatelessWidget {
  final String imageUrl;
  final String tag;
  const HeroImage({
    super.key,
    required this.imageUrl,
    required this.tag,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          key: ValueKey(
            tag,
          ),
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress?.cumulativeBytesLoaded ==
                loadingProgress?.expectedTotalBytes) return child;
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.onBackground,
              ),
            );
          },
        ),
      ),
    );
  }
}
