import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../core/usecase.dart';
import '../entities/prediction_request.dart';
import '../repositories/prediction_repository.dart';

class PredictIncomeUseCase implements UseCase<bool, PredictionRequest> {
  final PredictionRepository repository;

  PredictIncomeUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(PredictionRequest params) async {
    return await repository.predictIncome(params);
  }
}
