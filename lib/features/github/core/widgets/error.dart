// lib/core/widgets/error.dart — copied from wger core

import 'package:flutter/material.dart';

class StreamErrorIndicator extends StatelessWidget {
  const StreamErrorIndicator(this.error, {super.key, this.stacktrace});

  final Object error;
  final StackTrace? stacktrace;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 40),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.red),
          ),
        ],
      ),
    );
  }
}
