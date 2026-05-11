import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PredictionSubmitButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onPressed;

  const PredictionSubmitButton(
      {super.key, required this.isLoading, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        backgroundColor: const Color(0xFF3B82F6),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 5,
        shadowColor: const Color(0xFF3B82F6).withOpacity(0.5),
      ),
      child: isLoading
          ? const SizedBox(
              width: 24,
              height: 24,
              child:
                  CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
            )
          : Text(
              'Run Prediction',
              style: GoogleFonts.outfit(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),
    );
  }
}