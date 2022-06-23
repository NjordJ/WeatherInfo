import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_info/features/weather_check/presentation/bloc/bloc.dart';
import 'package:weather_info/features/weather_check/presentation/pages/weather_info_page.dart';
import 'package:weather_info/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  //await di.sl.allReady();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      theme: ThemeData(primaryColor: Colors.indigo),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Weather info'),
        ),
        body: Center(
          child: FutureBuilder(
            future: di.sl.allReady(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return BlocProvider<WeatherInfoBloc>(
                  create: (_) => di.sl<WeatherInfoBloc>(),
                  child: const WeatherInfoPage(),
                );
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
          //provider
          // child: BlocProvider<WeatherInfoBloc>(
          //   create: (_) => di.sl<WeatherInfoBloc>(),
          //   child: const WeatherInfoPage(),
          // ),
        ),
      ),
    );
  }
}
