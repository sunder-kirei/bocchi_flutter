import 'package:flutter/material.dart';

class FilterGridTile extends StatelessWidget {
  final VoidCallback handleClick;
  final String data;
  final bool isActive;

  String getTitle(String title) {
    return title
        .split(' ')
        .map((element) {
          if (element == "bdsm" ||
              element == "3d" ||
              element == "hd" ||
              element == "ntr" ||
              element == "pov") {
            return element.toUpperCase();
          }
          return element.toUpperCase()[0] + element.substring(1);
        })
        .toList()
        .join(' ');
  }

  const FilterGridTile({
    Key? key,
    required this.handleClick,
    required this.data,
    required this.isActive,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: handleClick,
      style: isActive
          ? OutlinedButton.styleFrom(
              side: const BorderSide(color: Color.fromRGBO(243, 198, 105, 1)),
            )
          : OutlinedButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.onBackground,
            ),
      child: FittedBox(
        child: Text(getTitle(data)),
      ),
    );
  }
}
