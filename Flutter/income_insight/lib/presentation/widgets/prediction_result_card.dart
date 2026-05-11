import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../cubit/prediction_state.dart';

class PredictionResultCard extends StatelessWidget {
  final PredictionState state;

  const PredictionResultCard({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    if (state is PredictionLoading) {
      return Container(
        padding: const EdgeInsets.all(24),
        alignment: Alignment.center,
        child: const Text('Analyzing data...',
            style: TextStyle(color: Colors.blueAccent)),
      );
    }

    if (state is PredictionSuccess) {
      final isHighIncome = (state as PredictionSuccess).isHighIncome;
      final color =
          isHighIncome ? const Color(0xFF10B981) : const Color(0xFFEF4444);
      final icon = isHighIncome ? Icons.trending_up : Icons.trending_down;
      final text = isHighIncome ? 'Your income is more than \$50K' : 'Your income is less than or equal to \$50K';

      return AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.5), width: 2),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 48),
            const SizedBox(height: 12),
            Text(
              text,
              style: GoogleFonts.outfit(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isHighIncome
                  ? 'The model predicts that you are very rich.'
                  : 'The model predicts you are poor.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF94A3B8)),
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
