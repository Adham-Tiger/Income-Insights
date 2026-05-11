import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants.dart';
import '../../domain/entities/prediction_request.dart';
import '../cubit/prediction_cubit.dart';
import '../cubit/prediction_state.dart';
import '../widgets/prediction_form_fields.dart';
import '../widgets/prediction_header.dart';
import '../widgets/prediction_result_card.dart';
import '../widgets/section_title.dart';
import '../widgets/form_row.dart';
import '../widgets/prediction_submit_button.dart';

class PredictionScreen extends StatefulWidget {
  const PredictionScreen({super.key});

  @override
  State<PredictionScreen> createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
  final _formKey = GlobalKey<FormState>();

  final _ageController = TextEditingController();
  final _capitalGainController = TextEditingController();
  final _capitalLossController = TextEditingController();
  final _hoursPerWeekController = TextEditingController();

  String? _selectedWorkclass, _selectedEducation, _selectedMaritalStatus, 
  _selectedPosition, _selectedRelationship, 
  _selectedRace, _selectedSex, _selectedCountry;

  @override
  void dispose() {
    _ageController.dispose();
    _capitalGainController.dispose();
    _capitalLossController.dispose();
    _hoursPerWeekController.dispose();
    super.dispose();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedWorkclass == null ||
        _selectedEducation == null ||
        _selectedMaritalStatus == null ||
        _selectedPosition == null ||
        _selectedRelationship == null ||
        _selectedRace == null ||
        _selectedSex == null ||
        _selectedCountry == null) {
      _showError('Please fill all dropdown fields');
      return;
    }

    final int? age = int.tryParse(_ageController.text);
    final int? capitalGain = int.tryParse(_capitalGainController.text);
    final int? capitalLoss = int.tryParse(_capitalLossController.text);
    final int? hoursPerWeek = int.tryParse(_hoursPerWeekController.text);

    if (age == null || age < 17 || age > 90) {
      _showError('Age must be between 17 and 90');
      return;
    }
    if (capitalGain == null || capitalGain < 0) {
      _showError('Capital Gain must be a non‑negative integer');
      return;
    }
    if (capitalLoss == null || capitalLoss < 0) {
      _showError('Capital Loss must be a non‑negative integer');
      return;
    }
    if (hoursPerWeek == null || hoursPerWeek < 1 || hoursPerWeek > 99) {
      _showError('Hours per week must be between 1 and 99');
      return;
    }

    final request = PredictionRequest(
      age: age,
      workclass: _selectedWorkclass!,
      education: _selectedEducation!,
      maritalStatus: _selectedMaritalStatus!,
      position: _selectedPosition!,
      relationship: _selectedRelationship!,
      race: _selectedRace!,
      sex: _selectedSex!,
      capitalGain: capitalGain,
      capitalLoss: capitalLoss,
      hoursPerWeek: hoursPerWeek,
      nativeCountry: _selectedCountry!,
    );

    context.read<PredictionCubit>().predictIncome(request);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AI Income Predictor',
            style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: BlocConsumer<PredictionCubit, PredictionState>(
          listener: (context, state) {
            if (state is PredictionError) {
              _showError('Error: ${state.message}');
            }
          },
          builder: (context, state) {
            final isLoading = state is PredictionLoading;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const PredictionHeader(),
                    const SizedBox(height: 32),
                    const SectionTitle('Personal Info'),
                    FormRow(
                      PredictionNumericField(label: 'Age', controller: _ageController),
                      PredictionDropdownField(
                        label: 'Sex',
                        items: AppConstants.sexes,
                        value: _selectedSex,
                        onChanged: (v) => setState(() => _selectedSex = v),
                      ),
                    ),
                    FormRow(
                      PredictionDropdownField(
                        label: 'Race',
                        items: AppConstants.races,
                        value: _selectedRace,
                        onChanged: (v) => setState(() => _selectedRace = v),
                      ),
                      PredictionDropdownField(
                        label: 'Country',
                        items: AppConstants.countries,
                        value: _selectedCountry,
                        onChanged: (v) => setState(() => _selectedCountry = v),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const SectionTitle('Education & Work'),
                    FormRow(
                      PredictionDropdownField(
                        label: 'Education',
                        items: AppConstants.educations,
                        value: _selectedEducation,
                        onChanged: (v) => setState(() => _selectedEducation = v),
                      ),
                      PredictionDropdownField(
                        label: 'Workclass',
                        items: AppConstants.workclasses,
                        value: _selectedWorkclass,
                        onChanged: (v) => setState(() => _selectedWorkclass = v),
                      ),
                    ),
                    PredictionDropdownField(
                      label: 'Position',
                      items: AppConstants.positions,
                      value: _selectedPosition,
                      onChanged: (v) => setState(() => _selectedPosition = v),
                    ),
                    const SizedBox(height: 24),
                    const SectionTitle('Family & Financial'),
                    FormRow(
                      PredictionDropdownField(
                        label: 'Marital',
                        items: AppConstants.maritalStatuses,
                        value: _selectedMaritalStatus,
                        onChanged: (v) => setState(() => _selectedMaritalStatus = v),
                      ),
                      PredictionDropdownField(
                        label: 'Relation',
                        items: AppConstants.relationships,
                        value: _selectedRelationship,
                        onChanged: (v) => setState(() => _selectedRelationship = v),
                      ),
                    ),
                    FormRow(
                      PredictionNumericField(label: 'Capital Gain', controller: _capitalGainController),
                      PredictionNumericField(label: 'Capital Loss', controller: _capitalLossController),
                    ),
                    PredictionNumericField(label: 'Hours / Week', controller: _hoursPerWeekController),
                    const SizedBox(height: 40),
                    PredictionSubmitButton(isLoading: isLoading, onPressed: _submitForm),
                    if (state is PredictionSuccess || isLoading) ...[
                      const SizedBox(height: 32),
                      PredictionResultCard(state: state),
                    ],
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}