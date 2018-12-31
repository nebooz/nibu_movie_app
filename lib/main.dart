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
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
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
    movies = getPost();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: FutureBuilder<Movies>(
            future: movies,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return createListView(context, snapshot);
                //return Text(snapshot.data.results[0].title);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              // By default, show a loading spinner
              return CircularProgressIndicator();
            }),
      ),
    );
  }

  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    List<Movie> movies = snapshot.data.results;
    return ListView.builder(
      itemCount: movies.length,
      itemBuilder: (BuildContext context, int index) {
        return Column(children: <Widget>[
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: globals.moviePosterUrl + movies[index].posterPath,
                    height: 160.0,
                    width: 100.0,
                    fit: BoxFit.cover,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            movies[index].title,
                            style: TextStyle(
                                fontSize: 12.0, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            "Release Date: " + movies[index].releaseDate,
                            style: TextStyle(
                                fontSize: 8.0, fontStyle: FontStyle.italic),
                            overflow: TextOverflow.ellipsis,
                          ),
                          //Expanded(child: Container()),
                        ],
                      ),
                    ),
                  )
                ],
              ))
        ]);
      },
    );
  }
}
