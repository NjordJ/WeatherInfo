import 'dart:convert';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:weather_info/core/utils/json_reader.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() {});

  Future<String> _getCity() async {
    String jsonString = await loadFromAsset('cities.json');
    final jsonDecoded = jsonDecode(jsonString);

    int randomCountry = Random().nextInt(jsonDecoded.length - 0) + 0;
    final List country = [];
    String city = '';

    country.addAll(jsonDecoded.values.elementAt(randomCountry));
    int randomCityInCountry = Random().nextInt(country.length - 0) + 0;
    city = country.elementAt(randomCityInCountry);

    return city;
  }

  group('JsonReader', () {
    test(
      'should return string contains information from cities.json',
      () async {
        //arrange
        const str = 'Moscow! !!City 3.154 6 .!!.';
        //act
        String result = await _getCity();

        //assert
        expect(result, str);
      },
    );
  });
}
