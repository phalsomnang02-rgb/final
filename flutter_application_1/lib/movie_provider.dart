import 'package:flutter/material.dart';
import 'package:flutter_application_1/movie_gridstyle_logic.dart';
import 'package:flutter_application_1/movie_theme_logic.dart';
import 'package:provider/provider.dart';
import 'movie_splash_screen.dart';


Widget movieProvider() {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => MovieThemeLogic()),
      ChangeNotifierProvider(create: (context) => MovieGridstyleLogic()),
    ],
    child: MovieSplashScreen(),
  );
}
