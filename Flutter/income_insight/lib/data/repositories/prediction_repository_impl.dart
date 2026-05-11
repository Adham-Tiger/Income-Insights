import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/prediction_request.dart';
import '../../domain/repositories/prediction_repository.dart';
import '../datasources/prediction_local_data_source.dart';
import '../models/prediction_request_model.dart';

class PredictionRepositoryImpl implements PredictionRepository {
  final PredictionLocalDataSource localDataSource;
  Map<String, dynamic>? _cachedEncoder;

  PredictionRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, bool>> predictIncome(PredictionRequest request) async {
    try {
      if (_cachedEncoder == null) {
        _cachedEncoder = await localDataSource.loadEncoder();
      }

      final model = PredictionRequestModel.fromEntity(request);
      
      final result = await localDataSource.predict(
        model.getScalerInputs(),
        model.getCategoricalInputs(_cachedEncoder!),
      );
      
      return Right(result == 1.0);
    } catch (e) {
      return Left(ModelFailure(e.toString()));
    }
  }
}
