import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_info/core/platform/network_info.dart';
import 'package:weather_info/core/utils/input_converter.dart';
import 'package:weather_info/features/weather_check/data/datasources/weather_info_local_data_source.dart';
import 'package:weather_info/features/weather_check/data/datasources/weather_info_remote_data_source.dart';
import 'package:weather_info/features/weather_check/data/repositories/weather_info_repository_impl.dart';
import 'package:weather_info/features/weather_check/domain/repositories/weather_info_repository.dart';
import 'package:weather_info/features/weather_check/domain/usecases/get_random_weather_by_city_name.dart';
import 'package:weather_info/features/weather_check/domain/usecases/get_weather_by_city_name.dart';
import 'package:weather_info/features/weather_check/presentation/bloc/bloc.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Weather Check
  // Bloc
  sl.registerFactory(() => WeatherInfoBloc(
        concrete: sl(),
        random: sl(),
        inputConverter: sl(),
      ));

  // UseCases
  sl.registerLazySingleton(() => GetWeatherInfoByCityName(sl()));
  sl.registerLazySingleton(() => GetWeatherByRandomCity(sl()));

  // Repository
  sl.registerLazySingleton<WeatherInfoRepository>(
      () => WeatherInfoRepositoryImpl(
            localDataSource: sl(),
            remoteDataSource: sl(),
            networkInfo: sl(),
          ));

  // Data
  sl.registerLazySingleton<WeatherInfoRemoteDataSource>(
      () => WeatherInfoRemoteDataSourceImpl(httpClient: sl()));

  sl.registerLazySingleton<WeatherInfoLocalDataSource>(
      () => WeatherInfoLocalDataSourceImpl(sharedPreferences: sl()));

  //! Core
  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //! External
  sl.registerSingletonAsync<SharedPreferences>(
      () async => await SharedPreferences.getInstance());

  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
