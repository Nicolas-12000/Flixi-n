class Movie {
  final String id;
  final String title;
  final String posterUrl;
  final String year;
  final String genre;
  final String rating;
  final String plot;
  final String director;
  final String duration;
  final List<String> cast;
  bool isFavorite;

  Movie({
    required this.id,
    required this.title,
    required this.posterUrl,
    required this.year,
    required this.genre,
    required this.rating,
    required this.plot,
    required this.director,
    required this.duration,
    required this.cast,
    this.isFavorite = false,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['imdbID'] ?? '',
      title: json['Title'] ?? 'Unknown',
      posterUrl: json['Poster'] ?? '',
      year: json['Year'] ?? 'N/A',
      genre: json['Genre'] ?? 'N/A',
      rating: json['imdbRating'] ?? 'N/A',
      plot: json['Plot'] ?? 'No plot available',
      director: json['Director'] ?? 'Unknown',
      duration: json['Runtime'] ?? 'N/A',
      cast: json['Actors'] != null
          ? (json['Actors'] as String).split(', ')
          : [],
    );
  }
}
