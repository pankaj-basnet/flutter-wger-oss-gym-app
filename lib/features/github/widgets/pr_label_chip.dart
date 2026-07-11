// lib/features/github/github/widgets/pr_label_chip.dart

import 'package:flutter/material.dart';

import '../models/pr_label.dart';

class PrLabelChip extends StatelessWidget {
  const PrLabelChip({super.key, required this.label});

  final PrLabel label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        label.name,
        style: TextStyle(color: label.textColor, fontSize: 10),
      ),
      backgroundColor: label.flutterColor,
      padding: const EdgeInsets.symmetric(horizontal: 2),
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}
