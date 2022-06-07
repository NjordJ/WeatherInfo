import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../features/weather_check/domain/entities/weather_info.dart';
import '../error/failures.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

//Used when usecases don't need params
class NoParams extends Equatable{

  @override
  List<Object?> get props => [];
}