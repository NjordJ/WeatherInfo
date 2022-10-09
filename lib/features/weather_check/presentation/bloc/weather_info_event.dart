import 'package:equatable/equatable.dart';

abstract class WeatherInfoEvent extends Equatable {
  const WeatherInfoEvent();

  @override
  List<Object?> get props => [];
}

class GetWeatherInfoForConcreteCity extends WeatherInfoEvent {
  final String cityString;

  const GetWeatherInfoForConcreteCity(this.cityString);
  @override
  List<Object?> get props => [cityString];
}

class GetWeatherInfoForRandomCity extends WeatherInfoEvent {}
