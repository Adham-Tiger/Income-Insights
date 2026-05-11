import 'package:get_it/get_it.dart';
import 'data/datasources/prediction_local_data_source.dart';
import 'data/repositories/prediction_repository_impl.dart';
import 'domain/repositories/prediction_repository.dart';
import 'domain/usecases/predict_income_usecase.dart';
import 'presentation/cubit/prediction_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Features - Prediction
  
  // Cubit
  sl.registerFactory(() => PredictionCubit(predictIncomeUseCase: sl()));

  // Use cases
  sl.registerLazySingleton(() => PredictIncomeUseCase(sl()));

  // Repository
  sl.registerLazySingleton<PredictionRepository>(
    () => PredictionRepositoryImpl(localDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<PredictionLocalDataSource>(
    () => PredictionLocalDataSourceImpl(),
  );
}
