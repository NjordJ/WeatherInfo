import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:weather_info/core/platform/network_info.dart';

class MockInternetConnectionChecker extends Mock implements InternetConnectionChecker {}

void main(){
  late NetworkInfoImpl networkInfoImpl;
  late MockInternetConnectionChecker mockInternetConnectionChecker;

  setUp(() {
    mockInternetConnectionChecker = MockInternetConnectionChecker();
    networkInfoImpl = NetworkInfoImpl(mockInternetConnectionChecker);
  });

  group(
      'is connected',
          () {
            test('should forward the call to check connection from InternetConnectionChecker library', () async {
              //arrange
              final tHasConnectionFuture = Future.value(true);

              when(() => mockInternetConnectionChecker.hasConnection)
                  .thenAnswer((realInvocation) => tHasConnectionFuture);
              //act
              final result = networkInfoImpl.isConnected;
              //assert

              verify(() => mockInternetConnectionChecker.hasConnection)
                  .called(1);
              expect(result, tHasConnectionFuture);
            });
          }
  );

}