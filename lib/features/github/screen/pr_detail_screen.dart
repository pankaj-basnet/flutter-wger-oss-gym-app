// lib/features/github/github/screens/pr_detail_screen.dart
//
// Full PR detail — mirrors wger's NutritionalPlanScreen with SliverAppBar.
// Sections: header, body markdown, images, links.

import 'package:flutter/material.dart';
// import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/pull_request.dart';
import '../widgets/pr_image_gallery.dart';
import '../widgets/pr_label_chip.dart';
import '../widgets/pr_links_list.dart';

class PrDetailScreen extends StatelessWidget {
  const PrDetailScreen({super.key, required this.pr});

  static const routeName = '/pr-detail';

  final PullRequest pr;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── Sticky app bar with PR title ─────────────────────────────────
          SliverAppBar(
            pinned: true,
            expandedHeight: 120,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.fromLTRB(56, 0, 16, 16),
              title: Text(
                '#${pr.number} ${pr.title}',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: Colors.white,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.open_in_browser),
                tooltip: 'Open on GitHub',
                onPressed: () => launchUrl(Uri.parse(pr.htmlUrl)),
              ),
            ],
          ),

          // ── PR metadata ───────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // State chip + draft badge
                  Wrap(
                    spacing: 8,
                    children: [
                      _stateChip(context),
                      if (pr.draft) const Chip(label: Text('Draft')),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Author row
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(pr.user.avatarUrl),
                        radius: 14,
                      ),
                      const SizedBox(width: 8),
                      Text(pr.user.login, style: theme.textTheme.bodyMedium),
                      const SizedBox(width: 8),
                      Text(
                        'opened ${_formatDate(pr.createdAt)}',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Labels
                  if (pr.labels.isNotEmpty)
                    Wrap(
                      spacing: 6,
                      children: pr.labels
                          .map((l) => PrLabelChip(label: l))
                          .toList(),
                    ),

                  const Divider(height: 24),

                  // Images parsed from PR body
                  if (pr.imageUrls.isNotEmpty) ...[
                    Text('Images', style: theme.textTheme.titleSmall),
                    const SizedBox(height: 8),
                    PrImageGallery(imageUrls: pr.imageUrls),
                    const Divider(height: 24),
                  ],

                  // PR body rendered as markdown
                  Text('Description', style: theme.textTheme.titleSmall),
                  const SizedBox(height: 8),
                  // pr.body.isEmpty
                  //     ? Text(
                  //         'No description provided.',
                  //         style: theme.textTheme.bodySmall,
                  //       )
                  //     : MarkdownBody(
                  //         data: pr.body,
                  //         onTapLink: (_, href, __) {
                  //           if (href != null) {
                  //             launchUrl(Uri.parse(href));
                  //           }
                  //         },
                  //       ),
                  const Divider(height: 24),

                  // Links extracted from body
                  if (pr.linkUrls.isNotEmpty) ...[
                    Text('Links', style: theme.textTheme.titleSmall),
                    PrLinksList(linkUrls: pr.linkUrls),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _stateChip(BuildContext context) {
    final Color color;
    final String label;
    if (pr.isMerged) {
      color = Colors.purple;
      label = 'Merged';
    } else if (pr.isOpen) {
      color = Colors.green;
      label = 'Open';
    } else {
      color = Colors.red;
      label = 'Closed';
    }
    return Chip(
      backgroundColor: color.withValues(alpha: 0.15),
      label: Text(label, style: TextStyle(color: color)),
      side: BorderSide(color: color),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
  }
}
