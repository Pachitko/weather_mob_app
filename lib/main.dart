import 'package:flutter/material.dart';
import 'package:weatherapp/pages/weather_details_page.dart';
import 'package:intl/intl.dart';
import 'models/weather_model.dart';
import 'services/weather_service.dart';

void main() {
  runApp(const WeatherForecast());
}

class WeatherForecast extends StatefulWidget {
  const WeatherForecast({super.key});

   @override
    State<StatefulWidget> createState() {
    return WeatherForecastState();
  }
}

class WeatherForecastState extends State<WeatherForecast>
{
  final TextEditingController _cityTextBox = TextEditingController();

  final _weatherService = WeatherService("c341e34f9b7c327502cde34aa7817c5f");

  final List<String> days = [
    'Понедельник',
    'Вторник',
    'Среда',
    'Четверг',
    'Пятница',
    'Суббота',
    'Воскресенье'
  ];

  String _currentCity = "";
  List<Weather> _forecast = List<Weather>.empty();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      initAsync();
    });
  }

  initAsync() async {
    var currentCity = await _weatherService.getCurrentCity();
    var forecast = await _weatherService.GetForecast(currentCity);

    setState(() {
      _currentCity = currentCity;
      _forecast = forecast;
    });
  }

  void _onCardPressed(BuildContext context, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => WeatherDetailsPage(cityName: _currentCity, dayFromNow: index)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Weather Forecast',
        theme: ThemeData(
            primarySwatch: Colors.blue,
            brightness: Brightness.dark
        ),
        home: SafeArea(child: Scaffold(
          appBar: AppBar(
            title: Text(_currentCity),
          ),
          body: SizedBox(
            height: WidgetsBinding
                .instance.platformDispatcher.views.first.physicalSize.height,
            child: Column(children: [
              Text(_currentCity),
              TextField(
                controller: _cityTextBox,
                onSubmitted: (value) async {
                  var forecast = await _weatherService.GetForecast(_cityTextBox.text);

                  setState(() {
                    _currentCity = _cityTextBox.text;
                    _forecast = forecast;
                  });
                },
                decoration: const InputDecoration(
                  labelText: "City name",
                  border: OutlineInputBorder()),),
              Expanded(child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: _forecast.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () => _onCardPressed(context, index),
                    child: Container(
                      width: 150,
                      margin: const EdgeInsets.all(10),
                      child: Card(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "${DateFormat("yyyy-MM-dd").format(DateTime.now().add(Duration(days: index)))} ${days[index % days.length]}",
                              style: const TextStyle(fontSize: 18),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              _forecast[index].temperature.toString(),
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),)
            ],)
          ),
        ),
      )
    );
  }
}
