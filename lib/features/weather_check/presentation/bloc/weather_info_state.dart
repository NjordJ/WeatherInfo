part of 'weather_info_bloc.dart';

abstract class WeatherInfoState extends Equatable {
  const WeatherInfoState();
}

class Empty extends WeatherInfoState {
  @override
  List<Object> get props => [];
}

class Loading extends WeatherInfoState {
  @override
  List<Object> get props => [];
}

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
