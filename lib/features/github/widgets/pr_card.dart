// lib/features/github/github/widgets/pr_card.dart
//
// ConsumerWidget — mirrors wger's MealWidget (Card + Column).
// Shows: state chip, PR number, title, user avatar, date, label chips.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wger/features/github/screen/pr_detail_screen.dart';

import '../models/pull_request.dart';
// import '../screens/pr_detail_screen.dart';
import 'pr_label_chip.dart';

class PrCard extends ConsumerWidget {
  const PrCard({super.key, required this.pr});

  final PullRequest pr;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.of(
            context,
          ).pushNamed(PrDetailScreen.routeName, arguments: pr);
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // PR number badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '#${pr.number}',
                      style: theme.textTheme.labelSmall,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // State chip
                  _StateChip(pr: pr),
                  if (pr.draft) ...[
                    const SizedBox(width: 4),
                    Chip(
                      label: const Text('Draft'),
                      padding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                      backgroundColor:
                          theme.colorScheme.surfaceContainerHighest,
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 6),
              // Title
              Text(
                pr.title,
                style: theme.textTheme.titleSmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              // Author row — mirrors wger's MealHeader subtitle
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(pr.user.avatarUrl),
                    radius: 10,
                    onBackgroundImageError: (_, __) {},
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      '${pr.user.login} · ${_fmtDate(pr.updatedAt)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.hintColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (pr.commentsCount > 0)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.comment_outlined,
                          size: 12,
                          color: theme.hintColor,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${pr.commentsCount}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.hintColor,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              // Labels
              if (pr.labels.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Wrap(
                    spacing: 4,
                    children: pr.labels
                        .map((l) => PrLabelChip(label: l))
                        .toList(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _fmtDate(DateTime dt) =>
      '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
}

class _StateChip extends StatelessWidget {
  const _StateChip({required this.pr});
  final PullRequest pr;

  @override
  Widget build(BuildContext context) {
    final Color color;
    final String label;
    final IconData icon;

    if (pr.isMerged) {
      color = Colors.purple;
      label = 'Merged';
      icon = Icons.merge;
    } else if (pr.isOpen) {
      color = Colors.green;
      label = 'Open';
      icon = Icons.call_split;
    } else {
      color = Colors.red;
      label = 'Closed';
      icon = Icons.close;
    }

    return Chip(
      avatar: Icon(icon, size: 12, color: color),
      label: Text(label, style: TextStyle(color: color, fontSize: 11)),
      backgroundColor: color.withValues(alpha: 0.1),
      side: BorderSide(color: color.withValues(alpha: 0.4)),
      padding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
    );
  }
}
