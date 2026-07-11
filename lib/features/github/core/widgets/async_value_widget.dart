// lib/core/widgets/async_value_widget.dart
//
// Copied from wger's core — unified loading/error/data handler.
// Usage: wrap any ref.watch(xyzProvider) result.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

import 'progress_indicator.dart';
import 'error.dart';

class AsyncValueWidget<T> extends StatelessWidget {
  const AsyncValueWidget({
    super.key,
    required this.value,
    required this.data,
    this.loggerName = 'AsyncValueWidget',
  });

  final AsyncValue<T> value;
  final Widget Function(T data) data;
  final String loggerName;

  @override
  Widget build(BuildContext context) {
    return value.when(
      loading: () => const Center(child: BoxedProgressIndicator()),
      error: (error, stack) {
        Logger(loggerName).severe('AsyncValueWidget error', error, stack);
        return Center(child: StreamErrorIndicator(error, stacktrace: stack));
      },
      data: data,
    );
  }
}
