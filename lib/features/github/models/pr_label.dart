import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/material.dart';

part 'pr_label.freezed.dart';
part 'pr_label.g.dart';

@freezed
@JsonSerializable()
class PrLabel with _$PrLabel {
  @override
  final String name;

  @Default('cccccc')
  @override
  final String color;

  @override
  final String? description;

  PrLabel({required this.name, this.color = 'cccccc', this.description});

  factory PrLabel.fromJson(Map<String, dynamic> json) =>
      _$PrLabelFromJson(json);
  Map<String, dynamic> toJson() => _$PrLabelToJson(this);

  Color get flutterColor {
    try {
      return Color(int.parse('FF$color', radix: 16));
    } catch (_) {
      return Colors.grey;
    }
  }

  Color get textColor {
    final luminance = flutterColor.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}
