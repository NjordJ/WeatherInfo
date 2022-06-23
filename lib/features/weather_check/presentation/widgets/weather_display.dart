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
      width: MediaQuery.of(context).size.height / 1.5,
      child: Card(
        color: Colors.indigo.shade900,
        elevation: 1.0,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                weatherInfo.temperatureCelsius.toString() + '℃',
                style: const TextStyle(fontSize: 50, color: Colors.white),
              ),
              Text(
                weatherInfo.locationName,
                style: const TextStyle(fontSize: 25, color: Colors.white),
              ),
              Text(
                weatherInfo.locationCountry,
                style: const TextStyle(fontSize: 25, color: Colors.white),
              ),
              Text(
                weatherInfo.weatherDescription,
                style: const TextStyle(fontSize: 25, color: Colors.white),
              ),
              Text(
                'Wind dir: ' + weatherInfo.windDir,
                style: const TextStyle(fontSize: 25, color: Colors.white),
              ),
              Text(
                'Wind speed: ' + weatherInfo.windMph.toString() + ' mph',
                style: const TextStyle(fontSize: 25, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
