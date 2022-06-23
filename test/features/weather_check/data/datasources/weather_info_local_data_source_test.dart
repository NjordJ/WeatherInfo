import 'dart:convert';

import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_info/core/error/exceptions.dart';
import 'package:weather_info/features/weather_check/data/datasources/weather_info_local_data_source.dart';
import 'package:weather_info/features/weather_check/data/models/weather_info_model.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late WeatherInfoLocalDataSourceImpl dataSourceImpl;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSourceImpl = WeatherInfoLocalDataSourceImpl(
        sharedPreferences: mockSharedPreferences);
  });

  group('getLastWeatherInfo', () {
    final tWeatherInfoModel =
        WeatherInfoModel.fromJson(jsonDecode(fixture('weather_cached.json')));

    test(
        'should return WeatherInfoModel from SharedPreferences when there is one in the cache',
        () async {
      //arrange
      when(() => mockSharedPreferences.getString(any()))
          .thenReturn(fixture('weather_cached.json'));
      //act
      final result = await dataSourceImpl.getLastWeatherInfo();
      //assert
      verify(() => mockSharedPreferences.getString(cached_weather_info))
          .called(1);
      expect(result, equals(tWeatherInfoModel));
    });

    test('should throw a CacheException when there is no cached value',
        () async {
      //arrange
      when(() => mockSharedPreferences.getString(any())).thenReturn(null);
      //act
      final call = dataSourceImpl.getLastWeatherInfo;
      //assert
      expect(() => call(), throwsA(isInstanceOf<CacheException>()));
    });
  });

  group('cachedWeatherInfo', () {
    const tWeatherInfoModel = WeatherInfoModel(
        locationName: 'Moscow',
        locationCountry: 'Russia',
        temperatureCelsius: 19.0,
        weatherDescription: 'Partly cloudy',
        windMph: 13.6,
        windDir: 'NW');

    test('should call SharedPreference to cache the data', () async {
      //arrange
      when(() => mockSharedPreferences.setString(any(), any()))
          .thenAnswer((_) async => true);
      // act
      dataSourceImpl.cacheWeatherInfo(tWeatherInfoModel);
      //assert
      final expectedJsonString = jsonEncode(tWeatherInfoModel.toJson());
      verify(() => mockSharedPreferences.setString(
          cached_weather_info, expectedJsonString)).called(1);
    });
  });
}
