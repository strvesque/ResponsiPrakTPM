import 'package:flutter/material.dart';
import 'package:responsipraktpm/models/movie_model.dart';
import 'package:responsipraktpm/services/movie_service.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailMoviePage extends StatelessWidget {
  final int id;

  const DetailMoviePage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail Film")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: _movieDetail(),
      ),
    );
  }

  Widget _movieDetail() {
    return FutureBuilder(
      future: MovieService.getMovieById(id),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error.toString()}"));
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          Movie movie = snapshot.data!;
          return _movie(movie);
        } else {
          return const Center(child: Text("Data tidak ditemukan."));
        }
      },
    );
  }

  Widget _movie(Movie movie) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (movie.imgUrl != null)
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  movie.imgUrl!,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          const SizedBox(height: 20),
          Text(
            movie.title ?? "-",
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _infoText("Tahun", movie.year?.toString()),
          _infoText("Rating", movie.rating?.toString()),
          _infoText("Genre", movie.genre),
          _infoText("Director", movie.director),
          _infoText("Sinopsis", movie.synopsis),
          const SizedBox(height: 20),
          if (movie.movieUrl != null)
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  final uri = Uri.parse(movie.movieUrl!);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri);
                  } else {
                    // Handle error
                  }
                },
                child: const Text("Buka Website Film"),
              ),
            ),
        ],
      ),
    );
  }

  Widget _infoText(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        "$label: ${value ?? '-'}",
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
