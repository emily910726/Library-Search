import 'package:flutter/foundation.dart';
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
  String callNumber;
  String title;
  String author;
  String publisher;
  String year; // 4
  double price; //5 
  String page;
  int pageNumber;  //7
  String date;
  String keyword;
  int barcode; //10
  int marcCode;
  String isbn;
  String area;
  String summary;
  int unitNumber; //15
  String classificationCode;
  int typeCode; 
  String lot;   //18
  String location;

  BookLocation(callNumber, title, author, publisher, year, price, page, pageNumber, date, keyword, barcode, marcCode, isbn, area, summary, unitNumber, classificationCode, typeCode, lot, location) : 
    callNumber = callNumber,
    title = title,
    author = author,
    publisher = publisher,
    year = year,
    price = price, //4
    page = page,
    pageNumber = pageNumber,
    date = date,
    keyword = keyword,
    barcode = barcode,
    marcCode = marcCode,
    isbn = isbn,
    area = area,
    summary = summary,
    unitNumber = unitNumber,
    classificationCode = classificationCode,
    typeCode = typeCode,
    lot = lot,
    location = location;
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
      itemCount: _result.length,
      itemBuilder: (context, i) {
        // return Text('${_result[i].title}, ${_result[i].author}, ${_result[i].publisher}');
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                  Text(_result[i].title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                  Text(_result[i].author, style: TextStyle(fontSize: 12)),
                ]
              )
            )
          );
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
        debugPrint("hiiiiii");
        // for(int i = 0; i < rowsAsListOfValues.length -1; i ++){
        //   var x = rowsAsListOfValues[i];
        //   debugPrint('$i : ${x[4].runtimeType}:${x[4]} ${x[7].runtimeType} ${x[8].runtimeType} ${x[10].runtimeType} ${x[11].runtimeType}');
        // }
       
        bookLocations = rowsAsListOfValues.map(
          (x) => new BookLocation(x[0].toString(), x[1].toString(), x[2].toString(), x[3].toString(), x[4].toString(), x[5].toDouble(), x[6].toString(), x[7].toInt(), x[8].toString(), x[9].toString(), x[10].toInt(), x[11].toInt(), x[12].toString(), x[13].toString(), x[14].toString(), x[15].toInt(), x[16].toString(), x[17].toInt(), x[18].toString(), x[19].toString())
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
              TextField(
                controller: searchText
                ),
                Text(
                  '请输入书名进行查询',
                ),
                // Text(
                //   // searchText.text,
                //   _result,
                //   style: Theme.of(context).textTheme.headline4,
                // ),
                new Expanded(
                  child: _buildResult()
                )
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _incrementCounter,
            tooltip: 'Increment',
            child: Icon(Icons.search),
          ), // This trailing comma makes auto-formatting nicer for build methods.
        );
      } else {
        return CircularProgressIndicator();
      }
    });
}
