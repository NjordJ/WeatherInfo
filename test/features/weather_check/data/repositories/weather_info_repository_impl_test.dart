import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_info/core/error/exceptions.dart';
import 'package:weather_info/core/error/failures.dart';
import 'package:weather_info/core/platform/network_info.dart';
import 'package:weather_info/features/weather_check/data/datasources/weather_info_local_data_source.dart';
import 'package:weather_info/features/weather_check/data/datasources/weather_info_remote_data_source.dart';
import 'package:weather_info/features/weather_check/data/models/weather_info_model.dart';
import 'package:weather_info/features/weather_check/data/repositories/weather_info_repository_impl.dart';
import 'package:weather_info/features/weather_check/domain/entities/weather_info.dart';

class MockRemoteDataSource extends Mock implements WeatherInfoRemoteDataSource {
}

class MockLocalDataSource extends Mock implements WeatherInfoLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late WeatherInfoRepositoryImpl repository;
  late MockRemoteDataSource mockRemoteDataSource;
  late MockLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = WeatherInfoRepositoryImpl(
        remoteDataSource: mockRemoteDataSource,
        localDataSource: mockLocalDataSource,
        networkInfo: mockNetworkInfo);
  });

  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  }

  void runTestsOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      body();
    });
  }

  //Get weather in concrete city
  group('get weather info by city name', () {
    const tCity = 'Moscow';

    const WeatherInfoModel tWeatherInfoModel = WeatherInfoModel(
        locationName: tCity,
        locationCountry: 'Russia',
        temperatureCelsius: 19.0,
        weatherDescription: 'Partly cloudy',
        windMph: 13.6,
        windDir: 'NW');
    const WeatherInfo tWeatherInfo = tWeatherInfoModel;

    test('should check if device have internet connection', () async {
      //arrange
      //Stubs used to make tests pass because of type 'Null' is not a subtype of type 'Future<WeatherInfo>' error
      //Stub for mockRemoteDataSource.getWeatherByCityName
      when(() => mockRemoteDataSource.getWeatherByCityName(tCity))
          .thenAnswer((_) async => tWeatherInfoModel);
      //Stub for mockLocalDataSource.cacheWeatherInfo
      when(() => mockLocalDataSource.cacheWeatherInfo(tWeatherInfoModel))
          .thenAnswer((_) async => Future.value());
      //Stub for mockNetworkInfo.isConnected
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      //act
      await repository.getWeatherByCityName(tCity);
      //assert
      verify(() => mockNetworkInfo.isConnected).called(1);
    });

    runTestsOnline(() {
      test(
          'should return remote data when call to remote data source is successful',
          () async {
        //arrange
        //Stubs used to make tests pass because of type 'Null' is not a subtype of type 'Future<WeatherInfo>' error
        //Stub for mockRemoteDataSource.getWeatherByCityName
        when(() => mockRemoteDataSource.getWeatherByCityName(any()))
            .thenAnswer((_) async => tWeatherInfoModel);
        //Stub for mockLocalDataSource.cacheWeatherInfo
        when(() => mockLocalDataSource.cacheWeatherInfo(tWeatherInfoModel))
            .thenAnswer((_) async => Future.value());
        //Stub for mockNetworkInfo.isConnected
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);

        //act
        final result = await repository.getWeatherByCityName(tCity);
        //assert
        verify(() => mockRemoteDataSource.getWeatherByCityName(tCity))
            .called(1);
        expect(result, equals(const Right(tWeatherInfo)));
      });

      test(
          'should cache the data locally when the call to remote data source is successful',
          () async {
        //arrange
        //Stubs used to make tests pass because of type 'Null' is not a subtype of type 'Future<WeatherInfo>' error
        //Stub for mockRemoteDataSource.getWeatherByCityName
        when(() => mockRemoteDataSource.getWeatherByCityName(any()))
            .thenAnswer((_) async => tWeatherInfoModel);
        //Stub for mockLocalDataSource.cacheWeatherInfo
        when(() => mockLocalDataSource.cacheWeatherInfo(tWeatherInfoModel))
            .thenAnswer((_) async => Future.value());
        //Stub for mockNetworkInfo.isConnected
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        //act
        await repository.getWeatherByCityName(tCity);
        //assert
        verify(() => mockRemoteDataSource.getWeatherByCityName(tCity))
            .called(1);
        verify(() => mockLocalDataSource.cacheWeatherInfo(tWeatherInfoModel))
            .called(1);
      });

      test(
          'should return server failure when call to remote data source is unsuccessful',
          () async {
        //arrange
        when(() => mockRemoteDataSource.getWeatherByCityName(any()))
            .thenThrow(ServerException());
        //act
        final result = await repository.getWeatherByCityName(tCity);
        //assert
        verify(() => mockRemoteDataSource.getWeatherByCityName(tCity))
            .called(1);
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    runTestsOffline(() {
      test(
          'should return last locally cached data when the cached data is present',
          () async {
        //arrange
        when(() => mockLocalDataSource.getLastWeatherInfo())
            .thenAnswer((_) async => tWeatherInfoModel);
        //act
        final result = await repository.getWeatherByCityName(tCity);
        //assert
        //verifyZeroInteractions(mockLocalDataSource);
        verify(() => mockLocalDataSource.getLastWeatherInfo()).called(1);
        expect(result, equals(const Right(tWeatherInfo)));
      });

      test('should return cache failure when there is no cached data',
          () async {
        //arrange
        when(() => mockLocalDataSource.getLastWeatherInfo())
            .thenThrow(CacheException());
        //act
        final result = await repository.getWeatherByCityName(tCity);
        //assert
        //verifyZeroInteractions(mockLocalDataSource);
        verify(() => mockLocalDataSource.getLastWeatherInfo()).called(1);
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });

  //Get weather in random city
  group('get weather info in random city', () {
    const tWeatherInfoModel = WeatherInfoModel(
        locationName: 'Moscow',
        locationCountry: 'Russia',
        temperatureCelsius: 19.0,
        weatherDescription: 'Partly cloudy',
        windMph: 13.6,
        windDir: 'NW');
    const WeatherInfo tWeatherInfo = tWeatherInfoModel;

    test('should check if device have internet connection', () async {
      //arrange
      //Stubs used to make tests pass because of type 'Null' is not a subtype of type 'Future<WeatherInfo>' error
      //Stub for mockRemoteDataSource.getWeatherByCityName
      when(() => mockRemoteDataSource.getWeatherByRandomCity())
          .thenAnswer((_) async => tWeatherInfoModel);
      //Stub for mockLocalDataSource.cacheWeatherInfo
      when(() => mockLocalDataSource.cacheWeatherInfo(tWeatherInfoModel))
          .thenAnswer((_) async => Future.value());
      //Stub for mockNetworkInfo.isConnected
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      //act
      await repository.getWeatherByRandomCity();
      //assert
      verify(() => mockNetworkInfo.isConnected).called(1);
    });

    runTestsOnline(() {
      test(
          'should return remote data when call to remote data source is successful',
          () async {
        //arrange
        //Stubs used to make tests pass because of type 'Null' is not a subtype of type 'Future<WeatherInfo>' error
        //Stub for mockRemoteDataSource.getWeatherByCityName
        when(() => mockRemoteDataSource.getWeatherByRandomCity())
            .thenAnswer((_) async => tWeatherInfoModel);
        //Stub for mockLocalDataSource.cacheWeatherInfo
        when(() => mockLocalDataSource.cacheWeatherInfo(tWeatherInfoModel))
            .thenAnswer((_) async => Future.value());
        //Stub for mockNetworkInfo.isConnected
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        //act
        final result = await repository.getWeatherByRandomCity();
        //assert
        verify(() => mockRemoteDataSource.getWeatherByRandomCity()).called(1);
        expect(result, equals(const Right(tWeatherInfo)));
      });

      test(
          'should cache the data locally when the call to remote data source is successful',
          () async {
        //arrange
        //Stubs used to make tests pass because of type 'Null' is not a subtype of type 'Future<WeatherInfo>' error
        //Stub for mockRemoteDataSource.getWeatherByCityName
        when(() => mockRemoteDataSource.getWeatherByRandomCity())
            .thenAnswer((_) async => tWeatherInfoModel);
        //Stub for mockLocalDataSource.cacheWeatherInfo
        when(() => mockLocalDataSource.cacheWeatherInfo(tWeatherInfoModel))
            .thenAnswer((_) async => Future.value());
        //Stub for mockNetworkInfo.isConnected
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        //act
        await repository.getWeatherByRandomCity();
        //assert
        verify(() => mockRemoteDataSource.getWeatherByRandomCity()).called(1);
        verify(() => mockLocalDataSource.cacheWeatherInfo(tWeatherInfoModel))
            .called(1);
      });

      test(
          'should return server failure when call to remote data source is unsuccessful',
          () async {
        //arrange
        when(() => mockRemoteDataSource.getWeatherByRandomCity())
            .thenThrow(ServerException());
        //act
        final result = await repository.getWeatherByRandomCity();
        //assert
        verify(() => mockRemoteDataSource.getWeatherByRandomCity()).called(1);
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    runTestsOffline(() {
      test(
          'should return last locally cached data when the cached data is present',
          () async {
        //arrange
        when(() => mockLocalDataSource.getLastWeatherInfo())
            .thenAnswer((_) async => tWeatherInfoModel);
        //act
        final result = await repository.getWeatherByRandomCity();
        //assert
        //verifyZeroInteractions(mockLocalDataSource);
        verify(() => mockLocalDataSource.getLastWeatherInfo()).called(1);
        expect(result, equals(const Right(tWeatherInfo)));
      });

      test('should return cache failure when there is no cached data',
          () async {
        //arrange
        when(() => mockLocalDataSource.getLastWeatherInfo())
            .thenThrow(CacheException());
        //act
        final result = await repository.getWeatherByRandomCity();
        //assert
        //verifyZeroInteractions(mockLocalDataSource);
        verify(() => mockLocalDataSource.getLastWeatherInfo()).called(1);
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });
}
