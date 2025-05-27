// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/github_service.dart';
import 'create_issue_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _ownerController = TextEditingController();
  final TextEditingController _repoController = TextEditingController();
  final TextEditingController _filterController = TextEditingController();

  List<String> _ownerHistory = [];
  List<String> _repoHistory = [];

  GitHubService? _service;
  List<Map<String, dynamic>> _issues = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _ownerHistory = prefs.getStringList('ownerHistory') ?? [];
      _repoHistory = prefs.getStringList('repoHistory') ?? [];

      if (_ownerHistory.isNotEmpty) _ownerController.text = _ownerHistory.first;
      if (_repoHistory.isNotEmpty) _repoController.text = _repoHistory.first;
    });
  }

  Future<void> _saveToHistory(String owner, String repo) async {
    final prefs = await SharedPreferences.getInstance();

    _ownerHistory.remove(owner);
    _repoHistory.remove(repo);

    _ownerHistory.insert(0, owner);
    _repoHistory.insert(0, repo);

    if (_ownerHistory.length > 10) _ownerHistory = _ownerHistory.sublist(0, 10);
    if (_repoHistory.length > 10) _repoHistory = _repoHistory.sublist(0, 10);

    await prefs.setStringList('ownerHistory', _ownerHistory);
    await prefs.setStringList('repoHistory', _repoHistory);
  }

  Future<void> _loadIssues() async {
    setState(() {
      _error = null;
      _issues = [];
    });

    try {
      final owner = _ownerController.text.trim();
      final repo = _repoController.text.trim();

      final service = GitHubService(
        "https://juqlmvsnlpunbbluigdp.functions.supabase.co",
        "githubgpt_access_92f3!",
      );

      final issues = await service.fetchIssues(owner: owner, repo: repo);

      await _saveToHistory(owner, repo);

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
    final filteredIssues = _filterController.text.isEmpty
        ? _issues
        : _issues
            .where((issue) => (issue['title'] ?? '')
                .toLowerCase()
                .contains(_filterController.text.toLowerCase()))
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('GitHub Issue Manager'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 12,
              runSpacing: 8,
              alignment: WrapAlignment.start,
              children: [
                ElevatedButton(
                  onPressed: _loadIssues,
                  child: const Text('Load Issues'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateIssueScreen(
                          supabaseUrl: "https://juqlmvsnlpunbbluigdp.functions.supabase.co",
                          apiKey: "githubgpt_access_92f3!",
                          owner: _ownerController.text.trim(),
                          repo: _repoController.text.trim(),
                        ),
                      ),
                    );
                  },
                  child: const Text('➕ Create New Issue'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _ownerController,
              decoration: InputDecoration(
                labelText: 'Repo Owner',
                suffixIcon: _ownerHistory.isNotEmpty
                    ? PopupMenuButton<String>(
                        icon: const Icon(Icons.arrow_drop_down),
                        onSelected: (value) => setState(() => _ownerController.text = value),
                        itemBuilder: (context) => _ownerHistory
                            .map((owner) => PopupMenuItem(
                                  value: owner,
                                  child: Text(owner),
                                ))
                            .toList(),
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _repoController,
              decoration: InputDecoration(
                labelText: 'Repo Name',
                suffixIcon: _repoHistory.isNotEmpty
                    ? PopupMenuButton<String>(
                        icon: const Icon(Icons.arrow_drop_down),
                        onSelected: (value) => setState(() => _repoController.text = value),
                        itemBuilder: (context) => _repoHistory
                            .map((repo) => PopupMenuItem(
                                  value: repo,
                                  child: Text(repo),
                                ))
                            .toList(),
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _filterController,
              decoration: const InputDecoration(labelText: 'Filter issues by title'),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 20),
            if (_error != null)
              Text(
                _error!,
                style: const TextStyle(color: Colors.red),
              ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredIssues.length,
                itemBuilder: (context, index) {
                  final issue = filteredIssues[index];
                  return ListTile(
                    title: Text(issue['title'] ?? 'No title'),
                    subtitle: Text('State: ${issue['state']}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
