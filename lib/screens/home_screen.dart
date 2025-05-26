import 'package:flutter/material.dart';
import '../services/github_service.dart';
import '../models/issue_model.dart';
import '../widgets/issue_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _tokenController = TextEditingController();
  final TextEditingController _ownerController = TextEditingController();
  final TextEditingController _repoController = TextEditingController();

  GitHubService? _service;
  List<GitHubIssue> _issues = [];
  String? _error;

  Future<void> _loadIssues() async {
    setState(() {
      _error = null;
      _issues = [];
    });

    try {
      final service = GitHubService("https://juqlmvsnlpunbbluigdp.functions.supabase.co/get_issues
");

      final issues = await service.fetchIssues(
        _ownerController.text.trim(),
        _repoController.text.trim(),
      );

      setState(() {
        _service = service;
        _issues = issues;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GitHub Issue Manager'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
// Remove this:
// TextField(
//   controller: _tokenController,
//   decoration: InputDecoration(...),
//   obscureText: true,
// ),

            const SizedBox(height: 8),
            TextField(
              controller: _ownerController,
              decoration: const InputDecoration(labelText: 'Repo Owner (e.g., torvalds)'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _repoController,
              decoration: const InputDecoration(labelText: 'Repo Name (e.g., linux)'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _loadIssues,
              child: const Text('Load Issues'),
            ),
            const SizedBox(height: 20),
            if (_error != null)
              Text(
                _error!,
                style: const TextStyle(color: Colors.red),
              ),
            IssueList(issues: _issues),
          ],
        ),
      ),
    );
  }
}

