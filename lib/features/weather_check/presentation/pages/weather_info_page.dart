import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_info/features/weather_check/presentation/bloc/bloc.dart';
import 'package:weather_info/features/weather_check/presentation/widgets/widgets.dart';

class WeatherInfoPage extends StatefulWidget {
  const WeatherInfoPage({Key? key}) : super(key: key);

  @override
  State<WeatherInfoPage> createState() => _WeatherInfoPageState();
}

class _WeatherInfoPageState extends State<WeatherInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: <Widget>[
        BlocBuilder<WeatherInfoBloc, WeatherInfoState>(
          builder: (context, state) {
            if (state is Empty) {
              return const MessageDisplay(
                message: 'Start searching!',
              );
            } else if (state is Loading) {
              return const LoadingWidget();
            } else if (state is Loaded) {
              return WeatherDisplay(weatherInfo: state.weatherInfo);
            } else if (state is Error) {
              return MessageDisplay(
                message: state.message,
              );
            }
            return const SizedBox.shrink();
          },
        ),
        // SizedBox(
        //   height: MediaQuery.of(context).size.height / 3,
        //   child: const Placeholder(),
        // ),
        const SizedBox(
          height: 30,
          child: SizedBox.shrink(),
        ),
        const WeatherControls(),
      ],
    );
  }
}
