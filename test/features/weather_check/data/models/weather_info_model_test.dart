import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:weather_info/features/weather_check/data/models/weather_info_model.dart';
import 'package:weather_info/features/weather_check/domain/entities/weather_info.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tWeatherInfoModel = WeatherInfoModel(
      locationName: 'Moscow',
      locationCountry: 'Russia',
      temperatureCelsius: 19.0,
      weatherDescription: 'Partly cloudy',
      windMph: 13.6,
      windDir: 'NW');

  test('should be a subclass of WeatherInfo entity', () async {
    //arrange
    expect(tWeatherInfoModel, isA<WeatherInfo>());

    //act

    //assert
  });

  group('fromJson', () {
    test('should return valid model with json', () async {
      //arrange
      final Map<String, dynamic> jsonMap = json.decode(fixture('weather.json'));
      //act
      final result = WeatherInfoModel.fromJson(jsonMap);
      //assert
      expect(result, tWeatherInfoModel);
    });

    test('should return a json map containing correct data', () async {
      //act
      final result = tWeatherInfoModel.toJson();
      //assert
      final expectedMap = {
        "location": {
          "name": "Moscow",
          "country": "Russia",
        },
        "current": {
          "temp_c": 19.0,
          "condition": {
            "text": "Partly cloudy",
          },
          "wind_mph": 13.6,
          "wind_dir": "NW",
        }
      };

      expect(result, expectedMap);
    });
  });
}
