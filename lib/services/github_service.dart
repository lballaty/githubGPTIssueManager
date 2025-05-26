import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/issue_model.dart';

class GitHubService {
  final String token;

  GitHubService(this.token);

  Future<List<GitHubIssue>> fetchIssues(String owner, String repo) async {
    final url = Uri.https('api.github.com', '/repos/$owner/$repo/issues');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'token $token',
        'Accept': 'application/vnd.github+json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => GitHubIssue.fromJson(item)).toList();
    } else {
      throw Exception('Failed to fetch issues: ${response.statusCode}');
    }
  }
}
