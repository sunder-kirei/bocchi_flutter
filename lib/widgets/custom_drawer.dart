import 'package:anime_api/widgets/bocchi_rich_text.dart';

import '../screens/preferences_modal.dart';
import 'package:flutter/material.dart';

import '../screens/search_screen.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              fillOverscroll: true,
              hasScrollBody: true,
              child: Column(
                children: [
                  ListTile(
                    contentPadding: const EdgeInsets.only(
                      top: 20,
                      left: 10,
                      bottom: 10,
                    ),
                    leading: CircleAvatar(
                      backgroundImage: AssetImage("assets/landing_light.jpg"),
                      radius: 30,
                    ),
                    title: const BocchiRichText(
                      fontSize: 24,
                    ),
                  ),
                  const Divider(
                    thickness: 1,
                  ),
                  ListTile(
                    style: ListTileStyle.drawer,
                    leading: const Icon(Icons.home_rounded),
                    title: const Text("Home"),
                    onTap: () {
                      Scaffold.of(context).closeDrawer();
                    },
                  ),
                  ListTile(
                    style: ListTileStyle.drawer,
                    leading: const Icon(Icons.search_rounded),
                    title: const Text("Search"),
                    onTap: () {
                      Navigator.of(context).pushNamed(SearchScreen.routeName);
                      Scaffold.of(context).closeDrawer();
                    },
                  ),
                  ListTile(
                    style: ListTileStyle.drawer,
                    leading: const Icon(Icons.category_rounded),
                    title: const Text("Browse"),
                    onTap: () {
                      // Navigator.of(context).pushNamed(BrowseScreen.routeName);
                      Scaffold.of(context).closeDrawer();
                    },
                  ),
                  ListTile(
                    style: ListTileStyle.drawer,
                    leading: const Icon(Icons.favorite_outlined),
                    title: const Text("Favourites"),
                    onTap: () {
                      // Navigator.of(context).pushNamed(
                      //   FavouritesScreen.routeName,
                      // );
                      Scaffold.of(context).closeDrawer();
                    },
                  ),
                  const Spacer(),
                  const Divider(),
                  ListTile(
                    style: ListTileStyle.drawer,
                    leading: const Icon(Icons.settings),
                    title: const Text("Preferences"),
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => const PreferencesModal(),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5),
                            topRight: Radius.circular(5),
                          ),
                        ),
                      );
                      Scaffold.of(context).closeDrawer();
                    },
                  ),
                  const ListTile(
                    style: ListTileStyle.drawer,
                    leading: Icon(Icons.help_rounded),
                    title: Text("Help\t(In Progress)"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
