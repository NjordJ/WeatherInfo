import 'package:equatable/equatable.dart';

class WeatherInfo extends Equatable{
  final String locationName;
  final String locationCountry;
  final double temperatureCelsius;
  final String weatherDescription;
  final double windMph;
  final String windDir;

  const WeatherInfo({
    required this.locationName,
    required this.locationCountry,
    required this.temperatureCelsius,
    required this.weatherDescription,
    required this.windMph,
    required this.windDir,
  });

  @override
  List<Object?> get props => [locationName, locationCountry, temperatureCelsius, weatherDescription, windMph, windDir];

}