import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:movies/domain/movie.dart';

/// Simple repository that talks to OMDb.
/// Accept an optional [overrideApiKey] to force a key (useful when loading
/// a packaged `.env` asset at startup). If null, the repo will use the
/// compile-time dart-define key and otherwise fail.
class MovieRepository {
  final String? overrideApiKey;

  MovieRepository({this.overrideApiKey});

  // Compile-time (dart-define) key.
  static const String _compileTimeApiKey = String.fromEnvironment(
    'OMDB_API_KEY',
    defaultValue: '',
  );

  static const String baseUrl = 'https://www.omdbapi.com/';

  String _resolveApiKey() {
    // 1) explicit override passed at construction (packaged .env parsed at
    //    startup)
    if (overrideApiKey != null && overrideApiKey!.isNotEmpty) {
      return overrideApiKey!;
    }
    // 2) compile-time key passed via --dart-define
    if (_compileTimeApiKey.isNotEmpty) return _compileTimeApiKey;
    // 3) nothing found
    return '';
  }

  Future<Movie> fetchMovie(String imdbId) async {
    final apiKey = _resolveApiKey();
    if (apiKey.isEmpty) {
      throw Exception(
        'OMDB_API_KEY is not defined. Provide it via --dart-define=OMDB_API_KEY=your_key or place it in a .env file',
      );
    }
    final uri = Uri.parse('$baseUrl?apikey=$apiKey&i=$imdbId&plot=full');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      if (data['Response'] == 'True') {
        return Movie.fromJson(data);
      } else {
        throw Exception(data['Error'] ?? 'Failed to load movie');
      }
    }
    throw Exception('Network error: ${response.statusCode}');
  }

  /// Result of a search request (movies + total results reported by OMDb)
  ///
  /// OMDb returns up to 10 results per page; use [page] to request more.
  Future<SearchResult> searchMovies(String query, {int page = 1}) async {
    final apiKey = _resolveApiKey();
    if (apiKey.isEmpty) {
      throw Exception(
        'OMDB_API_KEY is not defined. Provide it via --dart-define=OMDB_API_KEY=your_key or place it in a .env file',
      );
    }
    final uri = Uri.parse(
      '$baseUrl?apikey=$apiKey&s=${Uri.encodeQueryComponent(query)}&page=$page',
    );
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      if (data['Response'] == 'True' && data['Search'] != null) {
        final List results = data['Search'];
        final movies = results
            .map((m) => Movie.fromJson(m as Map<String, dynamic>))
            .toList();
        int total = 0;
        if (data['totalResults'] != null) {
          total = int.tryParse(data['totalResults'].toString()) ?? 0;
        }
        return SearchResult(movies: movies, totalResults: total);
      }
      return SearchResult(movies: [], totalResults: 0);
    }
    throw Exception('Network error: ${response.statusCode}');
  }
}

/// Simple container for search results coming from OMDb
class SearchResult {
  final List<Movie> movies;
  final int totalResults;

  SearchResult({required this.movies, required this.totalResults});
}
