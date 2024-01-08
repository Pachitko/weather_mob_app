class Weather {
  final String cityName;
  final String description;
  final String icon;
  final double pressure;
  final String humidity;
  final String speed;
  final double temperature;

  Weather({
    required this.cityName,
    required this.description,
    required this.icon,
    required this.pressure,
    required this.humidity,
    required this.speed,
    required this.temperature,
  });

  factory Weather.fromJson(Map<String, dynamic> json, String cityName) {
    return Weather(
      cityName: cityName,
      description: json['weather'][0]['description'],
      icon: json['weather'][0]['icon'],
      pressure: json['main']['pressure'].toDouble() * 0.750063755419211,
      humidity: json['main']['humidity'].toString(),
      speed: json['wind']['speed'].toString(),
      temperature: json['main']['temp'].toDouble(),
    );
  }
}

// Данный код представляет класс Weather, который используется для хранения информации о погоде.

// Класс имеет неизменяемые (final) свойства:
// - cityName - название города
// - description - описание погодных условий
// - icon - иконка, представляющая погоду
// - pressure - атмосферное давление
// - humidity - влажность
// - speed - скорость ветра
// - temperature - температура

// Конструктор класса принимает все эти свойства и помечает их как обязательные (required).

// Такое объявление позволяет создать объект класса Weather с предоставлением всех необходимых данных и гарантирует, что все обязательные свойства будут инициализированы.

// Таким образом, данный код представляет модель данных для хранения информации о погоде в заданном городе.
