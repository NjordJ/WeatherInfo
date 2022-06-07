import 'package:weather_info/core/error/exceptions.dart';
import 'package:weather_info/features/weather_check/data/models/weather_info_model.dart';

import '../../domain/entities/weather_info.dart';

abstract class WeatherInfoLocalDataSource {
  ///Gets the cached [WeatherInfoModel] which was gotten the last time
  ///the user had an internet connection.
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<WeatherInfoModel> getLastWeatherInfo();

  Future<void> cacheWeatherInfo(WeatherInfo weatherToCache);
}