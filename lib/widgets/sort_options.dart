import '../helpers/http_helper.dart';
import '../widgets/sort_options_builder.dart';
import 'package:flutter/material.dart';

class SortOptions extends StatelessWidget {
  final OrderBy curOrderBy;
  final Ordering curOrdering;
  final Function orderByCallback;
  final Function orderingCallback;
  const SortOptions({
    super.key,
    required this.orderByCallback,
    required this.orderingCallback,
    required this.curOrderBy,
    required this.curOrdering,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (context) => SortBuilder(
            curOrderBy: curOrderBy,
            curOrdering: curOrdering,
            orderByCallback: orderByCallback,
            orderingCallback: orderingCallback,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        );
      },
      icon: const Icon(Icons.filter_list_rounded),
    );
  }
}
