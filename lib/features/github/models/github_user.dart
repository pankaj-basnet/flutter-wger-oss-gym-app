import 'package:freezed_annotation/freezed_annotation.dart';

part 'github_user.freezed.dart';
part 'github_user.g.dart';

@freezed
@JsonSerializable()
class GithubUser with _$GithubUser {
  @override
  final String login;

  @override
  @JsonKey(name: 'avatar_url')
  final String avatarUrl;

  @override
  @JsonKey(name: 'html_url')
  final String htmlUrl;

  @override
  @Default(0)
  final int id;

  GithubUser({
    required this.login,
    required this.avatarUrl,
    required this.htmlUrl,
    this.id = 0,
  });

  factory GithubUser.fromJson(Map<String, dynamic> json) =>
      _$GithubUserFromJson(json);

  Map<String, dynamic> toJson() => _$GithubUserToJson(this);
}
