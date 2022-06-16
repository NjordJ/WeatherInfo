import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_info/core/utils/input_converter.dart';
import 'package:weather_info/features/weather_check/domain/entities/weather_info.dart';
import 'package:weather_info/features/weather_check/domain/usecases/get_random_weather_by_city_name.dart';
import 'package:weather_info/features/weather_check/domain/usecases/get_weather_by_city_name.dart';
import 'package:weather_info/features/weather_check/presentation/bloc/weather_info_bloc.dart';

class MockGetWeatherInfoByCityName extends Mock
    implements GetWeatherInfoByCityName {}

class MockGetWeatherByRandomCity extends Mock
    implements GetWeatherByRandomCity {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  late WeatherInfoBloc weatherInfoBloc;
  late MockGetWeatherInfoByCityName mockGetWeatherInfoByCityName;
  late MockGetWeatherByRandomCity mockGetWeatherByRandomCity;
  late MockInputConverter mockInputConverter;

  setUp(() {
    mockGetWeatherInfoByCityName = MockGetWeatherInfoByCityName();
    mockGetWeatherByRandomCity = MockGetWeatherByRandomCity();
    mockInputConverter = MockInputConverter();

    weatherInfoBloc = WeatherInfoBloc(
        concrete: mockGetWeatherInfoByCityName,
        random: mockGetWeatherByRandomCity,
        inputConverter: mockInputConverter);
  });

  test(
    'initial state should be empty',
    () async {
      //assert
      expect(weatherInfoBloc.initialState, equals(Empty()));
    },
  );

  group('GetWeatherForConcreteCity', () {
    const String tTextFieldString = 'Moscow 111';
    const String tCity = 'Moscow';
    const tWeatherInfo = WeatherInfo(
        locationName: 'Moscow',
        locationCountry: 'Russia',
        temperatureCelsius: 19.0,
        weatherDescription: 'Partly cloudy',
        windMph: 13.6,
        windDir: 'NW');

    // test(
    //   'should call the InputConverter to validate string',
    //   () async {
    //     //arrange
    //     when(() => mockInputConverter.stringToUnsignedString(any()))
    //         .thenReturn(const Right(tCity));
    //     //act
    //     weatherInfoBloc
    //         .add(const GetWeatherInfoForConcreteCity(tTextFieldString));
    //     //await untilCalled(mockInputConverter.stringToUnsignedString(any()));
    //     //assert
    //     verify(() =>
    //             mockInputConverter.stringToUnsignedString(tTextFieldString))
    //         .called(1);
    //   },
    // );

    test(
      'should emit [Error] when input is invalid',
      () async {
        //arrange
        when(() => mockInputConverter.stringToUnsignedString(any()))
            .thenReturn(Left(InvalidInputFailure()));
        //assert later
        final expected = [
          Empty(),
          const Error(message: invalid_input_message),
        ];
        expectLater(
            weatherInfoBloc.stream.asBroadcastStream(), emitsInOrder(expected));

        //act
        weatherInfoBloc
            .add(const GetWeatherInfoForConcreteCity(tTextFieldString));
      },
    );
  });
}
