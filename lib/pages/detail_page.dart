import 'package:flutter/material.dart';
import 'package:responsipraktpm/models/movie_model.dart';
import 'package:responsipraktpm/services/movie_service.dart';

class DetailMoviePage extends StatelessWidget {
  final int id;

  const DetailMoviePage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail Pakaian")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: _clothingDetail(),
      ),
    );
  }

  Widget _clothingDetail() {
    return FutureBuilder(
      future: ClothingApi.getMovieById(id),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Error: ${snapshot.error.toString()}");
        } else if (snapshot.hasData) {
          // Ambil data "data" dari response
          Movie movie = Movie.fromJson(snapshot.data!["data"]);
          return _movie(movie);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _movie(Movie movie) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(movie.title ?? "-",
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _infoText("Tahun", movie.year?.toString()),
          _infoText("Rating", movie.rating?.toString()),
          _infoText("Genre", movie.genre),
          _infoText("Director", movie.director),
          _infoText("Sinopsis", movie.synopsis),
        ]
      ),
    );
  }

  Widget _infoText(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child:
          Text("$label: ${value ?? '-'}", style: const TextStyle(fontSize: 16)),
    );
  }
}
