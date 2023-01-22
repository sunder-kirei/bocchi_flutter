import 'package:anime_api/screens/video_player_screen.dart';

import '../providers/user_preferences.dart';
import '../screens/browse_brand_screen.dart';
import '../screens/browse_screen.dart';
import '../screens/browse_tag_screen.dart';
import '../screens/favourites_screen.dart';
import '../screens/preferences_modal.dart';
import '../screens/search_screen.dart';
import '../screens/web_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';

import './screens/details_screen.dart';
import './screens/home_screen.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return ChangeNotifierProvider(
        create: (context) => UserPreferences(),
        builder: (context, _) => FutureBuilder(
              future: Provider.of<UserPreferences>(context, listen: false)
                  .fetchPreferences(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  FlutterNativeSplash.remove();
                }
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  scrollBehavior: const ScrollBehavior(
                    // ignore: deprecated_member_use
                    androidOverscrollIndicator:
                        AndroidOverscrollIndicator.stretch,
                  ),
                  darkTheme: ThemeData.dark().copyWith(
                    outlinedButtonTheme: OutlinedButtonThemeData(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color.fromRGBO(243, 198, 105, 1),
                        minimumSize: const Size.fromHeight(45),
                        textStyle: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    elevatedButtonTheme: ElevatedButtonThemeData(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color.fromRGBO(243, 198, 105, 1),
                        minimumSize: const Size.fromHeight(50),
                        textStyle: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.w500),
                      ),
                    ),
                    floatingActionButtonTheme: FloatingActionButtonThemeData(
                      backgroundColor: const Color.fromRGBO(243, 198, 105, 1),
                      foregroundColor:
                          Theme.of(context).colorScheme.onBackground,
                      splashColor: Colors.white10,
                    ),
                  ),
                  themeMode: ThemeMode.dark,
                  routes: {
                    HomeScreen.routeName: (context) => const HomeScreen(),
                    DetailsScreen.routeName: (context) => const DetailsScreen(),
                    VideoPlayerScreen.routeName: (context) =>
                        const VideoPlayerScreen(),
                    // BrowseScreen.routeName: (context) => const BrowseScreen(),
                    // WebView.routeName: (context) => WebView(),
                    // BrowseTagScreen.routeName: (context) =>
                    //     const BrowseTagScreen(),
                    // SearchScreen.routeName: (context) => const SearchScreen(),
                    // BrowseBrandScreen.routeName: (context) =>
                    //     const BrowseBrandScreen(),
                    // FavouritesScreen.routeName: (context) =>
                    //     const FavouritesScreen(),
                    // PreferencesModal.routeName: (context) =>
                    //     const PreferencesModal(),
                  },
                );
              },
            ));
  }
}
