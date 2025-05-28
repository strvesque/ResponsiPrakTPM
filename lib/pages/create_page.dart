import 'package:flutter/material.dart';
import 'package:responsipraktpm/models/movie_model.dart';
import 'package:responsipraktpm/services/movie_service.dart';
import 'package:responsipraktpm/pages/home_page.dart';

class CreateMoviePage extends StatefulWidget {
  const CreateMoviePage({super.key});

  @override
  State<CreateMoviePage> createState() => _CreateMoviePageState();
}

class _CreateMoviePageState extends State<CreateMoviePage> {
  final title = TextEditingController();
  final year = TextEditingController();
  final rating = TextEditingController();
  final genre = TextEditingController();
  final director = TextEditingController();
  final synopsis = TextEditingController();
  final image = TextEditingController();
  final url = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Future<void> _createMovie(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    try {
      Movie newMovie = Movie(
        title: title.text.trim(),
        year: int.tryParse(year.text),
        rating: double.tryParse(rating.text),
        genre: genre.text.trim(),
        director: director.text.trim(),
        synopsis: synopsis.text.trim(),
        imgUrl: image.text.trim(),
        movieUrl: url.text.trim(),
      );

      final response = await MovieService.createMovie(newMovie);

      if (response == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Berhasil menambah film baru")),
        );
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomePage()),
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
      appBar: AppBar(title: const Text("Tambah Film")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(controller: title, label: "Judul"),
              _buildTextField(
                  controller: year,
                  label: "Tahun",
                  keyboardType: TextInputType.number),
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
                onPressed: () => _createMovie(context),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child:
                    const Text("Tambah Film", style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
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
