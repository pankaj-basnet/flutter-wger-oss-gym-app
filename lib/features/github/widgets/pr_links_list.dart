// lib/features/github/github/widgets/pr_links_list.dart

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PrLinksList extends StatelessWidget {
  const PrLinksList({super.key, required this.linkUrls});

  final List<String> linkUrls;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: linkUrls
          .map(
            (url) => ListTile(
              dense: true,
              leading: const Icon(Icons.link, size: 18),
              title: Text(
                url,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 12,
                ),
              ),
              trailing: const Icon(Icons.open_in_new, size: 16),
              onTap: () => launchUrl(
                Uri.parse(url),
                mode: LaunchMode.externalApplication,
              ),
            ),
          )
          .toList(),
    );
  }
}
