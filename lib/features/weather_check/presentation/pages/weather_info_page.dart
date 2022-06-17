import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_info/features/weather_check/domain/entities/weather_info.dart';
import 'package:weather_info/features/weather_check/presentation/bloc/weather_info_bloc.dart';
import 'package:weather_info/main.dart';
import 'package:weather_info/injection_container.dart';

class WeatherInfoPage extends StatelessWidget {
  const WeatherInfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather info'),
      ),
      body: _buildBody(context),
    );
  }

  BlocProvider<WeatherInfoBloc> _buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<WeatherInfoBloc>(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              BlocBuilder(
                builder: (context, state) {
                  if (state is Empty) {
                    return const MessageDisplay(
                      message: 'Start searching!',
                    );
                  } else if (state is Loading) {
                    return const LoadingWidget();
                  } else if (state is Loaded) {
                  } else if (state is Error) {
                    return MessageDisplay(
                      message: state.message,
                    );
                  }

                  return const WeatherDisplay(
                      weatherInfo: WeatherInfo(
                          locationCountry: 'Russia',
                          locationName: 'Moscow',
                          windDir: 'N',
                          weatherDescription: 'Rain',
                          windMph: 5,
                          temperatureCelsius: 25));
                },
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 3,
                child: const Placeholder(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MessageDisplay extends StatelessWidget {
  final String message;

  const MessageDisplay({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 3,
      child: Center(
        child: SingleChildScrollView(
          child: Text(
            message,
            style: const TextStyle(fontSize: 25),
          ),
        ),
      ),
    );
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 3,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class WeatherDisplay extends StatelessWidget {
  final WeatherInfo weatherInfo;

  const WeatherDisplay({
    Key? key,
    required this.weatherInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 3,
      child: Column(
        children: [
          Text(
            weatherInfo.windDir,
            style: const TextStyle(fontSize: 50),
          ),
          Center(
            child: SingleChildScrollView(
              child: Text(
                weatherInfo.locationName,
                style: const TextStyle(fontSize: 25),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
