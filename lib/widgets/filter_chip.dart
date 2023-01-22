import 'package:flutter/material.dart';

class CustomFilterChip extends StatelessWidget {
  final String data;
  final VoidCallback handleClick;
  const CustomFilterChip({
    Key? key,
    required this.data,
    required this.handleClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        data,
      ),
      deleteIcon: const Icon(Icons.close_rounded),
      deleteButtonTooltipMessage: "Remove",
      onDeleted: handleClick,
    );
  }
}
