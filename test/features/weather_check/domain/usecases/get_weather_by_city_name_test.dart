import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_info/features/weather_check/domain/entities/weather_info.dart';
import 'package:weather_info/features/weather_check/domain/repositories/weather_info_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_info/features/weather_check/domain/usecases/get_weather_by_city_name.dart';

class MockWeatherInfoRepository extends Mock implements WeatherInfoRepository {

}

void main(){
  late MockWeatherInfoRepository mockWeatherInfoRepository;
  late GetWeatherInfoByCityName usecase;

  setUp((){
    mockWeatherInfoRepository = MockWeatherInfoRepository();
    usecase = GetWeatherInfoByCityName(mockWeatherInfoRepository);
  });

  const tCityName = 'Moscow';
  const tWeatherInfo = WeatherInfo(
      locationName: 'Moscow',
      locationCountry: 'Russia',
      temperatureCelsius: 19.0,
      weatherDescription: 'Partly cloudy',
      windMph: 13.6,
      windDir: 'NW');

  test(
    'should display display weather information in written city',
      () async {
        //arrange
        when(()=>mockWeatherInfoRepository.getWeatherByCityName(any()))
            .thenAnswer((realInvocation) async => const Right(tWeatherInfo));
        //act
        final result = await usecase(const Params(cityName: tCityName));

        //assert
        expect(result, const Right(tWeatherInfo));
        verify(() => mockWeatherInfoRepository.getWeatherByCityName(tCityName))
            .called(1);
        verifyNoMoreInteractions(mockWeatherInfoRepository);

      }
  );

}