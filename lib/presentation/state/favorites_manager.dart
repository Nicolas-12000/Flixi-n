import 'package:flutter/foundation.dart';
import 'package:movies/domain/movie.dart';

class FavoritesManager extends ChangeNotifier {
  final List<Movie> _favorites = [];

  List<Movie> get favorites => List.unmodifiable(_favorites);

  void toggleFavorite(Movie movie) {
    if (_favorites.any((m) => m.id == movie.id)) {
      _favorites.removeWhere((m) => m.id == movie.id);
      movie.isFavorite = false;
    } else {
      _favorites.add(movie);
      movie.isFavorite = true;
    }
    notifyListeners();
  }

  bool isFavorite(String movieId) {
    return _favorites.any((m) => m.id == movieId);
  }
}
