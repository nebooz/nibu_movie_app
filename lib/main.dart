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
            return Center(child: CircularProgressIndicator());
          }),
    );
  }

  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    MaterialColor progressColor;
    List<Movie> movies = snapshot.data.results;
    return ListView.builder(
      itemCount: movies.length,
      itemBuilder: (BuildContext context, int index) {
        progressColor = _getCircularColor(movies[index].voteAverage);
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
                      top: 4.0, left: 8.0, right: 4.0, bottom: 4.0),
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
                              Stack(
                                alignment: AlignmentDirectional.center,
                                children: <Widget>[
                                  Container(
                                    width: 44.0,
                                    height: 40.0,
                                    color: Colors.grey[700],
                                  ),
                                  Container(
                                    width: 36.0,
                                    height: 36.0,
                                    decoration: new BoxDecoration(
                                      color: Colors.black,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    color: Colors.transparent,
                                    height: 36.0,
                                    width: 36.0,
                                    child: CircularPercentIndicator(
                                      radius: 32.0,
                                      lineWidth: 4.0,
                                      animation: true,
                                      animationDuration: 1000,
                                      percent: movies[index].voteAverage / 10,
                                      center: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            (((movies[index].voteAverage) * 10)
                                                .toStringAsFixed(0)),
                                            style: TextStyle(
                                                fontSize: 11.0,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "%",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 6.0),
                                          )
                                        ],
                                      ),
                                      circularStrokeCap:
                                          CircularStrokeCap.round,
                                      progressColor: progressColor,
                                      backgroundColor: progressColor.shade900,
                                    ),
                                  ),
                                ],
                              ),
                              Expanded(
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  height: 40.0,
                                  color: Colors.grey[500],
                                  padding:
                                      EdgeInsets.only(left: 8.0, right: 8.0),
                                  child: Text(
                                    movies[index].title,
                                    maxLines: 2,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'OpenSans',
                                      /*shadows: [
                                        Shadow(
                                            // bottomRight
                                            offset: Offset(1.0, 1.5),
                                            color: Colors.black87),
                                      ],*/
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: 20.0,
                            alignment: Alignment.centerLeft,
                            // Why changing the alignment magically extends
                            // the container usage to all available horizontal space?
                            color: Colors.grey[400],
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
                            child: Container(
                              color: Colors.grey[300],
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 12.0,
                                    right: 12.0,
                                    top: 8.0,
                                    bottom: 8.0),
                                child: Center(
                                  child: Text(
                                    movies[index].overview,
                                    style:
                                        TextStyle(fontSize: 9.0, height: 1.2),
                                    maxLines: 5,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Divider(height: 1.0),
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
