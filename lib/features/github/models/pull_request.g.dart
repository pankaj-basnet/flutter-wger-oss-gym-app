// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pull_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PullRequest _$PullRequestFromJson(Map<String, dynamic> json) => PullRequest(
  id: (json['id'] as num).toInt(),
  number: (json['number'] as num).toInt(),
  title: json['title'] as String,
  body: json['body'] as String? ?? '',
  state: json['state'] as String? ?? 'open',
  htmlUrl: json['html_url'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
  mergedAt: json['merged_at'] == null
      ? null
      : DateTime.parse(json['merged_at'] as String),
  closedAt: json['closed_at'] == null
      ? null
      : DateTime.parse(json['closed_at'] as String),
  user: GithubUser.fromJson(json['user'] as Map<String, dynamic>),
  labels:
      (json['labels'] as List<dynamic>?)
          ?.map((e) => PrLabel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  commentsCount: (json['comments'] as num?)?.toInt() ?? 0,
  draft: json['draft'] as bool? ?? false,
);

Map<String, dynamic> _$PullRequestToJson(PullRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'number': instance.number,
      'title': instance.title,
      'body': instance.body,
      'state': instance.state,
      'html_url': instance.htmlUrl,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'merged_at': instance.mergedAt?.toIso8601String(),
      'closed_at': instance.closedAt?.toIso8601String(),
      'user': instance.user,
      'labels': instance.labels,
      'comments': instance.commentsCount,
      'draft': instance.draft,
    };
