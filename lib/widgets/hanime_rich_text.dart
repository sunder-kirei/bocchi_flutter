import 'package:flutter/material.dart';

class HanimeRichText extends StatelessWidget {
  final double fontSize;
  const HanimeRichText({super.key, required this.fontSize});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: "hanime",
        children: const [
          TextSpan(
            text: ".",
            style: TextStyle(
              color: Color.fromRGBO(243, 198, 105, 1),
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
