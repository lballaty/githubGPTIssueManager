// lib/screens/create_issue_screen.dart
import 'package:flutter/material.dart';
import '../services/github_service.dart';

class CreateIssueScreen extends StatefulWidget {
  final String supabaseUrl;
  final String apiKey;
  final String owner;
  final String repo;

  const CreateIssueScreen({
    super.key,
    required this.supabaseUrl,
    required this.apiKey,
    required this.owner,
    required this.repo,
  });

  @override
  State<CreateIssueScreen> createState() => _CreateIssueScreenState();
}

class _CreateIssueScreenState extends State<CreateIssueScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  String? _result;

  Future<void> _submitIssue() async {
    final service = GitHubService(widget.supabaseUrl, widget.apiKey);
    try {
      await service.createIssue(
        title: _titleController.text.trim(),
        body: _bodyController.text.trim(),
        owner: widget.owner,
        repo: widget.repo,
      );
      setState(() => _result = '✅ Issue created!');
    } catch (e) {
      setState(() => _result = '❌ Failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create GitHub Issue')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Issue Title'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _bodyController,
              decoration: const InputDecoration(labelText: 'Issue Description'),
              maxLines: 6,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitIssue,
              child: const Text('Create Issue'),
            ),
            if (_result != null) ...[
              const SizedBox(height: 16),
              Text(_result!, style: const TextStyle(fontSize: 16)),
            ]
          ],
        ),
      ),
    );
  }
}
