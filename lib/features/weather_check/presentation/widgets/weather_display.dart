import 'package:flutter/material.dart';
import 'package:weather_info/features/weather_check/domain/entities/weather_info.dart';

class WeatherDisplay extends StatelessWidget {
  final WeatherInfo weatherInfo;

  const WeatherDisplay({
    Key? key,
    required this.weatherInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 3,
      child: Column(
        children: [
          Text(
            weatherInfo.temperatureCelsius.toString(),
            style: const TextStyle(fontSize: 50),
          ),
          Center(
            child: SingleChildScrollView(
              child: Text(
                weatherInfo.locationName,
                style: const TextStyle(fontSize: 25),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
