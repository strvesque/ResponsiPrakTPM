import 'package:flutter/material.dart';
import 'package:responsipraktpm/models/movie_model.dart';
import 'package:responsipraktpm/services/movie_service.dart';
import 'package:responsipraktpm/pages/home_page.dart';

class EditPage extends StatefulWidget {
  final int id;

  const EditingPage({super.key, required this.id});

  @override
  State<EditPage> createState() => _EditClothingPageState();
}

class _EditClothingPageState extends State<EditPage> {
  final Title = TextEditingController();
  final Year = TextEditingController();
  final color = TextEditingController();
  final rating = TextEditingController();
  final genre = TextEditingController();
  final director = TextEditingController();
  final synopsis = TextEditingController();
  factory

  final _formKey = GlobalKey<FormState>();
  bool _isDataLoaded = false;

  Future<void> _updateMovie(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    try {
      Movie updatedMovie = Movie(
        id: widget.id,
        title: Title.text.trim(),
        year: int.tryParse(rating.text),
        rating: double.tryParse(rating.text),
        genre: genre.text.trim(),
        director: director.text.trim(),
        synopsis: synopsis.text.trim(),,
      );

      final response =
          await ClothingApi.updateMovie(updatedMovie, widget.id);

      if (response["status"] == "Success") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text("Berhasil mengubah Film ${updatedMovie.title}")),
        );
        Navigator.pop(context);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
      } else {
        throw Exception(response["message"]);
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal: $error")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Update Film"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: FutureBuilder(
          future: Movie.getMovieById(widget.id),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else if (snapshot.hasData) {
              if (!_isDataLoaded) {
                _isDataLoaded = true;
                final movie = Movie.fromJson(snapshot.data!["data"]);
                Title.text = movie.title ?? '';
                Year.text = movie.year?.toString() ?? '';
                rating.text = movie.rating?.toString() ?? '';
                genre.text = movie.genre ?? '';
                director.text = movie.director ?? '';
                synopsis.text = movie.synopsis ?? '';
              }

              return Form(
                key: _formKey,
                child: ListView(
                  children: [
                    _buildTextField(controller: Title, label: "Judul Film"),
                    _buildTextField(controller: genre, label: "Genre"),
                    _buildTextField(
                        controller: Year,
                        label: "Tahun",
                        keyboardType: TextInputType.number),
                    _buildTextField(controller: director, label: "Direktor"),
                    _buildTextField(controller: synopsis, label: "Sinopsis"),
                    _buildTextField(
                        controller: rating,
                        label: "Rating",
                        keyboardType: TextInputType.number),
                    ElevatedButton(
                      onPressed: () => _updateMovie(context),
                      child: const Text("Update Film"),
                    ),
                  ],
                ),
              );
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return "$label tidak boleh kosong";
          }
          return null;
        },
      ),
    );
  }
}
