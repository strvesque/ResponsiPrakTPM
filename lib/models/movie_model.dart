class MovieModel {
  String? status;
  String? message;
  List<Movie>? data;

  MovieModel({this.status, this.message, this.data});

  MovieModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Movie>[];
      json['data'].forEach((v) {
        data!.add(Movie.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Movie {
  int? id;
  String? title;
  int? year;
  double? rating;
  String? genre;
  String? director;
  String? synopsis;

  Movie({
    this.id,
    this.title,
    this.year,
    this.rating,
    this.genre,
    this.director,
    this.synopsis,
  });

  Movie.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    year = json['year'];
    rating = json['rating'];
    genre = json['genre'];
    director = json['director']?.toDouble();
    synopsis = json['synopsis'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['year'] = year;
    data['rating'] = rating;
    data['genre'] = genre;
    data['director'] = director;
    data['synopsis'] = synopsis;
    return data;
  }
}