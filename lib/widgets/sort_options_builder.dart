import '../helpers/http_helper.dart';
import 'package:flutter/material.dart';

class SortBuilder extends StatelessWidget {
  final OrderBy curOrderBy;
  final Ordering curOrdering;
  final Function orderByCallback;
  final Function orderingCallback;
  const SortBuilder({
    super.key,
    required this.orderByCallback,
    required this.orderingCallback,
    required this.curOrderBy,
    required this.curOrdering,
  });

  Widget buildFilterOptions({
    required BuildContext context,
    required OrderBy order,
  }) {
    return OutlinedButton(
      onPressed: () => orderByCallback(order),
      style: curOrderBy == order
          ? OutlinedButton.styleFrom(
              side: const BorderSide(
                color: Color.fromRGBO(243, 198, 105, 1),
              ),
            )
          : OutlinedButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.onBackground,
            ),
      child: FittedBox(
        child: Text(
          order.name.split('_').toList()[0].toString().toUpperCase()[0] +
              order.name.split('_').toList()[0].toString().substring(1),
        ),
      ),
    );
  }

  Widget buildOrderingOptions({
    required BuildContext context,
    required Ordering localOrdering,
  }) {
    return SliverToBoxAdapter(
      child: OutlinedButton(
        onPressed: () => orderingCallback(localOrdering),
        style: curOrdering == localOrdering
            ? OutlinedButton.styleFrom(
                foregroundColor: Colors.greenAccent[400],
                side: BorderSide(
                  color: Colors.greenAccent[400] as Color,
                ),
              )
            : OutlinedButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.onBackground,
              ),
        child: FittedBox(
          child: Text(
            localOrdering == Ordering.asc ? "Ascending" : "Descending",
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(5),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Filter By",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 5),
          ),
          SliverGrid.count(
            crossAxisCount: 3,
            childAspectRatio: 20 / 9,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
            children: [
              buildFilterOptions(
                context: context,
                order: OrderBy.created_at_unix,
              ),
              buildFilterOptions(
                context: context,
                order: OrderBy.released_at_unix,
              ),
              buildFilterOptions(
                context: context,
                order: OrderBy.views,
              ),
              buildFilterOptions(
                context: context,
                order: OrderBy.likes,
              ),
              buildFilterOptions(
                context: context,
                order: OrderBy.title_sortable,
              ),
            ],
          ),
          const SliverToBoxAdapter(
            child: Divider(
              thickness: 1,
              height: 20,
            ),
          ),
          buildOrderingOptions(
            context: context,
            localOrdering: Ordering.asc,
          ),
          buildOrderingOptions(
            context: context,
            localOrdering: Ordering.desc,
          ),
        ],
      ),
    );
  }
}
