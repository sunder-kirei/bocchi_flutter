import '../widgets/custom_drawer.dart';
import '../widgets/bocchi_rich_text.dart';
import '../widgets/search_button.dart';
import 'package:flutter/material.dart';

import '../helpers/http_helper.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/row_sliver.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = "/";

  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: const SearchButton(),
      drawer: const CustomDrawer(),
      body: CustomScrollView(
        slivers: [
          CustomAppBar(
            image: Image.asset(
              "assets/landing.jpg",
              fit: BoxFit.cover,
              alignment: Alignment.centerRight,
            ),
            title: const BocchiRichText(fontSize: 20),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 5.0,
                top: 10,
                bottom: 5,
              ),
              child: Text(
                "Recent Uploads",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
          const RowSliver(
            option: GetLanding.recent_episodes,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 5.0,
                top: 10,
                bottom: 5,
              ),
              child: Text(
                "Trending",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
          const RowSliver(
            option: GetLanding.trending,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 5.0,
                top: 10,
                bottom: 5,
              ),
              child: Text(
                "Popular",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
          const RowSliver(
            option: GetLanding.popular,
          ),
        ],
      ),
    );
  }
}
