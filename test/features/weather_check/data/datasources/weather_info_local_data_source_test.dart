import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_info/features/weather_check/data/datasources/weather_info_local_data_source.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main(){
  late WeatherInfoLocalDataSourceImpl dataSourceImpl;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSourceImpl = WeatherInfoLocalDataSourceImpl(sharedPreferences: mockSharedPreferences);
  });
}