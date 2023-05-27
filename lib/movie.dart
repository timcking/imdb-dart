import 'package:imdb/networking.dart';

const urlMovie = 'https://imdb-api.com/en/API/SearchMovie/k_9o5e5q08/';
const urlMovieDetail = 'https://imdb-api.com/en/API/Title/k_9o5e5q08/';

class Movie {
  Future<dynamic> getMovieList(String searchTerm) async {
    var url = urlMovie + searchTerm;

    NetworkHelper networkHelper = NetworkHelper(url);

    var movieData = await networkHelper.getData();
    return movieData;
  }

  Future<dynamic> getMovieDetail(String searchTerm) async {
    var url = urlMovieDetail + searchTerm;

    NetworkHelper networkHelper = NetworkHelper(url);

    var movieDetailData = await networkHelper.getData();
    return movieDetailData;
  }
}
