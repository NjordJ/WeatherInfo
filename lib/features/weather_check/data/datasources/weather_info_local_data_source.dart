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
const String CACHED_WEATHER_INFO = 'CACHED_WEATHER_INFO';

class WeatherInfoLocalDataSourceImpl implements WeatherInfoLocalDataSource{
  final SharedPreferences sharedPreferences;

  WeatherInfoLocalDataSourceImpl({required this.sharedPreferences,});

  @override
  Future<WeatherInfoModel> getLastWeatherInfo() {
    // TODO: implement getLastWeatherInfo
    final jsonString = sharedPreferences.getString(CACHED_WEATHER_INFO);
    if(jsonString != null){
      return Future.value(WeatherInfoModel.fromJson(jsonDecode(jsonString)));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheWeatherInfo(WeatherInfoModel weatherToCache) {
    // TODO: implement cacheWeatherInfo
    return sharedPreferences.setString(CACHED_WEATHER_INFO, jsonEncode(weatherToCache.toJson()));
  }
  
}