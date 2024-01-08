import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../models/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  static const BASE_URL = 'http://api.openweathermap.org/data/2.5/weather';
  static const FORECAST_URL = 'http://api.openweathermap.org/data/2.5/forecast';
  String apiKey;

  WeatherService(this.apiKey);

  Future<Weather> getWeather(String cityName) async {
    final response = await http.get(
        Uri.parse('$BASE_URL?q=$cityName&appid=$apiKey&units=metric&lang=ru'));

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body), cityName);
    } else {
      throw Exception('Ошибка загрузки данных!');
    }
  }

  Future<List<Weather>> GetForecast(String cityName, {int days = 14}) async {
    final response = await http.get(
        Uri.parse('$FORECAST_URL?q=$cityName&appid=$apiKey&units=metric&lang=ru'));

    var weathers = jsonDecode(response.body)["list"];

    if (response.statusCode == 200) {
      List<Weather> forecast = List<Weather>.empty(growable: true);
      for (int i = 0; i < days; i++)
      {
        forecast.add(Weather.fromJson(weathers[i], cityName));
      }
      return forecast;
      
    } else {
      throw Exception('Ошибка загрузки данных!');
    }
  }

  Future getCurrentCity() async {
    // получаем разрешения от пользователя, если они не были получены
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    // получить текущее местоположение
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy:
            LocationAccuracy.bestForNavigation); // с высокой точностью

    // // преобразование местоположения в список placemark objects
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    // извлекаем название города
    String? city = placemarks[0].locality;
    print(placemarks);
    print(placemarks[1].locality);

    return city;
  }
}


// Метод `getCurrentCity` получает текущее местоположение пользователя. Сначала 
//он проверяет разрешения на определение местоположения пользователя и 
//запрашивает их, если они не были предоставлены. Затем метод получает 
//текущее местоположение пользователя с высокой точностью с помощью функции 
//`Geolocator.getCurrentPosition`. После этого метод преобразует полученные 
//координаты в список объектов `Placemark`, содержащих информацию о месте. 
//Извлекается название города из первого элемента списка placemarks. 
//Наконец, метод возвращает название города.

// В общем, класс `WeatherService` предоставляет удобный интерфейс для получения
// информации о погоде и текущем местоположении. Он делает запросы к API  
//с помощью заданного ключа и использует библиотеку `http` для выполнения 
//HTTP-запросов. Класс также использует библиотеку `Geolocator` 
//для получения текущего местоположения пользователя.

// Асинхронные функции используются в данном коде для выполнения операций, 
// которые могут занимать больше времени, таких как получение данных 
// с удаленного сервера и получение местоположения пользователя.

// В методе `getWeather`, асинхронная функция используется для отправки 
// HTTP-запроса на сервер и ожидания ответа. Вместо блокировки исполнения кода и 
// ожидания завершения запроса, ключевое слово `await` позволяет приостановить
// выполнение функции до получения ответа от сервера. Таким образом, код ожидает 
// завершения запроса и затем обрабатывает полученные данные, преобразуя их в 
// объект `Weather`. Если полученный статус ответа равен 200, то функция возвращает
//  экземпляр `Weather`, иначе выбрасывается исключение.

// Метод `getCurrentCity` также является асинхронным, поскольку ожидает асинхронное
//  получение разрешений геолокации и текущего местоположения пользователя. 
//  Сначала проверяется разрешение геолокации, и если оно не было предоставлено, 
//  запрашивается разрешение у пользователя. Затем функция получает текущую позицию
//   пользователя с помощью `getCurrentPosition` и извлекает название города из 
//   полученных координат. В конце функция возвращает название города.

// Асинхронные функции позволяют избежать блокировки исполнения кода при ожидании 
// длительных операций, что позволяет повысить производительность и улучшить 
// отзывчивость приложения.