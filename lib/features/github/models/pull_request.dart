import 'package:freezed_annotation/freezed_annotation.dart';
import 'github_user.dart';
import 'pr_label.dart';

part 'pull_request.freezed.dart';
part 'pull_request.g.dart';

enum PrState { open, closed, all }

@freezed
@JsonSerializable()
class PullRequest with _$PullRequest {
  @override
  final int id;

  @override
  final int number;

  @override
  final String title;

  @override
  @JsonKey(defaultValue: '')
  final String body;

  @override
  @JsonKey(defaultValue: 'open')
  final String state;

  @override
  @JsonKey(name: 'html_url')
  final String htmlUrl;

  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @override
  @JsonKey(name: 'merged_at')
  final DateTime? mergedAt;

  @override
  @JsonKey(name: 'closed_at')
  final DateTime? closedAt;

  @override
  final GithubUser user;

  @override
  @JsonKey(defaultValue: [])
  final List<PrLabel> labels;

  @override
  @JsonKey(name: 'comments', defaultValue: 0)
  final int commentsCount;

  @override
  @JsonKey(defaultValue: false)
  final bool draft;

  PullRequest({
    required this.id,
    required this.number,
    required this.title,
    this.body = '',
    this.state = 'open',
    required this.htmlUrl,
    required this.createdAt,
    required this.updatedAt,
    this.mergedAt,
    this.closedAt,
    required this.user,
    this.labels = const [],
    this.commentsCount = 0,
    this.draft = false,
  });

  factory PullRequest.fromJson(Map<String, dynamic> json) =>
      _$PullRequestFromJson(json);
  Map<String, dynamic> toJson() => _$PullRequestToJson(this);

  List<String> get imageUrls {
    final exp = RegExp(r'!\[.*?\]\((.*?)\)');
    return exp.allMatches(body).map((m) => m.group(1)!).toList();
  }

  List<String> get linkUrls {
    final exp = RegExp(r'(?<!!)\[.*?\]\((https?://.*?)\)');
    return exp.allMatches(body).map((m) => m.group(1)!).toList();
  }

  bool get isOpen => state == 'open';
  bool get isMerged => mergedAt != null;
  bool get isClosed => state == 'closed' && mergedAt == null;
}
