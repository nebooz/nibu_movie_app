import 'package:flutter/material.dart';
import './data/movies.dart';
import 'services.dart';
import 'globals.dart' as globals;
import 'package:intl/intl.dart';

import 'package:transparent_image/transparent_image.dart';
import 'package:percent_indicator/percent_indicator.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nibu Movie App',
      theme: ThemeData(primarySwatch: Colors.red, fontFamily: 'OpenSans'),
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
  String imageBaseUrl;

  @override
  void initState() {
    movies = getMovies();

    // This seems like a trash way of doing this...
    getConfig().then((config) {
      globals.moviePosterBaseUrl = config.images.baseUrl;
      globals.moviePosterSize = config.images.posterSizes[4];
      print(globals.moviePosterBaseUrl);
      print(globals.moviePosterSize);
    });

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
                    image: globals.moviePosterBaseUrl +
                        globals.moviePosterSize +
                        movies[index].posterPath,
                    height: 160.0,
                    width: 100.0,
                    fit: BoxFit.cover,
                  ),
                  padding: const EdgeInsets.only(
                      top: 8.0, left: 8.0, right: 4.0, bottom: 8.0),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Container(
                      //color: Colors.amberAccent,
                      height: 160.0,
                      child: Column(
                        //crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  height: 40.0,
                                  decoration: BoxDecoration(
                                    // Box decoration takes a gradient
                                    gradient: LinearGradient(
                                      // Where the linear gradient begins and ends
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      // Add one stop for each color. Stops should increase from 0 to 1
                                      stops: [0.1, 0.6, 1.0],
                                      colors: [
                                        // Colors are easy thanks to Flutter's Colors class.
                                        Colors.black,
                                        Colors.grey,
                                        Colors.white,
                                      ],
                                    ),
                                  ),
                                  padding:
                                      EdgeInsets.only(left: 8.0, right: 16.0),
                                  child: Text(
                                    movies[index].title,
                                    maxLines: 2,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'OpenSans',
                                      shadows: [
                                        Shadow(
                                            // bottomRight
                                            offset: Offset(1.0, 1.5),
                                            color: Colors.black87),
                                      ],
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                color: Colors.transparent,
                                height: 40.0,
                                width: 40.0,
                                child: CircularPercentIndicator(
                                    radius: 36.0,
                                    lineWidth: 4.0,
                                    animation: true,
                                    animationDuration: 1000,
                                    percent: movies[index].voteAverage / 10,
                                    center: RichText(
                                      text: TextSpan(
                                        text:
                                            (((movies[index].voteAverage) * 10)
                                                .toStringAsFixed(0)),
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: "%",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 6.0)),
                                        ],
                                      ),
                                    ),
                                    circularStrokeCap: CircularStrokeCap.round,
                                    progressColor: _getCircularColor(
                                        movies[index]
                                            .voteAverage) //Colors.green,
                                    ),
                              ),
                            ],
                          ),
                          Divider(
                            height: 0.0,
                          ),
                          Container(
                            height: 20.0,
                            alignment: Alignment.centerLeft,
                            // Why changing the alignment magically extends
                            // the container usage to all available horizontal space?
                            color: Colors.grey,
                            padding: EdgeInsets.only(
                                left: 8.0, top: 2.0, bottom: 2.0),
                            child: Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(right: 4.0),
                                  child: Icon(Icons.access_time,
                                      color: Colors.white, size: 12.0),
                                ),
                                RichText(
                                  text: TextSpan(
                                    text: 'Release Date:  ',
                                    style: TextStyle(fontSize: 8.0),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: _dateConversion(
                                              movies[index].releaseDate),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 8.0)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            height: 0.0,
                          ),
                          Expanded(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              movies[index].overview,
                              style: TextStyle(fontSize: 9.0),
                              maxLines: 7,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )),
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

MaterialColor _getCircularColor(double percentage) {
  if (percentage >= 7.0) {
    return Colors.green;
  } else if (percentage >= 6.0 && percentage < 7.0) {
    return Colors.lightGreen;
  } else if (percentage >= 5.0 && percentage < 6.0) {
    return Colors.yellow;
  } else if (percentage >= 4.0 && percentage < 5.0) {
    return Colors.orange;
  } else {
    return Colors.red;
  }
}

String _dateConversion(String inputDate) {
  return DateFormat.yMMMMEEEEd().format(DateTime.parse(inputDate)).toString();
}
