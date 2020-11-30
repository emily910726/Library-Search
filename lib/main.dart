import 'package:flutter/material.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart' show CsvToListConverter;
import 'dart:developer' as developer;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Library Search'),
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

class BookLocation {
  String title;
  String description;
  int isbn;

  BookLocation(title, description, isbn) : 
    title = title,
    description = description,
    isbn = isbn;
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  final searchText = TextEditingController();
  List<BookLocation> bookLocations;
  List<BookLocation> _result = [];

  Future<String> loadAsset() async {
    debugPrint('loading');
    return await rootBundle.loadString('assets/data2.csv');
  }

  Widget _buildResult() {
    return ListView.builder(
      padding: EdgeInsets.all(16.0),
      itemCount: _result.length,
      itemBuilder: (context, i) {
        return Text('${_result[i].title}');
      }
    );
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _result.clear();
      _result.addAll(bookLocations.where((x) => x.title.contains(searchText.text)).toList());
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
    future: loadAsset(),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        var csvString = snapshot.data;
        List<List<dynamic>> rowsAsListOfValues = const CsvToListConverter().convert(csvString);
        bookLocations = rowsAsListOfValues.map(
          (x) => new BookLocation(x[0], x[1], x[2])
        ).toList();

        return Scaffold(
          appBar: AppBar(
            // Here we take the value from the MyHomePage object that was created by
            // the App.build method, and use it to set our appbar title.
            title: Text(widget.title),
          ),
          body: Center(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            child: Column(
              // Column is also a layout widget. It takes a list of children and
              // arranges them vertically. By default, it sizes itself to fit its
              // children horizontally, and tries to be as tall as its parent.
              //
              // Invoke "debug painting" (press "p" in the console, choose the
              // "Toggle Debug Paint" action from the Flutter Inspector in Android
              // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
              // to see the wireframe for each widget.
              //
              // Column has various properties to control how it sizes itself and
              // how it positions its children. Here we use mainAxisAlignment to
              // center the children vertically; the main axis here is the vertical
              // axis because Columns are vertical (the cross axis would be
              // horizontal).
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
              TextField(
                controller: searchText
                ),
                Text(
                  'You have pushed the button this many times:',
                ),
                // Text(
                //   // searchText.text,
                //   _result,
                //   style: Theme.of(context).textTheme.headline4,
                // ),
                Container(
                  height: 150.0,
                  child: _buildResult()
                )
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _incrementCounter,
            tooltip: 'Increment',
            child: Icon(Icons.add),
          ), // This trailing comma makes auto-formatting nicer for build methods.
        );
      } else {
        return CircularProgressIndicator();
      }
    });
}
