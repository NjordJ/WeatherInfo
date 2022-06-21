import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_info/core/error/failures.dart';
import 'package:weather_info/core/usecases/usecase.dart';
import 'package:weather_info/core/utils/input_converter.dart';
import 'package:weather_info/features/weather_check/domain/usecases/get_random_weather_by_city_name.dart';
import 'package:weather_info/features/weather_check/domain/usecases/get_weather_by_city_name.dart';
import 'package:weather_info/features/weather_check/presentation/bloc/bloc.dart';

// ignore: constant_identifier_names
const String server_failure_message = 'Server failure';
// ignore: constant_identifier_names
const String cache_failure_message = 'Cache failure';
// ignore: constant_identifier_names
const String invalid_input_message = 'Invalid input';

class WeatherInfoBloc extends Bloc<WeatherInfoEvent, WeatherInfoState> {
  final GetWeatherInfoByCityName getWeatherInfoByCityName;
  final GetWeatherByRandomCity getWeatherByRandomCity;
  final InputConverter inputConverter;

  WeatherInfoState get initialState => Empty();

  WeatherInfoBloc(
      {required GetWeatherInfoByCityName concrete,
      required GetWeatherByRandomCity random,
      required this.inputConverter})
      : getWeatherInfoByCityName = concrete,
        getWeatherByRandomCity = random,
        super(Empty()) {
    on<GetWeatherInfoForConcreteCity>(_onGetWeatherInfoForConcreteCity);
    on<GetWeatherInfoForRandomCity>(_onGetWeatherInfoForRandomCity);
  }

  void _onGetWeatherInfoForConcreteCity(GetWeatherInfoForConcreteCity event,
      Emitter<WeatherInfoState> emit) async {
    final inputEither = inputConverter.stringToUnsignedString(event.cityString);
    await inputEither.fold((failure) async {
      emit(const Error(message: invalid_input_message));
    }, (string) async {
      emit(Loading());
      final failureOrWeather =
          await getWeatherInfoByCityName(Params(cityName: string));
      failureOrWeather.fold(
          (failure) => emit(Error(message: _mapFailureToMessage(failure))),
          (weather) => emit(Loaded(weatherInfo: weather)));
    });
  }

  void _onGetWeatherInfoForRandomCity(
      GetWeatherInfoForRandomCity event, Emitter<WeatherInfoState> emit) async {
    emit(Loading());
    final failureOrWeather = await getWeatherByRandomCity(NoParams());
    failureOrWeather.fold(
        (failure) => emit(Error(message: _mapFailureToMessage(failure))),
        (weather) => emit(Loaded(weatherInfo: weather)));
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return server_failure_message;
      case CacheFailure:
        return cache_failure_message;
      default:
        return 'Unexpected failure';
    }
  }
}
