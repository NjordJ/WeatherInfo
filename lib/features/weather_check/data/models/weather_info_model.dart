import 'package:weather_info/features/weather_check/domain/entities/weather_info.dart';

class WeatherInfoModel extends WeatherInfo {
  const WeatherInfoModel({
    required String locationName,
    required String locationCountry,
    required double temperatureCelsius,
    required String weatherDescription,
    required double windMph,
    required String windDir,
  }) : super(
          locationName: locationName,
          locationCountry: locationCountry,
          temperatureCelsius: temperatureCelsius,
          weatherDescription: weatherDescription,
          windMph: windMph,
          windDir: windDir,
        );

  factory WeatherInfoModel.fromJson(Map<String, dynamic> json) {
    return WeatherInfoModel(
        locationName: json['location']['name'],
        locationCountry: json['location']['country'],
        temperatureCelsius: json['current']['temp_c'],
        weatherDescription: json['current']['condition']['text'],
        windMph: json['current']['wind_mph'],
        windDir: json['current']['wind_dir']);
  }

  Map<String, dynamic> toJson() {
    return {
      'location': {
        'name': locationName,
        'country': locationCountry,
      },
      'current': {
        'temp_c': temperatureCelsius,
        'condition': {
          'text': weatherDescription,
        },
        'wind_mph': windMph,
        'wind_dir': windDir,
      }
    };
  }
}
