import 'package:flutter/material.dart';
import 'package:flutter_dust/models/airresult.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

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
      ),
      home: Main(),
    );
  }
}

class Main extends StatefulWidget {
  const Main({Key key}) : super(key: key);

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  AirResult _result;

  Future<AirResult> fetchData() async {
    var response = await http.get(
        'https://api.airvisual.com/v2/nearest_city?key=868ce6ce-a919-4e8f-8cfa-7eef8fe7e69c');

    AirResult result = AirResult.fromJson(json.decode(response.body));

    return result;
  }

  @override
  void initState() {
    super.initState();

    fetchData().then((airResult) {
      setState(() {
        _result = airResult;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _result == null
            ? CircularProgressIndicator()
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '현재 위치 미세먼지',
                        style: TextStyle(fontSize: 30),
                      ),
                      SizedBox(
                        width: 16.0,
                      ),
                      Card(
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Image.network(
                                    'https://airvisual.com/images/${_result.data.current.weather.ic}.png',
                                    width: 32,
                                    height: 32,
                                  ),
                                  Text(
                                    '${_result.data.current.pollution.aqius}',
                                    style: TextStyle(fontSize: 40),
                                  ),
                                  Text(
                                    getString(_result),
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                              color: getColor(_result),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: <Widget>[
                                      Image.network(
                                        'https://airvisual.com/images/${_result.data.current.weather.ic}.png',
                                        width: 32,
                                        height: 32,
                                      ),
                                      Text(
                                        '${_result.data.current.pollution.aqius}',
                                        style: TextStyle(fontSize: 40),
                                      ),
                                      SizedBox(
                                        width: 16,
                                      ),
                                      Text(
                                        '${_result.data.current.weather.tp}',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                                Text('습도 ${_result.data.current.weather.hu}'),
                                Text('풍속 ${_result.data.current.weather.ws}'),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 16.0,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: MaterialButton(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 50),
                          onPressed: () {},
                          color: Colors.orange,
                          child: Icon(
                            Icons.refresh,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Color getColor(AirResult result) {
    if (result.data.current.pollution.aqius <= 50) {
      return Colors.greenAccent;
    } else if (result.data.current.pollution.aqius <= 100) {
      return Colors.yellow;
    } else if (result.data.current.pollution.aqius <= 150) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  String getString(AirResult result) {
    if (result.data.current.pollution.aqius <= 50) {
      return '좋';
    } else if (result.data.current.pollution.aqius <= 100) {
      return '보';
    } else if (result.data.current.pollution.aqius <= 150) {
      return '나쁨';
    } else {
      return '최악';
    }
  }
}
