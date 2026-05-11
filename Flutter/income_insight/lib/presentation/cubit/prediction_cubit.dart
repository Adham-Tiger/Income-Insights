import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/prediction_request.dart';
import '../../domain/usecases/predict_income_usecase.dart';
import 'prediction_state.dart';

class PredictionCubit extends Cubit<PredictionState> {
  final PredictIncomeUseCase predictIncomeUseCase;

  PredictionCubit({required this.predictIncomeUseCase}) : super(PredictionInitial());

  Future<void> predictIncome(PredictionRequest request) async {
    emit(PredictionLoading());

    final result = await predictIncomeUseCase(request);

    result.fold(
      (failure) => emit(PredictionError(message: failure.message)),
      (isHighIncome) => emit(PredictionSuccess(isHighIncome: isHighIncome)),
    );
  }
}
