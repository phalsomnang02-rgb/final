
import 'package:flutter/material.dart';
import 'package:flutter_application_1/parent_screen.dart';
import 'package:provider/provider.dart';
import 'movie_theme_logic.dart';
import 'movie_gridstyle_logic.dart';

class MovieSplashScreen extends StatefulWidget {
  const MovieSplashScreen({super.key});

  @override
  State<MovieSplashScreen> createState() => _MovieSplashScreenState();
}

class _MovieSplashScreenState extends State<MovieSplashScreen> {
  
  Future _loadData() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      await context.read<MovieThemeLogic>().readTheme();
    }
    if (mounted) {
      await context.read<MovieGridstyleLogic>().readStyle();
    }
  }

  late Future _futureData = _loadData();

  @override
  Widget build(BuildContext context) {
    bool dark = context.watch<MovieThemeLogic>().dark;
    
    Color seedColor = Colors.deepOrange;
    Color secondaryColor = Colors.lime.shade300;
    Color appBarColor = Colors.deepOrange.shade400;

    // 💡 ដាក់ MaterialApp នៅទីនេះ ដើម្បីឲ្យវាគ្រប់គ្រង App ទាំងមូលតាំងពី Splash Screen ទៅ
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: dark ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(seedColor: seedColor),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: secondaryColor,
          shape: const CircleBorder(),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: appBarColor,
          foregroundColor: Colors.white,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: Brightness.dark,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: secondaryColor.withAlpha(96),
          shape: const CircleBorder(),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black12, 
          foregroundColor: Colors.white,
        ),
      ),
      home: Scaffold(
        backgroundColor: Colors.lightBlueAccent, // ពណ៌ផ្ទៃក្រោយរបស់ Splash Screen
        body: Center(
          child: FutureBuilder(
            future: _futureData,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(snapshot.error.toString(), style: const TextStyle(color: Colors.white)),
                    FilledButton(
                      onPressed: () {
                        setState(() {
                          _futureData = _loadData();
                        });
                      },
                      child: const Text("RETRY"),
                    ),
                  ],
                );
              }
              if (snapshot.connectionState == ConnectionState.done) {
                return const ParentScreen(); // បើ Load ទិន្នន័យចប់ នឹងបើកទៅទំព័រមេ និងស្គាល់ Theme ត្រឹមត្រូវ
              } else {
                return _buildLoading();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLoading(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset("images/logo.png", height: 300,),
        ),
        const CircularProgressIndicator(color: Colors.white,),
      ],
    );
  }
}
