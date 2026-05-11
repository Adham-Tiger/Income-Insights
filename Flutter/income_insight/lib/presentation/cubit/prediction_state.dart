abstract class PredictionState {}

class PredictionInitial extends PredictionState {}

class PredictionLoading extends PredictionState {}

class PredictionSuccess extends PredictionState {
  final bool isHighIncome;
  PredictionSuccess({required this.isHighIncome});
}

class PredictionError extends PredictionState {
  final String message;
  PredictionError({required this.message});
}
