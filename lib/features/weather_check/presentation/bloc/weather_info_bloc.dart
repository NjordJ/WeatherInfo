import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/utils/input_converter.dart';
import '../../domain/entities/weather_info.dart';
import '../../domain/usecases/get_random_weather_by_city_name.dart';
import '../../domain/usecases/get_weather_by_city_name.dart';

part 'weather_info_event.dart';

part 'weather_info_state.dart';

// ignore: constant_identifier_names
const String server_failure_message = 'Server failrue';
// ignore: constant_identifier_names
const String cache_failure_message = 'Cache failure';
// ignore: constant_identifier_names
const String invalid_input_message = 'Invalid input';

class WeatherInfoBloc extends Bloc<WeatherInfoEvent, WeatherInfoState> {
  final GetWeatherInfoByCityName getWeatherInfoByCityName;
  final GetWeatherByRandomCity getWeatherByRandomCity;
  final InputConverter inputConverter;

  // WeatherInfoBloc(
  //     {required GetWeatherInfoByCityName concrete,
  //     required GetWeatherByRandomCity random,
  //     required this.inputConverter})
  //     : getWeatherInfoByCityName = concrete,
  //       getWeatherByRandomCity = random,
  //       super(Empty());

  WeatherInfoBloc(
      {required GetWeatherInfoByCityName concrete,
      required GetWeatherByRandomCity random,
      required this.inputConverter})
      : getWeatherInfoByCityName = concrete,
        getWeatherByRandomCity = random,
        super(Empty()) {
    on<WeatherInfoEvent>(
        (WeatherInfoEvent event, Emitter<WeatherInfoState> emit) async {});
  }

  WeatherInfoState get initialState => Empty();

  Stream<WeatherInfoState> mapEventToState(
    WeatherInfoEvent event,
  ) async* {
    if (event is GetWeatherInfoForConcreteCity) {
      final inputEither =
          inputConverter.stringToUnsignedString(event.cityString);
      yield* inputEither.fold((failure) async* {
        yield const Error(message: invalid_input_message);
      }, (string) async* {
        // ignore: avoid_print
        print(string);
      });
    }
  }
}
