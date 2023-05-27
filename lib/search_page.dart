import 'package:flutter/material.dart';
import 'package:imdb/movie.dart';
import 'package:imdb/detail_page.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key, String? title}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String movieSearch = '';
  Movie movie = Movie();
  var movieData;
  bool isLoading = false;

  List<String> listTitle = [];
  List<String> listYear = [];
  List<String> listImdbId = [];
  List<String> listPoster = [];

  void buildMovieList() {
    if (movieData['Response'] == 'False') {
      print('Movie not found');
      return;
    }

    setState(() {
      listTitle.clear();
      listYear.clear();
      listImdbId.clear();
      listPoster.clear();

      // Returns a max of 10 records
      // var myResults = this.movieData['results'];
      // int count = myResults.length;
      int count = movieData['results'].length;
      if (count > 10) {
        count = 10;
      }

      for (int i = 0; i < count; i++) {
        listTitle.add(movieData['results'][i]['title']);
        listYear.add(movieData['results'][i]['description']);
        listImdbId.add(movieData['results'][i]['id']);
        listPoster.add(movieData['results'][i]['image']);
      }

      isLoading = false;
    });
  }

  void getMovieDetail(String movieId) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return DetailPage(imdbId: movieId);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // decoration: const BoxDecoration(
        //   color: Colors.indigo,
        // ),
        constraints: const BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              isLoading ?
              const SpinKitDoubleBounce(
                color: Colors.purple,
                size: 60.0,
              )
              :
              Container(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                  ),
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () async {
                        setState(() {
                        isLoading = true;
                        });
                        movieData = await movie.getMovieList(movieSearch);
                        buildMovieList();
                      },
                      icon: const Icon(Icons.search),
                      iconSize: 35.0,
                      color: Colors.black,
                    ),
                    filled: true,
                    fillColor: Colors.tealAccent,
                    hintText: 'Search Movie',
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                    ),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (value) {
                    movieSearch = value;
                  },
                ),
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: listTitle.length,
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(),
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        getMovieDetail(listImdbId[index]);
                      },
                      title: Align(
                          child: Text(
                            listTitle[index],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20.0, // insert your font size here
                            ),
                          ),
                          alignment: Alignment.centerLeft),
                      subtitle: Align(
                        child: Text(
                          listYear[index],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18.0, // insert your font size here
                          ),
                        ),
                        alignment: Alignment.centerRight,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
