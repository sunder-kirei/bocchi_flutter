import '../screens/details_screen.dart';
import 'package:flutter/material.dart';

class SearchCard extends StatelessWidget {
  // final dynamic data;
  final String image;
  final String cover;
  final String id;
  final Map<String, dynamic> title;
  const SearchCard({
    super.key,
    required this.image,
    required this.cover,
    required this.id,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Stack(
          children: [
            Column(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: GestureDetector(
                    child: Image.network(
                      image,
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                    ),
                    onTap: () {
                      if (FocusScope.of(context).hasFocus) {
                        FocusScope.of(context).unfocus();
                      }
                      Navigator.of(context).pushNamed(
                        DetailsScreen.routeName,
                        arguments: {
                          "id": id,
                          "image": image,
                          "tag": id,
                        },
                      );
                    },
                  ),
                ),
                Container(
                  height: 60,
                ),
              ],
            ),
            Positioned(
              bottom: 10,
              left: 5,
              child: Container(
                decoration: const BoxDecoration(
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      offset: Offset(1, -2),
                      blurRadius: 10,
                      color: Colors.black26,
                    ),
                  ],
                ),
                height: 130,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Hero(
                    tag: id,
                    child: Image.network(image),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 100,
              child: SizedBox(
                height: 80,
                width: MediaQuery.of(context).size.width - 110,
                child: Flex(
                  direction: Axis.vertical,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Text(
                        title["romaji"],
                        maxLines: 2,
                        style: Theme.of(context).textTheme.titleSmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Text(
                        title["english"],
                        maxLines: 2,
                        style: Theme.of(context).textTheme.titleSmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
