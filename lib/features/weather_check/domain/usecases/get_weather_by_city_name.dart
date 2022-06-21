import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:weather_info/core/error/failures.dart';
import 'package:weather_info/core/usecases/usecase.dart';
import 'package:weather_info/features/weather_check/domain/entities/weather_info.dart';
import 'package:weather_info/features/weather_check/domain/repositories/weather_info_repository.dart';

class GetWeatherInfoByCityName implements UseCase<WeatherInfo, Params> {
  final WeatherInfoRepository repository;
  GetWeatherInfoByCityName(this.repository);

  @override
  Future<Either<Failure, WeatherInfo>> call(Params params) async {
    return await repository.getWeatherByCityName(params.cityName);
  }
}

class Params extends Equatable {
  final String cityName;

  const Params({required this.cityName});

  @override
  List<Object?> get props => [cityName];
}
