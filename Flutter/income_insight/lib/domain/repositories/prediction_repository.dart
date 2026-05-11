import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/prediction_request.dart';

abstract class PredictionRepository {
  Future<Either<Failure, bool>> predictIncome(PredictionRequest request);
}
