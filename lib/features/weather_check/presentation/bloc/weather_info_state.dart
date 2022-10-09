import 'package:equatable/equatable.dart';
import 'package:weather_info/features/weather_check/domain/entities/weather_info.dart';

abstract class WeatherInfoState extends Equatable {
  const WeatherInfoState();

  @override
  List<Object> get props => [];
}

class Empty extends WeatherInfoState {}

class Loading extends WeatherInfoState {}

class Loaded extends WeatherInfoState {
  final WeatherInfo weatherInfo;

  const Loaded({required this.weatherInfo});

  @override
  List<Object> get props => [weatherInfo];
}

class Error extends WeatherInfoState {
  final String message;

  const Error({required this.message});

  @override
  List<Object> get props => [message];
}
