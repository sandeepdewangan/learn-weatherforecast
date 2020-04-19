import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';

/*
Package for getting currrent location -> geolocator
Package for http request -> http
Dart Package for converting JSON -> convert.dart -> jsonDecode()

----------------
AWAIT & ASYNC
----------------
-> What async does is tell flutter that the function is asynchronous,
and it does not depend on other code, so it can run in parallel to other async functions.
-> What await tells flutter is to wait at that line of code, until the function has returned a value,
as code after await may be dependable on value returned by the function.

To Get Promise of Something that will return in future we will USE -> Future<Position>
We will get instance of position.

----------------
Widget Life Cycle
----------------
void initState()
build()
void deactivate()

----------------
XML vs JSON
----------------
XML : <key>Value</key>
JSON : {key:value}

----------------
Passing Data to a State Object
----------------
class MyApp{
  String weather;
  // Setting via Constructor
}
class MyApp_State{
  accessing-> widget.weather;
}

------------------------------------------------
Passing Data Backwards Through Navigation Stack
------------------------------------------------

Navigator.pop(context, passVariable)
var name = await Navigator.push();


 */


void main() => runApp(
    MaterialApp(
      home: Scaffold(
        body: MyWeatherApp(),
      ),
    ),
);

class MyWeatherApp extends StatefulWidget {
  @override
  _MyWeatherAppState createState() => _MyWeatherAppState();
}

class _MyWeatherAppState extends State<MyWeatherApp> {

  String city = '';
  String weather = '';
  Icon weatherIcon;
  Position pos;
  Response response;

  @override
  void initState(){
    super.initState();
    getCurrentLocaton();
  }

  getWeatherData() async{
    response = await get('https://api.openweathermap.org/data/2.5/weather?lat=${pos.latitude}&lon=${pos.longitude}&appid=6923275964a074a5644251db32c364cc');
  }

  getCurrentLocaton() async{
    pos = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
    print(pos.latitude);
    print(pos.longitude);
    await getWeatherData();

    reloadWiget();
  }
  reloadWiget(){
    setState(() {
      city = jsonDecode(response.body)['name'];
      weather = jsonDecode(response.body)['weather'][0]['description'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return response != null ? Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
          child: Text(
            city.toUpperCase(),
            style: TextStyle(
                color: Colors.black54,
                fontSize: 70.0,
                fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 30.0,),
        Center(
          child: Text(
            weather,
            style: TextStyle(
              color: Colors.blue,
              fontSize: 50.0,
              fontWeight: FontWeight.bold
            ),
          ),
        ),
        Icon(
            Icons.gamepad,
          color: Colors.teal,
          size: 60.0,
        ),
        Text('hii'),
        Text('another hii'),
      ],
    ) : Center(child: CircularProgressIndicator());
  }
}
