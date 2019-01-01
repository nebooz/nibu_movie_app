import 'package:http/http.dart' as http;
import 'dart:async';
import './data/movies.dart';
import './data/configuration.dart';
import 'secrets.dart' as secrets;

final popMoviesUrl =
    "https://api.themoviedb.org/3/movie/popular?api_key=${secrets.movieApiKey}&language=en-US&page=1";

final configurationUrl =
    "https://api.themoviedb.org/3/configuration?api_key=${secrets.movieApiKey}";

Future<Movies> getMovies() async {
  final response = await http.get(popMoviesUrl);

  if (response.statusCode == 200) {
    // If server returns an OK response, parse the JSON
    return moviesFromJson(response.body);
  } else {
    // If that response was not OK, throw an error.
    throw Exception('Failed to load post');
  }
}

Future<Configuration> getConfig() async {
  final response = await http.get(configurationUrl);

  if (response.statusCode == 200) {
    // If server returns an OK response, parse the JSON
    return configurationFromJson(response.body);
  } else {
    // If that response was not OK, throw an error.
    throw Exception('Failed to load post');
  }
}
