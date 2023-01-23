import 'package:anime_api/widgets/bocchi_rich_text.dart';
import 'package:anime_api/widgets/preferences_modal.dart';

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
                  const ListTile(
                    contentPadding: EdgeInsets.only(
                      top: 20,
                      left: 10,
                      bottom: 10,
                    ),
                    leading: CircleAvatar(
                      backgroundImage: AssetImage("assets/branding.jpg"),
                      radius: 30,
                    ),
                    title: BocchiRichText(
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
                  const Spacer(),
                  const Divider(thickness: 1),
                  ListTile(
                    title: Text("Preferences"),
                    leading: Icon(Icons.settings),
                    style: ListTileStyle.drawer,
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => PreferencesModal(),
                      );
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
