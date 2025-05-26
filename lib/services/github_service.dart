import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/issue_model.dart';

class GitHubService {
  final String supabaseUrl;

  GitHubService(this.supabaseUrl);

  Future<List<GitHubIssue>> fetchIssues(String owner, String repo) async {
    final uri = Uri.parse('$supabaseUrl/get_issues?owner=$owner&repo=$repo');
    final response = await http.get(
      uri,
      headers: {
        'Accept': 'application/json',
        // Optionally add:
        'x-api-key': 'githubgpt_access_92f3!%', // match what you set in Supabase
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => GitHubIssue.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load issues: ${response.statusCode}');
    }
  }
}
