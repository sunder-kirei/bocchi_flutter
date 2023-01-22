import '../providers/user_preferences.dart';
import '../widgets/sort_options_builder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PreferencesModal extends StatefulWidget {
  const PreferencesModal({super.key});
  static const routeName = "/preferences";

  @override
  State<PreferencesModal> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesModal> {
  Widget buildVideoPreference({
    required VideoQuality quality,
    required UserPreferences value,
    required String title,
  }) {
    return Flexible(
      child: OutlinedButton(
        onPressed: () async => await value.setVideoQuality(
          videoQuality: quality,
        ),
        style: value.quality == quality
            ? OutlinedButton.styleFrom(
                side: const BorderSide(
                  color: Color.fromRGBO(243, 198, 105, 1),
                ),
              )
            : OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
              ),
        child: Text(title),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        const SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.only(
            left: 13,
            top: 15,
          ),
          child: Text(
            "Video quality preferences",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Consumer<UserPreferences>(
          builder: (context, value, child) {
            return Flex(
              direction: Axis.vertical,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 8.0,
                    right: 8.0,
                    top: 5,
                  ),
                  child: Flex(
                    direction: Axis.horizontal,
                    children: [
                      buildVideoPreference(
                        quality: VideoQuality.highest,
                        value: value,
                        title: "720p",
                      ),
                      buildVideoPreference(
                        quality: VideoQuality.normal,
                        value: value,
                        title: "480p",
                      ),
                      buildVideoPreference(
                        quality: VideoQuality.lowest,
                        value: value,
                        title: "360p",
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: SortBuilder(
                    orderByCallback: value.setOrderBy,
                    orderingCallback: value.setOrdering,
                    curOrderBy: value.orderBy,
                    curOrdering: value.ordering,
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
