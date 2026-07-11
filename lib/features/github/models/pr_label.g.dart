// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pr_label.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrLabel _$PrLabelFromJson(Map<String, dynamic> json) => PrLabel(
  name: json['name'] as String,
  color: json['color'] as String? ?? 'cccccc',
  description: json['description'] as String?,
);

Map<String, dynamic> _$PrLabelToJson(PrLabel instance) => <String, dynamic>{
  'name': instance.name,
  'color': instance.color,
  'description': instance.description,
};
