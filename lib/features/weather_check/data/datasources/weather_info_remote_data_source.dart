import 'dart:convert';

import 'package:weather_info/core/error/exceptions.dart';
import 'package:weather_info/features/weather_check/data/models/weather_info_model.dart';
import 'package:http/http.dart' as http;

abstract class WeatherInfoRemoteDataSource {
  ///Calls the http://api.weatherapi.com/v1 endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<WeatherInfoModel> getWeatherByCityName(String city);

  ///Calls the http://api.weatherapi.com/v1 endpoint,
  ///
  ///uses a random city for query
  ///
  /// Throws a [ServerException] for all error codes.
  Future<WeatherInfoModel> getWeatherByRandomCity();
}

class WeatherInfoRemoteDataSourceImpl implements WeatherInfoRemoteDataSource {
  final http.Client httpClient;

  WeatherInfoRemoteDataSourceImpl({required this.httpClient});

  @override
  Future<WeatherInfoModel> getWeatherByCityName(String city) =>
      _getWeatherInfo(city);

  @override
  Future<WeatherInfoModel> getWeatherByRandomCity() {
    //TODO: implement choosing random city from cities.json
    const _city = 'Moscow';

    return _getWeatherInfo(_city);
  }

  Future<WeatherInfoModel> _getWeatherInfo(String city) async {
    final result = await httpClient.get(
        Uri.parse(
            'http://api.weatherapi.com/v1/current.json?key=9c74fd81e58f44989c192430220406&q=$city&aqi=no'),
        headers: {'Content-type': 'application/json'});

    if (result.statusCode == 200) {
      return WeatherInfoModel.fromJson(jsonDecode(result.body));
    } else {
      throw ServerException();
    }
  }

  void _getCities(String jsonPath) {}
}
