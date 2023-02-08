import '../widgets/row_item.dart';
import 'package:flutter/material.dart';

import '../helpers/http_helper.dart';

class RowSliver extends StatelessWidget {
  final GetLanding option;

  const RowSliver({super.key, required this.option});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SliverToBoxAdapter(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ),
          );
        }
        final fetchedData = snapshot.data!["results"];
        return SliverGrid.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: 280,
          ),
          itemBuilder: (context, index) => RowItem(
            id: fetchedData[index]["id"],
            image: fetchedData[index]["image"],
            title: fetchedData[index]["title"],
            tag: option.name +
                fetchedData[index]["id"].toString() +
                fetchedData[index]["episodeId"].toString(),
          ),
          itemCount: fetchedData.length,
        );
      },
      future: HttpHelper.getLanding(landing: option),
    );
  }
}
