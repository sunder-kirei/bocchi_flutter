import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:wakelock/wakelock.dart';

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
  Wakelock.enable();
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<void> setRefreshRate() async {
    final supported = await FlutterDisplayMode.supported;
    await FlutterDisplayMode.setPreferredMode(supported[1]);
    setState(() {});
  }

  @override
  void initState() {
    setRefreshRate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => Watchlist(),
        builder: (context, _) => FutureBuilder(
              future: Provider.of<Watchlist>(context, listen: false).fetchAll(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  FlutterNativeSplash.remove();
                }
                return Shortcuts(
                  shortcuts: {
                    LogicalKeySet(
                      LogicalKeyboardKey.arrowUp,
                    ): const SelectIntent(),
                    LogicalKeySet(
                      LogicalKeyboardKey.arrowDown,
                    ): const SelectIntent(),
                    LogicalKeySet(
                      LogicalKeyboardKey.arrowLeft,
                    ): const SelectIntent(),
                    LogicalKeySet(
                      LogicalKeyboardKey.arrowRight,
                    ): const SelectIntent(),
                    LogicalKeySet(
                      LogicalKeyboardKey.select,
                    ): const ActivateIntent(),
                  },
                  child: MaterialApp(
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
                      DetailsScreen.routeName: (context) =>
                          const DetailsScreen(),
                      SearchScreen.routeName: (context) => const SearchScreen(),
                    },
                  ),
                );
              },
            ));
  }
}
