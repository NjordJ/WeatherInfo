import 'package:bloc/bloc.dart';
import 'package:weather_info/core/error/failures.dart';
import 'package:weather_info/core/usecases/usecase.dart';

import '../../../../core/utils/input_converter.dart';
import '../../domain/usecases/get_random_weather_by_city_name.dart';
import '../../domain/usecases/get_weather_by_city_name.dart';

import 'bloc.dart';

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
  late final GetWeatherInfoForConcreteCity getWeatherInfoForConcreteCity;

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
    final inputEither = inputConverter
        .stringToUnsignedString(getWeatherInfoForConcreteCity.cityString);
    inputEither.fold((failure) async {
      emit(const Error(message: invalid_input_message));
    }, (string) async {
      emit(Loading());
      final failureOrWeather =
          await getWeatherInfoByCityName(Params(cityName: string));
      emit(failureOrWeather.fold(
          (failure) => Error(message: _mapFailureToMessage(failure)),
          (weather) => Loaded(weatherInfo: weather)));
    });
  }

  void _onGetWeatherInfoForRandomCity(
      GetWeatherInfoForRandomCity event, Emitter<WeatherInfoState> emit) async {
    emit(Loading());
    final failureOrWeather = await getWeatherByRandomCity(NoParams());
    emit(failureOrWeather.fold(
        (failure) => Error(message: _mapFailureToMessage(failure)),
        (weather) => Loaded(weatherInfo: weather)));
  }

  // @override
  // Stream<WeatherInfoState> mapEventToState(
  //   WeatherInfoEvent event,
  // ) async* {
  //   if (event is GetWeatherInfoForConcreteCity) {
  //     final inputEither =
  //         inputConverter.stringToUnsignedString(event.cityString);
  //     yield* inputEither.fold((failure) async* {
  //       yield const Error(message: invalid_input_message);
  //     }, (string) async* {
  //       yield Loading();
  //       final failureOrWeather =
  //           await getWeatherInfoByCityName(Params(cityName: string));
  //       yield* _eitherLoadedOrErrorState(failureOrWeather);
  //     });
  //   } else if (event is GetWeatherInfoForRandomCity) {
  //     yield Loading();
  //     final failureOrWeather = await getWeatherByRandomCity(NoParams());
  //     yield* _eitherLoadedOrErrorState(failureOrWeather);
  //   }
  // }

  // Future<void> _eitherLoadedOrErrorState(
  //     Either<Failure, WeatherInfo> failureOrWeather) async {
  //   return failureOrWeather.fold(
  //       (failure) => Error(message: _mapFailureToMessage(failure)),
  //       (weather) => Loaded(weatherInfo: weather));
  // }

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
