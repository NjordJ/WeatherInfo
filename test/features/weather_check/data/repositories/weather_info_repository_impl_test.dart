import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_info/core/platform/network_info.dart';
import 'package:weather_info/features/weather_check/data/datasources/weather_info_local_data_source.dart';
import 'package:weather_info/features/weather_check/data/datasources/weather_info_remote_data_source.dart';
import 'package:weather_info/features/weather_check/data/repositories/weather_info_repository_impl.dart';

class MockRemoteDataSource extends Mock implements WeatherInfoRemoteDataSource {

}

class MockLocalDataSource extends Mock implements WeatherInfoLocalDataSource {

}

class MockNetworkInfo extends Mock implements NetworkInfo {

}

void main() {
  WeatherInfoRepositoryImpl repository;
  MockRemoteDataSource mockRemoteDataSource;
  MockLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = WeatherInfoRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo
    );

  });

}