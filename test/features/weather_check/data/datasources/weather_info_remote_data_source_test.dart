import 'dart:convert';

import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_info/core/error/exceptions.dart';
import 'package:weather_info/features/weather_check/data/datasources/weather_info_remote_data_source.dart';
import 'package:http/http.dart' as http;
import 'package:weather_info/features/weather_check/data/models/weather_info_model.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockRemoteDataSource extends Mock implements WeatherInfoRemoteDataSource {
}

class FakeUri extends Fake implements Uri {}

void main() {
  late MockHttpClient httpClient;
  late WeatherInfoRemoteDataSourceImpl dataSourceImpl;

  setUpAll(() {
    registerFallbackValue(FakeUri());
  });

  setUp(() {
    httpClient = MockHttpClient();
    dataSourceImpl = WeatherInfoRemoteDataSourceImpl(httpClient: httpClient);
  });

  void setUpMockHttpClientSuccess200() {
    when(() => httpClient.get(any(), headers: any(named: 'headers')))
        .thenAnswer((_) async => http.Response(fixture('weather.json'), 200));
  }

  void setUpMockHttpClientFailure404() {
    when(() => httpClient.get(any(), headers: any(named: 'headers')))
        .thenAnswer((_) async => http.Response('Something', 404));
  }

  group('get weather info by city name', () {
    const tCity = 'Moscow';

    final tWeatherInfoModel =
        WeatherInfoModel.fromJson(jsonDecode(fixture('weather.json')));

    test(
        'should perform a GET request on a URL with a city being the endpoint '
        'with content type application/json headers', () async {
      //arrange
      setUpMockHttpClientSuccess200();
      //act
      dataSourceImpl.getWeatherByCityName(tCity);
      //assert
      verify(() => httpClient.get(
          Uri.parse(
              'http://api.weatherapi.com/v1/current.json?key=YOUR_API_KEY&q=$tCity&aqi=no'),
          headers: {'Content-type': 'application/json'})).called(1);
    });

    test('should return weather info when response code is 200 (success) ',
        () async {
      //arrange
      setUpMockHttpClientSuccess200();
      //act
      final result = await dataSourceImpl.getWeatherByCityName(tCity);
      //assert
      verify(() => httpClient.get(
          Uri.parse(
              'http://api.weatherapi.com/v1/current.json?key=YOUR_API_KEY&q=$tCity&aqi=no'),
          headers: {'Content-type': 'application/json'})).called(1);
      expect(result, equals(tWeatherInfoModel));
    });

    test(
        'should throw server exception when the response code is not 200 (404, 300 e.t.c.)',
        () async {
      //arrange
      setUpMockHttpClientFailure404();
      //act
      final call = dataSourceImpl.getWeatherByCityName;
      //assert
      expect(() => call(tCity), throwsA(isInstanceOf<ServerException>()));
    });
  });

  group('get weather info in random city', () {
    //City name gonna be chosen random from cities.json file
    const tCity = 'Moscow';

    final tWeatherInfoModel =
        WeatherInfoModel.fromJson(jsonDecode(fixture('weather.json')));

    test(
        'should perform a GET request on a URL with a city being the endpoint '
        'with content type application/json headers', () async {
      //arrange
      setUpMockHttpClientSuccess200();
      //act
      dataSourceImpl.getWeatherByRandomCity();
      //assert
      verify(() => httpClient.get(
          Uri.parse(
              'http://api.weatherapi.com/v1/current.json?key=YOUR_API_KEY&q=$tCity&aqi=no'),
          headers: {'Content-type': 'application/json'})).called(1);
    });

    test('should return weather info when response code is 200 (success) ',
        () async {
      //arrange
      setUpMockHttpClientSuccess200();
      //act
      final result = await dataSourceImpl.getWeatherByRandomCity();
      //assert
      verify(() => httpClient.get(
          Uri.parse(
              'http://api.weatherapi.com/v1/current.json?key=YOUR_API_KEY&q=$tCity&aqi=no'),
          headers: {'Content-type': 'application/json'})).called(1);
      expect(result, equals(tWeatherInfoModel));
    });

    test(
        'should throw server exception when the response code is not 200 (404, 300 e.t.c.)',
        () async {
      //arrange
      setUpMockHttpClientFailure404();
      //act
      final call = dataSourceImpl.getWeatherByRandomCity;
      //assert
      expect(() => call(), throwsA(isInstanceOf<ServerException>()));
    });
  });
}
