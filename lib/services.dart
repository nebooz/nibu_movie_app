import 'package:http/http.dart' as http;
import 'dart:async';
import 'movies_def.dart';
import 'globals.dart' as globals;

final url =
    "https://api.themoviedb.org/3/movie/popular?api_key=${globals.movieApiKey}&language=en-US&page=1";

Future<Movies> getPost() async {
  final response = await http.get(url);

  if (response.statusCode == 200) {
    // If server returns an OK response, parse the JSON
    return moviesFromJson(response.body);
  } else {
    // If that response was not OK, throw an error.
    throw Exception('Failed to load post');
  }
}
