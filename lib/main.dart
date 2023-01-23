import 'package:anime_api/screens/video_player_screen.dart';

import '../providers/user_preferences.dart';
import '../screens/search_screen.dart';
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
        create: (context) => Watchlist(),
        builder: (context, _) => FutureBuilder(
              future: Provider.of<Watchlist>(context, listen: false).fetchAll(),
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
                    colorScheme: const ColorScheme.dark().copyWith(
                      primary: Colors.pinkAccent,
                    ),
                    outlinedButtonTheme: OutlinedButtonThemeData(
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(45),
                        textStyle: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  themeMode: ThemeMode.dark,
                  routes: {
                    HomeScreen.routeName: (context) => const HomeScreen(),
                    DetailsScreen.routeName: (context) => const DetailsScreen(),
                    VideoPlayerScreen.routeName: (context) =>
                        const VideoPlayerScreen(),
                    SearchScreen.routeName: (context) => const SearchScreen(),
                  },
                );
              },
            ));
  }
}
