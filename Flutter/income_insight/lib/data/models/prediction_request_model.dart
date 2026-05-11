import '../../domain/entities/prediction_request.dart';

class PredictionRequestModel extends PredictionRequest {
  PredictionRequestModel({
    required super.age,
    required super.workclass,
    required super.education,
    required super.maritalStatus,
    required super.position,
    required super.relationship,
    required super.race,
    required super.sex,
    required super.capitalGain,
    required super.capitalLoss,
    required super.hoursPerWeek,
    required super.nativeCountry,
  });

  factory PredictionRequestModel.fromEntity(PredictionRequest entity) {
    return PredictionRequestModel(
      age: entity.age,
      workclass: entity.workclass,
      education: entity.education,
      maritalStatus: entity.maritalStatus,
      position: entity.position,
      relationship: entity.relationship,
      race: entity.race,
      sex: entity.sex,
      capitalGain: entity.capitalGain,
      capitalLoss: entity.capitalLoss,
      hoursPerWeek: entity.hoursPerWeek,
      nativeCountry: entity.nativeCountry,
    );
  }

  static const Map<String, int> _educationNumMap = {
    'Preschool': 1,
    '1st-4th': 2,
    '5th-6th': 3,
    '7th-8th': 4,
    '9th': 5,
    '10th': 6,
    '11th': 7,
    '12th': 8,
    'HS-grad': 9,
    'Some-college': 10,
    'Assoc-voc': 11,
    'Assoc-acdm': 12,
    'Bachelors': 13,
    'Masters': 14,
    'Prof-school': 15,
    'Doctorate': 16,
  };

  static const double _globalMean = 0.238549;

  double _encode(Map<String, dynamic> encoderMap, String feature, String val) {
    final featureMap = encoderMap[feature];
    if (featureMap is Map) {
      final v = featureMap[val];
      if (v != null) return (v as num).toDouble();
    }
    return _globalMean;
  }

  String _ageGroup(int age) {
    if (age < 25) return 'young';
    if (age < 45) return 'middle';
    if (age < 60) return 'senior';
    return 'old';
  }

  String _workIntensity(int hours) {
    if (hours < 35) return 'part-time';
    if (hours <= 40) return 'full-time';
    return 'overtime';
  }

  /// Returns the 17 numerical features in the EXACT order the Scaler expects.
  List<double> getScalerInputs() {
    final int eduNum = _educationNumMap[education] ?? 9;
    return [
      age.toDouble(),               // 0
      eduNum.toDouble(),            // 1
      hoursPerWeek.toDouble(),      // 2
      capitalGain.toDouble(),       // 3
      capitalLoss.toDouble(),       // 4
      (capitalGain - capitalLoss).toDouble(), // 5: capital-net
      (eduNum * hoursPerWeek).toDouble(),      // 6: edu_hours
      (age * hoursPerWeek).toDouble(),         // 7: age_hours
      189778.0,                     // 8: work-fnl
      nativeCountry == 'United-States' ? 1.0 : 0.0, // 9: is-us
      (capitalGain > 0 || capitalLoss > 0) ? 1.0 : 0.0, // 10: has_capital_activity
      (['Husband', 'Wife'].contains(relationship) && eduNum > 10) ? 1.0 : 0.0, // 11: relation-education
      (['Husband', 'Wife'].contains(relationship) && hoursPerWeek > 40) ? 1.0 : 0.0, // 12: overtime_married
      (['United-States', 'England', 'Canada', 'Germany', 'Japan', 'France',
         'Italy', 'Ireland', 'Scotland', 'Holand-Netherlands']
          .contains(nativeCountry) && hoursPerWeek > 40) ? 1.0 : 0.0, // 13: rich_country_hard_worker
      (['Exec-managerial', 'Prof-specialty'].contains(position)) ? 1.0 : 0.0, // 14: is_high_salary_job
      (age - eduNum).toDouble(), // 15: experience
      ((capitalGain - capitalLoss) > 0) ? 1.0 : 0.0, // 16: has-investments
    ];
  }

  /// Returns the 14 non-scaled features (Categorical + extra raw) as a Map for assembly.
  Map<String, double> getCategoricalInputs(Map<String, dynamic> encoderMap) {
    final int eduNum = _educationNumMap[education] ?? 9;
    return {
      'work-class': _encode(encoderMap, 'work-class', workclass),
      'education': _encode(encoderMap, 'education', education),
      'marital-status': _encode(encoderMap, 'marital-status', maritalStatus),
      'position': _encode(encoderMap, 'position', position),
      'relationship': _encode(encoderMap, 'relationship', relationship),
      'race': _encode(encoderMap, 'race', race),
      'sex': _encode(encoderMap, 'sex', sex),
      'age_group': _encode(encoderMap, 'age_group', _ageGroup(age)),
      'work-intensity': _encode(encoderMap, 'work-intensity', _workIntensity(hoursPerWeek)),
      'work_edu_interaction': _encode(encoderMap, 'work_edu_interaction', '${workclass}_$eduNum'),
      'marital_pos_interaction': _encode(encoderMap, 'marital_pos_interaction', '${maritalStatus}_$position'),
      'native-country': _encode(encoderMap, 'native-country', nativeCountry),
      'relation-position': _encode(encoderMap, 'relation-position', '${relationship}_$position'),
      'capital_net': (capitalGain - capitalLoss).toDouble(), // The 14th non-scaled feature
    };
  }
}
