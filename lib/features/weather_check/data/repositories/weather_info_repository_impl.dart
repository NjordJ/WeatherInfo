import 'package:dartz/dartz.dart';
import 'package:weather_info/core/error/exceptions.dart';
import 'package:weather_info/core/error/failures.dart';
import 'package:weather_info/core/platform/network_info.dart';
import 'package:weather_info/features/weather_check/data/datasources/weather_info_local_data_source.dart';
import 'package:weather_info/features/weather_check/data/datasources/weather_info_remote_data_source.dart';
import 'package:weather_info/features/weather_check/data/models/weather_info_model.dart';
import 'package:weather_info/features/weather_check/domain/entities/weather_info.dart';
import 'package:weather_info/features/weather_check/domain/repositories/weather_info_repository.dart';

typedef _ConcreteOrRandomChooser = Future<WeatherInfo> Function();

class WeatherInfoRepositoryImpl implements WeatherInfoRepository {
  final WeatherInfoRemoteDataSource remoteDataSource;
  final WeatherInfoLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  WeatherInfoRepositoryImpl(
      {required this.remoteDataSource,
      required this.localDataSource,
      required this.networkInfo});

  @override
  Future<Either<Failure, WeatherInfo>> getWeatherByCityName(String city) async {
    return await _getWeather(() {
      return remoteDataSource.getWeatherByCityName(city);
    });
  }

  @override
  Future<Either<Failure, WeatherInfo>> getWeatherByRandomCity() async {
    return await _getWeather(() {
      return remoteDataSource.getWeatherByRandomCity();
    });
  }

  Future<Either<Failure, WeatherInfo>> _getWeather(
    _ConcreteOrRandomChooser getConcreteOrRandom,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final WeatherInfo remoteWeatherInfo = await getConcreteOrRandom();
        localDataSource.cacheWeatherInfo(remoteWeatherInfo as WeatherInfoModel);
        return Right(remoteWeatherInfo);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localWeatherInfo = await localDataSource.getLastWeatherInfo();
        return Right(localWeatherInfo);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
