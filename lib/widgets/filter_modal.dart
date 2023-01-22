import '../models/browse_page_data.dart';
import '../providers/user_preferences.dart';
import '../widgets/filter_grid_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/filter_chip.dart';

class FilterModal extends StatelessWidget {
  final FilterType filterType;
  final Function fetchData;
  const FilterModal(
      {super.key, required this.filterType, required this.fetchData});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      padding: const EdgeInsets.symmetric(
        horizontal: 5,
        vertical: 10,
      ),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: OutlinedButton(
              child: const Text("Apply"),
              onPressed: () {
                FocusScope.of(context).unfocus();
                fetchData();
              },
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 40,
              margin: const EdgeInsets.only(bottom: 5),
              alignment: Alignment.center,
              child: ListView.separated(
                separatorBuilder: (context, index) => const SizedBox(width: 5),
                itemBuilder: (context, index) {
                  final data = Provider.of<UserPreferences>(
                    context,
                  ).get(
                    filterType,
                  );
                  return CustomFilterChip(
                    data: data[index],
                    handleClick: () {
                      Provider.of<UserPreferences>(
                        context,
                        listen: false,
                      ).remove(
                        data[index],
                        filterType,
                      );
                    },
                  );
                },
                scrollDirection: Axis.horizontal,
                itemCount: Provider.of<UserPreferences>(context)
                    .get(filterType)
                    .length,
              ),
            ),
          ),
          SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) => Consumer<UserPreferences>(
                builder: (context, value, child) => FilterGridTile(
                  handleClick: () => Provider.of<UserPreferences>(
                    context,
                    listen: false,
                  ).toggle(
                    BrowsePageData.get(filterType)[index]["text"],
                    filterType,
                  ),
                  data: BrowsePageData.get(filterType)[index]["text"],
                  isActive: value
                      .get(
                        filterType,
                      )
                      .contains(
                        BrowsePageData.get(filterType)[index]["text"],
                      ),
                ),
              ),
              childCount: BrowsePageData.get(filterType).length,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisExtent: 50,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
          ),
        ],
      ),
    );
  }
}
