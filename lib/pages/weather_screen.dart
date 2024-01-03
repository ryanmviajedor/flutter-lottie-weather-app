import 'package:flutter/material.dart';
import 'package:flutter_lottie_weather_app/models/weather_model.dart';
import 'package:flutter_lottie_weather_app/services/weather_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';

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
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunny.json'; // default

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloud.json';
      case 'rain':
      case 'drizzle':
        return 'assets/rain.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';
    }
  }

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
      backgroundColor: Colors.grey[800],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // city name
            Text(
              _weather?.cityName ?? "Loading city...",
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),

            // animations
            Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),

            // tempearture
            Text(
              '${_weather?.temperature.round()}°C',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),

            // weather condition
            Text(
              _weather?.mainCondition ?? "",
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
