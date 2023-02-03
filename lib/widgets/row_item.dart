import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../providers/user_preferences.dart';
import '../screens/details_screen.dart';
import '../widgets/hero_image.dart';
import 'package:flutter/material.dart';

class RowItem extends StatefulWidget {
  final Map<String, dynamic> title;
  final String image;
  final String id;
  final String tag;
  final bool disabled;
  final VoidCallback? callback;
  const RowItem({
    super.key,
    required this.title,
    required this.tag,
    required this.image,
    required this.id,
    this.disabled = false,
    this.callback,
  });

  @override
  State<RowItem> createState() => _RowItemState();
}

class _RowItemState extends State<RowItem> {
  final _focusNode = FocusNode();

  bool focused = false;

  @override
  Widget build(BuildContext context) {
    final prefferedTitle = Provider.of<Watchlist>(context).prefferedTitle;
    PrefferedTitle subtitle;
    if (prefferedTitle == PrefferedTitle.english) {
      subtitle = PrefferedTitle.romaji;
    } else {
      subtitle = PrefferedTitle.english;
    }

    return Focus(
      focusNode: _focusNode,
      key: ValueKey(widget.tag),
      onFocusChange: (value) {
        setState(() {
          focused = value;
        });
      },
      onKey: (node, event) {
        if (event.runtimeType == RawKeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.select) {
          if (widget.callback != null) widget.callback!();
          if (widget.disabled) return KeyEventResult.handled;
          Navigator.of(context).pushNamed(
            DetailsScreen.routeName,
            arguments: {
              "id": widget.id,
              "image": widget.image,
              "tag": widget.tag,
            },
          );
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: Card(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: GridTile(
            footer: GridTileBar(
              title: Text(
                widget.title[prefferedTitle.name] ??
                    widget.title[subtitle.name],
                maxLines: 2,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
              backgroundColor: const Color.fromRGBO(0, 0, 0, 0.75),
            ),
            child: AnimatedScale(
              scale: focused ? 0.95 : 1,
              duration: const Duration(milliseconds: 200),
              child: HeroImage(
                imageUrl: widget.image,
                tag: widget.tag,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
