import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_info/core/utils/input_converter.dart';

void main() {
  late InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group('inputConverter', () {
    test(
      'should return a string without any symbols expect letters',
      () async {
        //TODO: test not passes because of additional whitespace between word "Moscow" and word "City"
        //arrange
        const str = 'Moscow! !!City 3.154 6 .!!.';
        //act
        final result = inputConverter.stringToUnsignedString(str);
        //assert
        expect(result, const Right('Moscow City'));
      },
    );
  });
}
