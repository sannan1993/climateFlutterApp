import 'dart:convert';
import 'package:flutter/material.dart';
import 'apiFile.dart' as util;
import 'package:http/http.dart' as http;

class climateApp extends StatefulWidget {
  const climateApp({Key? key}) : super(key: key);

  @override
  State<climateApp> createState() => _climateAppState();
}

class _climateAppState extends State<climateApp> {
  @override
  void showStuff() async{
    Map data = await getWeather(util.apiId, util.city);
    print(data.toString());
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("Climate app"),
        ),
        backgroundColor: Colors.red,
        actions: [
          IconButton(
              onPressed: () {
                showStuff();
              },
              icon: Icon(Icons.menu))
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: Image(image: AssetImage('images/umbrella.png'),
              width: 500,
              height: 1200,
              fit: BoxFit.fill,),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 15, 15, 0),
            alignment: Alignment.topRight,
            child: Text('Karachi', style: KcityName(),),
          )
        ],
      ),
    );
  }
  Future <Map> getWeather (String apiId, String city) async
  {
    String apiUrl = 'https://api.openweathermap.org/data/2.5/weather?q=$city&appid='
        '${util.apiId}&units=imperial';
    //https://api.openweathermap.org/data/2.5/weather?q=Karachi&appid=29ad10ea8524b4f70897c6a096210b8d
    http.Response response=await http.get(Uri.parse(apiUrl));
    return json.decode(response.body);
  }
}

TextStyle KcityName() {
  return TextStyle(
      fontWeight: FontWeight.w500, fontSize: 20, color: Colors.white,fontStyle: FontStyle.italic);
}