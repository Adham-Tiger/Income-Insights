import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:onnxruntime/onnxruntime.dart';

abstract class PredictionLocalDataSource {
  Future<double> predict(List<double> scaledFeatures, Map<String, double> categoricalFeatures);
  Future<Map<String, dynamic>> loadEncoder();
  void dispose();
}

class PredictionLocalDataSourceImpl implements PredictionLocalDataSource {
  OrtSession? _modelSession;
  OrtSession? _scalerSession;
  bool _isInitialized = false;

  Future<void> _init() async {
    if (_isInitialized) return;

    OrtEnv.instance.init();

    try {
      final scalerRaw = await rootBundle.load('lib/assets/scaler.onnx');
      final scalerBytes = scalerRaw.buffer.asUint8List();
      _scalerSession = OrtSession.fromBuffer(scalerBytes, OrtSessionOptions());
    } catch (e) {
      print("Warning: scaler.onnx not found: $e");
    }

    try {
      final modelRaw = await rootBundle.load('lib/assets/model.onnx');
      final modelBytes = modelRaw.buffer.asUint8List();
      _modelSession = OrtSession.fromBuffer(modelBytes, OrtSessionOptions());
    } catch (e) {
      print("Error: model.onnx not found: $e");
      throw Exception("model.onnx not found");
    }

    _isInitialized = true;
  }

  @override
  Future<Map<String, dynamic>> loadEncoder() async {
    try {
      final raw = await rootBundle.loadString('lib/assets/target_encoder.json');
      return json.decode(raw);
    } catch (e) {
      print('Warning: target_encoder.json failed to load: $e');
      return {};
    }
  }

  @override
  Future<double> predict(List<double> numericalInputs, Map<String, double> categoricalInputs) async {
    await _init();

    if (_scalerSession == null || _modelSession == null) {
      throw Exception("Sessions are not initialized properly");
    }

    // 1. Scale Numerical Data
    final scalerInputTensor = OrtValueTensor.createTensorWithDataList(
      Float32List.fromList(numericalInputs),
      [1, numericalInputs.length], 
    );

    final scalerOutputs = _scalerSession!.run(
      OrtRunOptions(), 
      {_scalerSession!.inputNames[0]: scalerInputTensor}
    );
    
    final scaled = (scalerOutputs[0]?.value as List<List<double>>)[0];
    
    scalerInputTensor.release();
    for (var element in scalerOutputs) {
      element?.release();
    }

    final List<double> finalVector = [
      scaled[0],                                 // 0: age
      categoricalInputs['work-class']!,         // 1: work-class
      scaled[8],                                 // 2: work-fnl
      categoricalInputs['education']!,           // 3: education
      scaled[1],                                 // 4: education-num
      categoricalInputs['marital-status']!,      // 5: marital-status
      categoricalInputs['position']!,            // 6: position
      categoricalInputs['relationship']!,        // 7: relationship
      categoricalInputs['race']!,                // 8: race
      categoricalInputs['sex']!,                 // 9: sex
      scaled[3],                                 // 10: capital-gain
      scaled[4],                                 // 11: capital-loss
      scaled[2],                                 // 12: hours-per-week
      categoricalInputs['native-country']!,      // 13: native-country
      scaled[9],                                 // 14: is-us
      scaled[5],                                 // 15: capital-net
      scaled[10],                                // 16: has_capital_activity
      scaled[6],                                 // 17: edu_hours
      scaled[7],                                 // 18: age_hours
      categoricalInputs['age_group']!,           // 19: age_group
      categoricalInputs['work-intensity']!,      // 20: work-intensity
      categoricalInputs['work_edu_interaction']!, // 21: work_edu_interaction
      categoricalInputs['marital_pos_interaction']!, // 22: marital_pos_interaction
      categoricalInputs['capital_net']!,         // 23: capital_net (raw)
      scaled[11],                                // 24: relation-education
      categoricalInputs['relation-position']!,   // 25: relation-position
      scaled[12],                                // 26: overtime_married
      scaled[13],                                // 27: rich_country_hard_worker
      scaled[14],                                // 28: is_high_salary_job
      scaled[15],                                // 29: experience
      scaled[16],                                // 30: has-investments
    ];
    log("$finalVector");

    // 3. Predict
    final modelInputTensor = OrtValueTensor.createTensorWithDataList(
      Float32List.fromList(finalVector),
      [1, finalVector.length],
    );

    final modelOutputs = _modelSession!.run(
      OrtRunOptions(), 
      {_modelSession!.inputNames[0]: modelInputTensor}
    );
    
    final predictionLabel = modelOutputs[0]?.value;
    double prediction = 0.0;
    
    if (predictionLabel is List<int>) {
      prediction = predictionLabel[0].toDouble();
    } else if (predictionLabel is List<dynamic> && predictionLabel.isNotEmpty) {
      var val = predictionLabel[0];
      if (val is int) prediction = val.toDouble();
      if (val is double) prediction = val;
      if (val is List && val.isNotEmpty) prediction = (val[0] is int) ? val[0].toDouble() : val[0];
    }

    modelInputTensor.release();
    for (var element in modelOutputs) {
      element?.release();
    }

    return prediction;
  }

  @override
  void dispose() {
    _modelSession?.release();
    _scalerSession?.release();
    OrtEnv.instance.release();
  }
}
