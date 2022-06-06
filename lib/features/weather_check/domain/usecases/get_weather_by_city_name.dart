import 'package:dartz/dartz.dart';
import 'package:weather_info/core/error/failures.dart';
import 'package:weather_info/features/weather_check/domain/entities/weather_info.dart';
import 'package:weather_info/features/weather_check/domain/repositories/weather_info_repository.dart';

class GetWeatherInfoByCityName {
  final WeatherInfoRepository repository;

  GetWeatherInfoByCityName(this.repository);

  Future<Either<Failure, WeatherInfo>> execute({
      required String cityName
    }) async {
    return await repository.getWeatherByCityName(cityName);
  }

}