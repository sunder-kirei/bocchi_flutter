import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:google_fonts/google_fonts.dart';

import '../providers/user_preferences.dart';
import '../screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';

import './screens/details_screen.dart';
import './screens/home_screen.dart';
import 'constants/app_colors.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
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
                  darkTheme: ThemeData.dark().copyWith(
                    useMaterial3: true,
                    colorScheme: const ColorScheme.dark().copyWith(
                      primary: AppColors.green,
                    ),
                    textTheme: TextTheme(
                      displayLarge: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      titleMedium: GoogleFonts.lato(
                        fontSize: 13,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                      ),
                    ),
                    inputDecorationTheme: const InputDecorationTheme(
                      fillColor: AppColors.lightblack,
                    ),
                    cardColor: AppColors.lightblack,
                    scaffoldBackgroundColor: AppColors.black,
                    iconTheme: const IconThemeData(color: Colors.white),
                    // outlinedButtonTheme: OutlinedButtonThemeData(
                    //   style: OutlinedButton.styleFrom(
                    //     minimumSize: const Size.fromHeight(45),
                    //     textStyle: const TextStyle(
                    //       fontSize: 16,
                    //     ),
                    //   ),
                    // ),
                  ),
                  themeMode: ThemeMode.dark,
                  routes: {
                    HomeScreen.routeName: (context) => const HomeScreen(),
                    DetailsScreen.routeName: (context) => const DetailsScreen(),
                    SearchScreen.routeName: (context) => const SearchScreen(),
                  },
                );
              },
            ));
  }
}
