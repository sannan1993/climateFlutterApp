import 'dart:convert';
import 'package:flutter/material.dart';
import 'apiFile.dart' as util;
import 'package:http/http.dart' as http;

double Celsius=0;
int CelsiusInt=0;

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
          ),
          Center(
            child: Image(
              image: AssetImage('images/light_rain.png'),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(30.0, 90.0, 0.0, 0.0),
            child: updateTempWidget('Karachi'),
          ),
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

  Widget updateTempWidget(String city) {
    return FutureBuilder(
        future: getWeather(util.apiId, city == null ? util.city : city),
        builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
          //where we get all of the json data, we setup widgets etc.
          if (snapshot.hasData) {
            Map? content = snapshot.data;
            Celsius = ((content!['main']['temp'])-32)*5/9;
            CelsiusInt = Celsius.round();
            return Container(
              margin: const EdgeInsets.fromLTRB(30.0, 250.0, 0.0, 0.0),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new ListTile(
                    title: new Text(
                      CelsiusInt.toString() + " C",
                      style: new TextStyle(
                          fontStyle: FontStyle.normal,
                          fontSize: 49.9,
                          color: Colors.white,
                          fontWeight: FontWeight.w500),
                    ),
                    subtitle: new ListTile(
                      title: new Text(
                        "Humidity: ${content['main']['humidity'].toString()}\n"
                            "Min: ${content['main']['temp_min'].toString()} F\n"
                            "Max: ${content['main']['temp_max'].toString()} F ",
                        style: extraData(),
                      ),
                    ),
                  )
                ],
              ),
            );
          } else {
            return Container();
          }
        });
  }
}

TextStyle KcityName() {
  return TextStyle(
      fontWeight: FontWeight.w500, fontSize: 20, color: Colors.white,fontStyle: FontStyle.italic);
}

TextStyle extraData() {
  return const TextStyle(
      color: Colors.white70, fontStyle: FontStyle.normal, fontSize: 17.0);
}