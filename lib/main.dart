import 'package:flutter/material.dart';
import 'package:weather_info/features/weather_check/presentation/pages/weather_info_page.dart';
import 'injection_container.dart' as di;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //title: 'Weather info',
      theme: ThemeData(primaryColor: Colors.lightBlue.shade800),
      home: const WeatherInfoPage(),
    );
  }
}
