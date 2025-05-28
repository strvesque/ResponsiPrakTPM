import 'package:flutter/material.dart';
import 'package:responsipraktpm/models/movie_model.dart';
import 'package:responsipraktpm/services/movie_service.dart';
import 'package:responsipraktpm/pages/home_page.dart';

class EditPage extends StatefulWidget {
  final int id;

  const EditPage({super.key, required this.id});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final title = TextEditingController();
  final year = TextEditingController();
  final rating = TextEditingController();
  final genre = TextEditingController();
  final director = TextEditingController();
  final synopsis = TextEditingController();
  final image = TextEditingController();
  final url = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isDataLoaded = false;

  Future<void> _updateMovie(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    try {
      Movie updatedMovie = Movie(
        id: widget.id,
        title: title.text.trim(),
        year: int.tryParse(year.text),
        rating: double.tryParse(rating.text),
        genre: genre.text.trim(),
        director: director.text.trim(),
        synopsis: synopsis.text.trim(),
        imgUrl: image.text.trim(),
        movieUrl: url.text.trim(),
      );

      final response = await MovieService.updateMovie(updatedMovie, widget.id);

      if (response == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Berhasil mengubah Film ${updatedMovie.title}")),
        );
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
      } else {
        throw Exception(response);
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
      appBar: AppBar(title: const Text("Edit Film")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: FutureBuilder(
          future: MovieService.getMovieById(widget.id),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData) {
              if (!_isDataLoaded) {
                Movie movie = snapshot.data!;
                title.text = movie.title ?? '';
                year.text = movie.year?.toString() ?? '';
                rating.text = movie.rating?.toString() ?? '';
                genre.text = movie.genre ?? '';
                director.text = movie.director ?? '';
                synopsis.text = movie.synopsis ?? '';
                image.text = movie.imgUrl ?? '';
                url.text = movie.movieUrl ?? '';
                _isDataLoaded = true;
              }

              return Form(
                key: _formKey,
                child: ListView(
                  children: [
                    _buildTextField(controller: title, label: "Judul"),
                    _buildTextField(controller: year, label: "Tahun", keyboardType: TextInputType.number),
                    _buildTextField(
                      controller: rating,
                      label: "Rating",
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        final val = double.tryParse(value ?? '');
                        if (val == null) return "Rating harus berupa angka";
                        if (val < 0 || val > 5) return "Rating harus 0 - 5";
                        return null;
                      },
                    ),
                    _buildTextField(controller: genre, label: "Genre"),
                    _buildTextField(controller: director, label: "Director"),
                    _buildTextField(controller: synopsis, label: "Sinopsis"),
                    _buildTextField(controller: image, label: "URL Gambar"),
                    _buildTextField(controller: url, label: "URL Website Film"),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => _updateMovie(context),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text("Simpan Perubahan", style: TextStyle(fontSize: 16)),
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
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        validator: validator ??
            (value) {
              if (value == null || value.trim().isEmpty) {
                return "$label tidak boleh kosong";
              }
              return null;
            },
      ),
    );
  }
}