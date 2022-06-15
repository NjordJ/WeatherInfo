part of 'weather_info_bloc.dart';

abstract class WeatherInfoEvent extends Equatable {
  const WeatherInfoEvent();
}

class GetWeatherInfoForConcreteCity extends WeatherInfoEvent {
  final String cityString;

  const GetWeatherInfoForConcreteCity(this.cityString);

  @override
  // TODO: implement props
  List<Object?> get props => [cityString];
}

class GetWeatherInfoForRandomCity extends WeatherInfoEvent {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
