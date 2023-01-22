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
          return const SliverToBoxAdapter(
            child: SizedBox(
              height: 250,
              child: Card(
                child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          );
        }
        final fetchedData = snapshot.data!["results"];
        return SliverToBoxAdapter(
          child: SizedBox(
            height: 250,
            child: ListView.builder(
              itemBuilder: (context, index) => RowItem(
                id: fetchedData[index]["id"],
                image: fetchedData[index]["image"],
                title: fetchedData[index]["title"],
                tag: option.name + fetchedData[index]["id"].toString(),
              ),
              itemCount: fetchedData.length,
              scrollDirection: Axis.horizontal,
              itemExtent: 170,
            ),
          ),
        );
      },
      future: HttpHelper.getLanding(landing: option),
    );
  }
}
