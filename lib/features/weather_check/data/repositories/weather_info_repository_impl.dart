import 'package:dartz/dartz.dart';
import 'package:weather_info/core/error/failures.dart';
import 'package:weather_info/features/weather_check/domain/entities/weather_info.dart';
import 'package:weather_info/features/weather_check/domain/repositories/weather_info_repository.dart';

import '../../../../core/platform/network_info.dart';
import '../datasources/weather_info_local_data_source.dart';
import '../datasources/weather_info_remote_data_source.dart';

class WeatherInfoRepositoryImpl implements WeatherInfoRepository{
  final WeatherInfoRemoteDataSource remoteDataSource;

  WeatherInfoRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo
  });

  final WeatherInfoLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  @override
  Future<Either<Failure, WeatherInfo>> getWeatherByCityName(String city) {
    // TODO: implement getWeatherByCityName
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, WeatherInfo>> getWeatherByRandomCity() {
    // TODO: implement getWeatherByRandomCity
    throw UnimplementedError();
  }

}