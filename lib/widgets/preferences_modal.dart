import 'package:anime_api/providers/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

class PreferencesModal extends StatelessWidget {
  const PreferencesModal({super.key});

  void callback(
    BuildContext context,
    String quality,
  ) async {
    await Provider.of<Watchlist>(
      context,
      listen: false,
    ).setQuality(quality: quality);
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Watchlist>(
      builder: (context, value, child) {
        final data = value.preferredQuality;

        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 20,
          ),
          child: Flex(
            direction: Axis.vertical,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Video quality preferences",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(
                height: 20,
              ),
              Flex(
                direction: Axis.horizontal,
                children: [
                  _buildButton(
                    "360",
                    () => callback(context, "360"),
                    value.preferredQuality == "360",
                    context,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  _buildButton(
                    "720",
                    () => callback(context, "720"),
                    value.preferredQuality == "720",
                    context,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  _buildButton(
                    "1080",
                    () => callback(context, "1080"),
                    value.preferredQuality == "1080",
                    context,
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  Flexible _buildButton(
    String value,
    VoidCallback callback,
    bool active,
    BuildContext context,
  ) {
    return Flexible(
      child: OutlinedButton(
        onPressed: callback,
        style: active
            ? OutlinedButton.styleFrom(
                side: BorderSide(color: Theme.of(context).colorScheme.primary),
              )
            : null,
        child: Text("${value}p"),
      ),
    );
  }
}
