import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_info/features/weather_check/presentation/bloc/weather_info_bloc.dart';

import '../bloc/weather_info_event.dart';

class WeatherControls extends StatefulWidget {
  const WeatherControls({
    Key? key,
  }) : super(key: key);

  @override
  _WeatherControlsState createState() => _WeatherControlsState();
}

class _WeatherControlsState extends State<WeatherControls> {
  final controller = TextEditingController();
  String inputStr = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextField(
          controller: controller,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Input a city',
          ),
          onChanged: (value) {
            inputStr = value;
          },
          onSubmitted: (_) {
            dispatchConcrete();
          },
        ),
        const SizedBox(height: 10),
        Row(
          children: <Widget>[
            Expanded(
              child: ElevatedButton(
                child: const Text('Search'),
                // ignore: prefer_const_constructors
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.black54),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white24),
                ),
                onPressed: dispatchConcrete,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                child: const Text('Get random weather'),
                // ignore: prefer_const_constructors
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.black54),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white24),
                ),
                onPressed: dispatchConcrete,
              ),
            ),
          ],
        )
      ],
    );
  }

  void dispatchConcrete() {
    controller.clear();
    BlocProvider.of<WeatherInfoBloc>(context)
        .add(GetWeatherInfoForConcreteCity(inputStr));
  }

  void dispatchRandom(WeatherInfoBloc bloc) {
    controller.clear();
    BlocProvider.of<WeatherInfoBloc>(context)
        .add(GetWeatherInfoForRandomCity());
  }
}
