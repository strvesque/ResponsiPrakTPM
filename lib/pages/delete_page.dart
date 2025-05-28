import 'package:flutter/material.dart';
import 'package:responsipraktpm/models/movie_model.dart';
import 'package:responsipraktpm/services/movie_Service.dart';
import 'package:responsipraktpm/pages/home_page.dart';

class DeleteMoviePage extends StatefulWidget {
  final int id;

  const DeleteMoviePage({super.key, required this.id});

  @override
  State<DeleteMoviePage> createState() => _DeleteMoviePageState();
}

class _DeleteMoviePageState extends State<DeleteMoviePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hapus Film")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: _movieDetail(context),
      ),
    );
  }

  Widget _movieDetail(BuildContext context) {
    return FutureBuilder(
      future: ClothingApi.getMovieById(widget.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        if (!snapshot.hasData || snapshot.data!["data"] == null) {
          return const Center(child: Text("Data film tidak ditemukan."));
        }

        final clothing = Movie.fromJson(snapshot.data!['data']);

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Movie.title ?? "-",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text("Genre: ${Movie.genre ?? '-'}"),
              Text("Director: ${Movie.director ?? '-'}"),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: const Icon(Icons.delete),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () => _confirmDelete(context, clothing),
                label: const Text("Hapus Film"),
              ),
            ],
          ),
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, Movie movie) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Konfirmasi Hapus"),
        content: Text(
            "Apakah Anda yakin ingin menghapus film \"${movie.title}\"?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(dialogContext); // tutup dialog
              if (movie.id != null) {
                await _delete(context, movie.id!);
              }
            },
            child: const Text("Hapus"),
          ),
        ],
      ),
    );
  }

  Future<void> _delete(BuildContext context, int id) async {
    try {
      final response = await Movie.deleteMovie(id);

      if (response["status"] == "Success") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Pakaian berhasil dihapus")),
        );

        // Pastikan page ini ditutup, dan navigasi ke HomePage
        if (mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const HomePage()),
            (route) => false,
          );
        }
      } else {
        throw Exception(response["message"]);
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal menghapus: $error")),
      );
    }
  }
}
