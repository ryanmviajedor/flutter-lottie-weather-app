import 'package:flutter/material.dart';
import 'package:flutter_lottie_weather_app/models/weather_model.dart';
import 'package:flutter_lottie_weather_app/services/weather_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gap/gap.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  // api key
  final _weatherService = WeatherService(dotenv.env["API_KEY"]!);
  Weather? _weather;

  // fetch weather
  _fetchWeather() async {
    // get the current city
    Set<String> cityName = await _weatherService.getCurrentCity();
    print(' CITYNAME $cityName');
    print(' CITYNAME ${cityName.first}');
    print(' CITYNAME ${cityName.last}');
    String lat = cityName.first;
    String lon = cityName.last;

    // get weather for city
    try {
      final weather = await _weatherService.getWeather(lat, lon);
      setState(() {
        _weather = weather;
      });
      print(weather);
    }
    // any errors
    catch (e) {
      print(e);
    }
  }

  //weather animations

  // init state
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // fetch weather on startup
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // city name
            Text(_weather?.cityName ?? "Loading city..."),
            const Gap(5),
            Text('${_weather?.temperature.round()}°C'),
          ],
        ),
      ),
    );
  }
}
