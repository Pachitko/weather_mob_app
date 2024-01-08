import 'package:flutter/material.dart';

import 'home_page.dart';

class WeatherDetailsPage extends StatefulWidget {
  const WeatherDetailsPage({super.key, required this.cityName, required this.dayFromNow});

  final String cityName;
  final int dayFromNow;

  @override
  State<StatefulWidget> createState() {
    return WeatherDetailsPageState();
  }
}

class WeatherDetailsPageState extends State<WeatherDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WeatherApp',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: HomePage(cityName: widget.cityName, dayFromNow: widget.dayFromNow),
    );
  }
}
