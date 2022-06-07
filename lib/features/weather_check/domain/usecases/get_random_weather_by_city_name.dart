import 'package:dartz/dartz.dart';
import 'package:weather_info/core/error/failures.dart';
import 'package:weather_info/features/weather_check/domain/entities/weather_info.dart';

import '../../../../core/usecases/usecase.dart';
import '../repositories/weather_info_repository.dart';

class GetWeatherByRandomCity implements UseCase<WeatherInfo, NoParams>{

  final WeatherInfoRepository repository;
  GetWeatherByRandomCity(this.repository);

  @override
  Future<Either<Failure, WeatherInfo>> call(NoParams params) async {
    return await repository.getWeatherByRandomCity();
  }

}