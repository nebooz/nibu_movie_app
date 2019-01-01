import 'package:flutter/material.dart';
import 'movies_def.dart';
import 'services.dart';
import 'globals.dart' as globals;

import 'package:transparent_image/transparent_image.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nibu Movie App',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(title: 'Nibu Movie App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<Movies> movies;

  @override
  void initState() {
    movies = getMovies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: FutureBuilder<Movies>(
          future: movies,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return createListView(context, snapshot);
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }

            // By default, show a loading spinner
            return CircularProgressIndicator();
          }),
    );
  }

  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    List<Movie> movies = snapshot.data.results;
    return ListView.builder(
      itemCount: movies.length,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  child: FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: globals.moviePosterUrl + movies[index].posterPath,
                    height: 160.0,
                    width: 100.0,
                    fit: BoxFit.cover,
                  ),
                  padding: const EdgeInsets.all(8.0),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Container(
                      color: Colors.amberAccent,
                      height: 160.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    movies[index].title,
                                    maxLines: 2,
                                    style: TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                color: Colors.red,
                                height: 40.0,
                                width: 40.0,
                                child: Text(
                                  movies[index].voteAverage.toString(),
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            height: 0.0,
                          ),
                          Container(
                            color: Colors.grey,
                            padding: EdgeInsets.only(
                                left: 8.0, top: 2.0, bottom: 2.0),
                            child: Text(
                              'Release Date: ' + movies[index].releaseDate,
                              style: TextStyle(
                                  fontSize: 8.0, fontStyle: FontStyle.italic),
                            ),
                          ),
                          Divider(
                            height: 0.0,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Divider(height: 2.0),
          ],
        );
      },
    );
  }
}
