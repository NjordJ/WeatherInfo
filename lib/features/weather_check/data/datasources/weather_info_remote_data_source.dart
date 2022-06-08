import '../models/weather_info_model.dart';

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