import 'package:dartz/dartz.dart';
import 'package:weather_info/core/error/failures.dart';

class InputConverter {
  Either<Failure, String> stringToUnsignedString(String str) {
    try {
      const String regexUnicodeAware = r'[^\p{Alphabetic}\s]+';
      //const String regex = r'[^\p{Alphabetic}\p{Mark}\p{Decimal_Number}\p{Connector_Punctuation}\p{Join_Control}\s]+';
      final String inputString = str
          .replaceAll(RegExp(regexUnicodeAware, unicode: true), '')
          .trim()
          .replaceAll(r'/\s+/', ' ');
      //inputString.replaceRange(inputString.length - 1, null, '');
      return Right(inputString);
    } on FormatException {
      return Left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failure {
  @override
  List<Object?> get props => [];
}
