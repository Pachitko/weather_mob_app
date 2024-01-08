import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../models/weather_model.dart';
import '../services/weather_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.cityName, required this.dayFromNow});

  final String cityName;
  final int dayFromNow;

  @override
  State createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _weatherService = WeatherService("c341e34f9b7c327502cde34aa7817c5f");
  Weather? _weather;
  bool fetchError = false;

  _fetchWeather() async {
    try {
      final forecast = await _weatherService
          .GetForecast(widget.cityName)
          .timeout(const Duration(seconds: 60));
      setState(() {
        _weather = forecast[widget.dayFromNow];
      });
    }

// если есть ошибки, то:
    catch (e) {
      setState(() {
        fetchError = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
// получение погоды при запуске
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    if (_weather != null) {
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(getBackgroundImage()),
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.2), BlendMode.dstATop),
              )),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 70, 0, 0),
            child: Center(
              child:
              Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                Text(_weather?.cityName ?? "Город",
                    style: const TextStyle(
                        fontFamily: '.SF UI Text',
                        fontSize: 45,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87)),
                Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Lottie.asset("assets/${_weather?.icon ?? "01d"}.json",
                        height: 225, width: 225),
                    Text(
                      '${_weather?.temperature.round()}°C',
                      style: const TextStyle(
                          fontFamily: '.SF UI Text',
                          fontSize: 50,
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.italic),
                    )
                  ],
                ),
                Text(_weather?.description ?? "Описание",
                    style: const TextStyle(
                        fontFamily: '.SF UI Text',
                        fontSize: 25,
                        fontStyle: FontStyle.italic,
                        color: Colors.black87)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Image.asset('assets/gauge.png', height: 50, width: 50),
                    Text('${_weather?.pressure.round().toString()} мм.рт.с.' ??
                        "Давление"),
                    Image.asset('assets/wind.png', height: 50, width: 50),
                    Text('${_weather?.speed} м/с' ?? "Скорость ветра"),
                    Image.asset('assets/humidity.png', height: 50, width: 50),
                    Text('${_weather?.humidity}%' ?? "Влажность"),
                  ],
                ),
              ]),
            ),
          ),
        ),
      );
    } else if (fetchError == false) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else if (fetchError == true) {
      return const Scaffold(
        body: Center(
          child: SelectableText(
            "Проверьте подключение к интернету!",
            style: TextStyle(fontSize: 12),
          ),
        ),
      );
    } else {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}

String getBackgroundImage() {
  var hourNow = int.parse(DateFormat('kk').format(DateTime.now()));
  if (hourNow >= 23 || hourNow < 4) {
    return 'assets/images/1.jpg';
  } else if (hourNow >= 4 && hourNow < 12) {
    return 'assets/images/2.jpg';
  } else if (hourNow >= 12 && hourNow < 17) {
    return 'assets/images/3.jpg';
  } else {
    return 'assets/images/4.jpg';
  }
}

// Класс "HomePage" является изменяемым виджетом состояния и наследуется от класса
//  "StatefulWidget". В конструкторе класса указывается ключ 'key' и используется
//  вызов конструктора суперкласса.

// Класс "_HomePageState" является состоянием виджета "HomePage" и наследуется от
// класса "State". В этом классе определены методы и переменные для получения и
// отображения данных о погоде.

// Метод "_fetchWeather" асинхронно получает текущий город и погодные данные с
// использованием экземпляра класса "WeatherService". После получения данных,
// метод обновляет состояние виджета с помощью метода "setState". Если возникают
// ошибки, исключение обрабатывается и выводится сообщение об ошибке.

// Метод "initState" вызывается при инициализации виджета и выполняет получение
// данных о погоде с помощью метода "_fetchWeather".

// Метод "build" строит виджет на основе полученных данных о погоде. Если данные
// присутствуют, создается экземпляр "Scaffold" с разметкой для отображения погоды.
//  В противном случае отображается индикатор загрузки. Виджет включает в себя текст
//   с названием города и описанием погоды, а также изображения и текст с данными
//   о давлении, скорости ветра и влажности.

// Таким образом, этот код реализует виджет "HomePage", который получает и
// отображает данные о погоде.
