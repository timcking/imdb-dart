import 'package:flutter/material.dart';
import 'package:imdb/movie.dart';
import 'package:imdb/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key, this.imdbId}) : super(key: key);

  final imdbId;

  @override
  _DetailPageState createState() => _DetailPageState();
}

// ignore: must_be_immutable
class _DetailPageState extends State<DetailPage> {
  Movie movie = Movie();
  var movieDetail;
  bool isLoading = false;

  String imdbDetailId = '';
  String? movieTitle = '';
  String? movieYear = '';
  String? moviePoster = '';
  String? movieDirector = '';
  String? movieRuntime = '';
  String? movieRated = '';
  String? movieGenre = '';
  String? moviePlot = '';
  String? movieActors = '';

  @override
  void initState() {
    super.initState();
    imdbDetailId = widget.imdbId;
    buildMovie(imdbDetailId);
  }

  void buildMovie(imdbDetailId) async {
    setState(() {
      isLoading = true;
    });

    movieDetail = await movie.getMovieDetail(imdbDetailId);

    setState(() {
      movieTitle = movieDetail['title'];
      movieYear = movieDetail['year'];
      moviePoster = movieDetail['image'];
      movieDirector = movieDetail['directors'];
      movieRuntime = movieDetail['runtimeStr'];
      movieRated = movieDetail['contentRating'];
      movieGenre = movieDetail['genres'];
      moviePlot = movieDetail['plot'];

      // convert comma separated string to list
      var tk = movieDetail['stars'].toString().split(',').toList();
      int count = tk.length;

      var tk2 = tk.toString();
      var tk3 = tk2.split(',');
      var tk4 = tk3.toList();
      var tk5 = tk4.join(', ');
      movieActors = tk5;

      movieActors = movieDetail['stars'].toString();
      isLoading = false;
    });
  }

  _launchURL() async {
    var url = 'https://www.imdb.com/title/$imdbDetailId';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
            onTap: _launchURL,
            child: Text(
              '$movieTitle',
              style: const TextStyle(
                decoration: TextDecoration.underline,
              ),
            )),
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        // decoration: BoxDecoration(
        //   color: Colors.indigo,
        // ),
        constraints: const BoxConstraints.expand(),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 10.0),
            isLoading
                ? const SpinKitDoubleBounce(
                    color: Colors.purple,
                    size: 60.0,
                  )
                : Image(
                    height: 180,
                    width: 200,
                    image: NetworkImage(moviePoster!),
                  ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Year',
                  style: kLabelStyle,
                ),
                const SizedBox(width: 10.0),
                Text(
                  '$movieYear',
                  style: kDataStyle,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Director',
                  style: kLabelStyle,
                ),
                const SizedBox(width: 10.0),
                Text(
                  '$movieDirector',
                  style: kDataStyle,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Runtime',
                  style: kLabelStyle,
                ),
                const SizedBox(width: 10.0),
                Text('$movieRuntime', style: kDataStyle),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Rated',
                  style: kLabelStyle,
                ),
                const SizedBox(width: 10.0),
                Text('$movieRated', style: kDataStyle),
              ],
            ),
            const SizedBox(height: 10.0),
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              // ignore: prefer_const_literals_to_create_immutables
              children: <Widget>[
                Text(
                  'Plot',
                  style: kLabelStyle,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Text(
                      '$moviePlot',
                      maxLines: 11,
                      style: kPlotStyle,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              // ignore: prefer_const_literals_to_create_immutables
              children: <Widget>[
                Text(
                  'Cast',
                  style: kLabelStyle,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(
                  width: 320,
                  child: Text(
                    '$movieActors',
                    style: kPlotStyle,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
