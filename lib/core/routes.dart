import 'package:flutter/material.dart';
import 'package:movies/domain/movie.dart';
import 'package:movies/presentation/screens/home_screen.dart';
import 'package:movies/presentation/screens/movie_detail_screen.dart';
import 'package:movies/presentation/screens/favorites_screen.dart';
import 'package:movies/presentation/screens/search_screen.dart';
import 'package:movies/core/theme.dart';

class Routes {
  static const home = '/';
  static const movieDetail = '/movie-detail';
  static const favorites = '/favorites';
  static const search = '/search';
}

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.home:
        return CustomPageRoute(page: HomeScreen());
      case Routes.movieDetail:
        final args = settings.arguments;
        if (args is Movie) {
          return CustomPageRoute(page: MovieDetailScreen(movie: args));
        }
        return MaterialPageRoute(
          builder: (_) => Scaffold(body: Center(child: Text('Missing movie'))),
        );
      case Routes.favorites:
        return CustomPageRoute(page: FavoritesScreen());
      case Routes.search:
        return CustomPageRoute(page: SearchScreen());
      default:
        return MaterialPageRoute(
          builder: (_) =>
              Scaffold(body: Center(child: Text('Route not found'))),
        );
    }
  }
}
