// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'github_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GithubUser _$GithubUserFromJson(Map<String, dynamic> json) => GithubUser(
  login: json['login'] as String,
  avatarUrl: json['avatar_url'] as String,
  htmlUrl: json['html_url'] as String,
  id: (json['id'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$GithubUserToJson(GithubUser instance) =>
    <String, dynamic>{
      'login': instance.login,
      'avatar_url': instance.avatarUrl,
      'html_url': instance.htmlUrl,
      'id': instance.id,
    };
