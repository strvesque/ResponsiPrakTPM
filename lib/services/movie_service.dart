import 'dart:convert';
import 'package:responsipraktpm/models/movie_model.dart';
import 'package:http/http.dart' as http;

class ClothingApi {
  static const url =
      "https://tpm-api-responsi-a-h-872136705893.us-central1.run.app/api/v1/";

  static Future<Map<String, dynamic>> getMovie() async {
    final response = await http.get(Uri.parse(url));
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> createMovie(Movie movie) async {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(movie.toJson()),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> getMovieById(int id) async {
    final response = await http.get(Uri.parse("$url/$id"));
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> updateMovie(
      Movie movie, int id) async {
    final response = await http.put(
      Uri.parse("$url/$id"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(movie.toJson()),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> deleteMovie(int id) async {
    final response = await http.delete(Uri.parse("$url/$id"));
    return jsonDecode(response.body);
  }
}