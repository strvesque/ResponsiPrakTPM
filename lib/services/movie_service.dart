import 'dart:convert';
import 'package:responsipraktpm/models/movie_model.dart';
import 'package:http/http.dart' as http;

class MovieService {
  static const String baseUrl =
      "https://tpm-api-responsi-a-h-872136705893.us-central1.run.app/api/v1/movies";

  static Future<List<Movie>> getMovies() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> movieList = data['data'];
      return movieList.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception('Gagal mengambil data movie');
    }
  }

  static Future<Movie> getMovieById(int id) async {
    final response = await http.get(Uri.parse("$baseUrl/$id"));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Movie.fromJson(data["data"]);
    } else {
      throw Exception('Movie tidak ditemukan');
    }
  }

  static Future<bool> createMovie(Movie movie) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(movie.toJson()),
    );

    return response.statusCode == 201; // 201 Created
  }

  static Future<bool> updateMovie(Movie movie, int id) async {
    final response = await http.patch(
      Uri.parse("$baseUrl/$id"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(movie.toJson()),
    );

    return response.statusCode == 200; // 200 OK
  }

  static Future<bool> deleteMovie(int id) async {
    final response = await http.delete(Uri.parse("$baseUrl/$id"));

    return response.statusCode == 200; // 200 OK
  }
}
