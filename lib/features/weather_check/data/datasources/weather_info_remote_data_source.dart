import '../../domain/entities/weather_info.dart';

abstract class WeatherInfoRemoteDataSource {
  ///Calls the http://api.weatherapi.com/v1 endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<WeatherInfo> getWeatherByCityName(String city);

  ///Calls the http://api.weatherapi.com/v1 endpoint,
  ///
  ///uses a random city for query
  ///
  /// Throws a [ServerException] for all error codes.
  Future<WeatherInfo> getWeatherByRandomCity();
}