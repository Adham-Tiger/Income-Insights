class PredictionRequest {
  final int age;
  final String workclass;
  final String education;
  final String maritalStatus;
  final String position;
  final String relationship;
  final String race;
  final String sex;
  final int capitalGain;
  final int capitalLoss;
  final int hoursPerWeek;
  final String nativeCountry;

  PredictionRequest({
    required this.age,
    required this.workclass,
    required this.education,
    required this.maritalStatus,
    required this.position,
    required this.relationship,
    required this.race,
    required this.sex,
    required this.capitalGain,
    required this.capitalLoss,
    required this.hoursPerWeek,
    required this.nativeCountry,
  });
}
