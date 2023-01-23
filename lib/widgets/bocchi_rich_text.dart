import 'package:flutter/material.dart';

class BocchiRichText extends StatelessWidget {
  final double fontSize;
  const BocchiRichText({super.key, required this.fontSize});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: "bocchi",
        children: const [
          TextSpan(
            text: ".",
            style: TextStyle(
              color: Colors.pinkAccent,
            ),
          ),
          TextSpan(text: "tv"),
        ],
        style: TextStyle(
          fontFamily: "Roboto",
          fontWeight: FontWeight.w500,
          fontSize: fontSize,
        ),
      ),
    );
  }
}
