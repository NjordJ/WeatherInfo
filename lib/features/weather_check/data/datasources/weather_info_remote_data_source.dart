import 'dart:convert';
import 'dart:math';

import 'package:weather_info/core/error/exceptions.dart';
import 'package:weather_info/core/utils/json_reader.dart';
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
  Future<WeatherInfoModel> getWeatherByRandomCity() async {
    String city = await _getCity();

    return _getWeatherInfo(city);
  }

  Future<WeatherInfoModel> _getWeatherInfo(String city) async {
    final result = await httpClient.get(
        Uri.parse(
            'http://api.weatherapi.com/v1/current.json?key=YOUR_API_KEY&q=$city&aqi=no'),
        headers: {'Content-type': 'application/json'});

    if (result.statusCode == 200) {
      return WeatherInfoModel.fromJson(jsonDecode(result.body));
    } else {
      throw ServerException();
    }
  }

  Future<String> _getCity() async {
    String jsonString = await loadFromAsset('cities.json');
    final jsonDecoded = jsonDecode(jsonString);

    int randomCountry = Random().nextInt(jsonDecoded.length - 0) + 0;
    final List country = [];
    String city = '';

    country.addAll(jsonDecoded.values.elementAt(randomCountry));
    int randomCityInCountry = Random().nextInt(country.length - 0) + 0;
    city = country.elementAt(randomCityInCountry);

    return city;
  }
}
