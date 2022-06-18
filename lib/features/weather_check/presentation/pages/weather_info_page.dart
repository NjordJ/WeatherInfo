import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_info/injection_container.dart';

import '../bloc/bloc.dart';
import '../widgets/widgets.dart';

class WeatherInfoPage extends StatelessWidget {
  const WeatherInfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather info'),
      ),
      body: SingleChildScrollView(child: _buildBody(context)),
    );
  }

  BlocProvider<WeatherInfoBloc> _buildBody(BuildContext context) {
    //final WeatherInfoBloc weatherInfoBloc = context.read<WeatherInfoBloc>();
    return BlocProvider(
      create: (_) => sl<WeatherInfoBloc>(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              // BlocBuilder(
              //   builder: (context, state) {
              //     if (state is Empty) {
              //       return const MessageDisplay(
              //         message: 'Start searching!',
              //       );
              //     } else if (state is Loading) {
              //       return const LoadingWidget();
              //     } else if (state is Loaded) {
              //       return WeatherDisplay(weatherInfo: state.weatherInfo);
              //     } else if (state is Error) {
              //       return MessageDisplay(
              //         message: state.message,
              //       );
              //     }
              //     return const SizedBox.shrink();
              //   },
              // ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 3,
                child: const Placeholder(),
              ),
              const SizedBox(
                height: 30,
                child: SizedBox.shrink(),
              ),
              //const Spacer(),
              const WeatherControls(),
            ],
          ),
        ),
      ),
    );
  }
}
