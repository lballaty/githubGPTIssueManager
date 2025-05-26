import 'package:flutter/material.dart';
import '../models/issue_model.dart';

class IssueList extends StatelessWidget {
  final List<GitHubIssue> issues;

  const IssueList({super.key, required this.issues});

  @override
  Widget build(BuildContext context) {
    if (issues.isEmpty) {
      return const Center(child: Text('No issues to display.'));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: issues.map((issue) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: ListTile(
            title: Text(issue.title),
            subtitle: Text('Created: ${issue.createdAt}'),
            trailing: Text(issue.state.toUpperCase()),
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text(issue.title),
                  content: Text(issue.body ?? '(No description)'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _launchURL(context, issue.url);
                      },
                      child: const Text('View on GitHub'),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      }).toList(),
    );
  }

  void _launchURL(BuildContext context, String url) {
    // Placeholder - use url_launcher in future
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Open in browser: $url')),
    );
  }
}
