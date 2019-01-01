import 'package:http/http.dart' as http;
import 'dart:async';
import 'movies_def.dart';
import 'secrets.dart' as secrets;

final url =
    "https://api.themoviedb.org/3/movie/popular?api_key=${secrets.movieApiKey}&language=en-US&page=1";

Future<Movies> getMovies() async {
  final response = await http.get(url);

  if (response.statusCode == 200) {
    // If server returns an OK response, parse the JSON
    return moviesFromJson(response.body);
  } else {
    // If that response was not OK, throw an error.
    throw Exception('Failed to load post');
  }
}
