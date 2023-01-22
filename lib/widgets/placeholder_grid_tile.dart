import 'package:flutter/material.dart';

class PlaceholderGridTiles extends StatelessWidget {
  const PlaceholderGridTiles({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: ListView.builder(
        itemBuilder: (context, index) => Card(
          child: Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
        ),
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemExtent: 170,
      ),
    );
  }
}
