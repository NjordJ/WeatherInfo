import 'package:dartz/dartz.dart';
import 'package:weather_info/core/error/failures.dart';
import 'package:weather_info/features/weather_check/domain/entities/weather_info.dart';

abstract class WeatherInfoRepository {
  Future<Either<Failure, WeatherInfo>> getWeatherByCityName(String city);
  Future<Either<Failure, WeatherInfo>> getWeatherByRandomCity();
}
