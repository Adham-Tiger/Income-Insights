import 'package:flutter/material.dart';

class FormRow extends StatelessWidget {
  final Widget child1;
  final Widget child2;

  const FormRow(this.child1, this.child2, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(child: child1),
          const SizedBox(width: 16),
          Expanded(child: child2),
        ],
      ),
    );
  }
}