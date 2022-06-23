import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_info/core/error/exceptions.dart';
import 'package:weather_info/features/weather_check/data/models/weather_info_model.dart';

abstract class WeatherInfoLocalDataSource {
  ///Gets the cached [WeatherInfoModel] which was gotten the last time
  ///the user had an internet connection.
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<WeatherInfoModel> getLastWeatherInfo();

  Future<void> cacheWeatherInfo(WeatherInfoModel weatherToCache);
}

// ignore: constant_identifier_names
const String cached_weather_info = 'CACHED_WEATHER_INFO';

class WeatherInfoLocalDataSourceImpl implements WeatherInfoLocalDataSource {
  SharedPreferences sharedPreferences;

  WeatherInfoLocalDataSourceImpl({
    required this.sharedPreferences,
  });

  @override
  Future<WeatherInfoModel> getLastWeatherInfo() {
    final jsonString = sharedPreferences.getString(cached_weather_info);
    if (jsonString != null) {
      return Future.value(WeatherInfoModel.fromJson(jsonDecode(jsonString)));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheWeatherInfo(WeatherInfoModel weatherToCache) {
    return sharedPreferences.setString(
        cached_weather_info, jsonEncode(weatherToCache.toJson()));
  }
}
