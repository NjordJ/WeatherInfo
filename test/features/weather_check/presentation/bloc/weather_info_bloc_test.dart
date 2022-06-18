import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_info/core/error/failures.dart';
import 'package:weather_info/core/usecases/usecase.dart';
import 'package:weather_info/core/utils/input_converter.dart';
import 'package:weather_info/features/weather_check/domain/entities/weather_info.dart';
import 'package:weather_info/features/weather_check/domain/usecases/get_random_weather_by_city_name.dart';
import 'package:weather_info/features/weather_check/domain/usecases/get_weather_by_city_name.dart';
import 'package:weather_info/features/weather_check/presentation/bloc/bloc.dart';

class MockGetWeatherInfoByCityName extends Mock
    implements GetWeatherInfoByCityName {}

class MockGetWeatherByRandomCity extends Mock
    implements GetWeatherByRandomCity {}

class MockInputConverter extends Mock implements InputConverter {}

class FakeParams extends Fake implements Params {}

void main() {
  late WeatherInfoBloc weatherInfoBloc;
  late MockGetWeatherInfoByCityName mockGetWeatherInfoByCityName;
  late MockGetWeatherByRandomCity mockGetWeatherByRandomCity;
  late MockInputConverter mockInputConverter;

  setUpAll(() {
    registerFallbackValue(FakeParams());
  });

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
    const String tTextFieldString = 'Moscow 11 ...';
    const String tCity = 'Moscow';
    const tWeatherInfo = WeatherInfo(
        locationName: 'Moscow',
        locationCountry: 'Russia',
        temperatureCelsius: 19.0,
        weatherDescription: 'Partly cloudy',
        windMph: 13.6,
        windDir: 'NW');

    void setUpMockInputConverterSuccess() =>
        when(() => mockInputConverter.stringToUnsignedString(any()))
            .thenReturn(const Right(tCity));

    void setUpMockInputConverterFailure() =>
        when(() => mockInputConverter.stringToUnsignedString(any()))
            .thenReturn(Left(InvalidInputFailure()));

    test(
      'should call the InputConverter to validate string',
      () async {
        //arrange
        setUpMockInputConverterSuccess();
        //act
        weatherInfoBloc
            .add(const GetWeatherInfoForConcreteCity(tTextFieldString));
        await untilCalled(
            () => mockInputConverter.stringToUnsignedString(any()));
        //assert
        verify(() =>
                mockInputConverter.stringToUnsignedString(tTextFieldString))
            .called(1);
      },
    );

    test('Should emit [Error] when the input is invalid', () {
      setUpMockInputConverterFailure();
      final expected = [
        //Empty(),
        const Error(message: invalid_input_message),
      ];
      expectLater(
          weatherInfoBloc.stream.asBroadcastStream(), emitsInOrder(expected));
      weatherInfoBloc
          .add(const GetWeatherInfoForConcreteCity(tTextFieldString));
    });

    // blocTest<WeatherInfoBloc, WeatherInfoState>(
    //   'should emit [Error] when the input is invalid',
    //   build: () {
    //     when(() => mockInputConverter.stringToUnsignedString(any()))
    //         .thenReturn(Left(InvalidInputFailure()));
    //     return weatherInfoBloc;
    //   },
    //   act: (bloc) =>
    //       bloc.add(const GetWeatherInfoForConcreteCity(tTextFieldString)),
    //   expect: () => [const Error(message: invalid_input_message)],
    // );

    test(
      'should get data from the concrete usecase',
      () async {
        //arrange
        setUpMockInputConverterSuccess();
        when(() => mockGetWeatherInfoByCityName(any())
            .then((_) async => const Right(tWeatherInfo)));
        //act
        weatherInfoBloc
            .add(const GetWeatherInfoForConcreteCity(tTextFieldString));
        await untilCalled(() => mockGetWeatherInfoByCityName(any()));
        //assert
        verify(() =>
                mockGetWeatherInfoByCityName(const Params(cityName: tCity)))
            .called(1);
      },
    );

    test(
      'should emit [Loading, Loaded] when data is gotten successfully',
      () async {
        //arrange
        setUpMockInputConverterSuccess();
        when(() => mockGetWeatherInfoByCityName(any())
            .then((_) async => const Right(tWeatherInfo)));

        //assert later
        final expected = [
          //Empty(),
          Loading(),
          const Loaded(
            weatherInfo: tWeatherInfo,
          )
        ];
        expectLater(
            weatherInfoBloc.stream.asBroadcastStream(), emitsInOrder(expected));
        //act
        weatherInfoBloc
            .add(const GetWeatherInfoForConcreteCity(tTextFieldString));
      },
    );

    // blocTest<WeatherInfoBloc, WeatherInfoState>(
    //   'should emit [Loading, Loaded] when data is gotten successfully',
    //   build: () {
    //     setUpMockInputConverterSuccess();
    //     when(() => mockGetWeatherInfoByCityName(any())
    //         .then((_) async => const Right(tWeatherInfo)));
    //     return weatherInfoBloc;
    //   },
    //   act: (bloc) =>
    //       bloc.add(const GetWeatherInfoForConcreteCity(tTextFieldString)),
    //   expect: () => [
    //     expectLater(
    //         weatherInfoBloc.stream.asBroadcastStream(),
    //         emitsInOrder([
    //           //Empty(),
    //           Loading(),
    //           const Loaded(
    //             weatherInfo: tWeatherInfo,
    //           )
    //         ]))
    //   ],
    // );

    test(
      'should emit [Loading, Error] when getting data fails',
      () async {
        //arrange
        setUpMockInputConverterSuccess();
        when(() => mockGetWeatherInfoByCityName(any())
            .then((_) async => Left(ServerFailure())));

        //assert later
        final expected = [
          //Empty(),
          Loading(),
          const Error(message: server_failure_message),
        ];
        expectLater(
            weatherInfoBloc.stream.asBroadcastStream(), emitsInOrder(expected));
        //act
        weatherInfoBloc
            .add(const GetWeatherInfoForConcreteCity(tTextFieldString));
      },
    );

    test(
      'should emit [Loading, Error] with a proper message for the error when getting data fails',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        when(() => mockGetWeatherInfoByCityName(any())
            .then((_) async => Left(CacheFailure())));
        // assert later
        final expected = [
          //Empty(),
          Loading(),
          const Error(message: cache_failure_message),
        ];
        expectLater(
            weatherInfoBloc.stream.asBroadcastStream(), emitsInOrder(expected));
        // act
        weatherInfoBloc
            .add(const GetWeatherInfoForConcreteCity(tTextFieldString));
      },
    );
  });

  group('GetWeatherForRandomCity', () {
    const tWeatherInfo = WeatherInfo(
        locationName: 'Moscow',
        locationCountry: 'Russia',
        temperatureCelsius: 19.0,
        weatherDescription: 'Partly cloudy',
        windMph: 13.6,
        windDir: 'NW');

    test(
      'should get data from the random usecase',
      () async {
        //arrange
        when(() => mockGetWeatherByRandomCity(any())
            .then((_) async => const Right(tWeatherInfo)));
        //act
        weatherInfoBloc.add(GetWeatherInfoForRandomCity());
        await untilCalled(() => mockGetWeatherByRandomCity(any()));
        //assert
        verify(() => mockGetWeatherByRandomCity(NoParams())).called(1);
      },
    );

    test(
      'should emit [Loading, Loaded] when data is gotten successfully',
      () async {
        //arrange
        when(() => mockGetWeatherByRandomCity(any())
            .then((_) async => const Right(tWeatherInfo)));

        //assert later
        final expected = [
          //Empty(),
          Loading(),
          const Loaded(
            weatherInfo: tWeatherInfo,
          )
        ];
        expectLater(
            weatherInfoBloc.stream.asBroadcastStream(), emitsInOrder(expected));
        //act
        weatherInfoBloc.add(GetWeatherInfoForRandomCity());
      },
    );

    test(
      'should emit [Loading, Error] when getting data fails',
      () async {
        //arrange
        when(() => mockGetWeatherByRandomCity(any())
            .then((_) async => Left(ServerFailure())));

        //assert later
        final expected = [
          //Empty(),
          Loading(),
          const Error(message: server_failure_message),
        ];
        expectLater(
            weatherInfoBloc.stream.asBroadcastStream(), emitsInOrder(expected));
        //act
        weatherInfoBloc.add(GetWeatherInfoForRandomCity());
      },
    );

    test(
      'should emit [Loading, Error] with a proper message for the error when getting data fails',
      () async {
        // arrange
        when(() => mockGetWeatherByRandomCity(any())
            .then((_) async => Left(CacheFailure())));
        // assert later
        final expected = [
          //Empty(),
          Loading(),
          const Error(message: cache_failure_message),
        ];
        expectLater(
            weatherInfoBloc.stream.asBroadcastStream(), emitsInOrder(expected));
        // act
        weatherInfoBloc.add(GetWeatherInfoForRandomCity());
      },
    );
  });
}
