class MovieListResponse {
  String? status;
  String? message;
  List<Movie>? data;

  MovieListResponse({this.status, this.message, this.data});

  MovieListResponse.fromJson(Map<String, dynamic> json) {
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
  String? imgUrl;

  // Optional: bisa dipakai di detail
  String? genre;
  String? director;
  String? synopsis;
  String? movieUrl;

  Movie({
    this.id,
    this.title,
    this.year,
    this.rating,
    this.imgUrl,
    this.genre,
    this.director,
    this.synopsis,
    this.movieUrl,
  });

  Movie.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    year = json['year'];
    rating = json['rating']?.toDouble();
    imgUrl = json['imgUrl'];
    genre = json['genre'];
    director = json['director'];
    synopsis = json['synopsis'];
    movieUrl = json['movieUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['year'] = year;
    data['rating'] = rating;
    data['imgUrl'] = imgUrl;
    data['genre'] = genre;
    data['director'] = director;
    data['synopsis'] = synopsis;
    data['movieUrl'] = movieUrl;
    return data;
  }
}