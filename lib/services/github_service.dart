// lib/services/github_service.dart
import 'dart:convert';
import 'dart:io';

class GitHubService {
  final String supabaseUrl;
  final String apiKey;

  GitHubService(this.supabaseUrl, this.apiKey);

  Future<void> createIssue({
    required String title,
    required String body,
    required String owner,
    required String repo,
  }) async {
    final uri = Uri.parse('$supabaseUrl/create_issue?owner=$owner&repo=$repo');

    final client = HttpClient();
    final request = await client.postUrl(uri);

    request.headers.set(HttpHeaders.contentTypeHeader, 'application/json');
    request.headers.set('x-api-key', apiKey);

    final payload = jsonEncode({'title': title, 'body': body});
    request.add(utf8.encode(payload));

    final response = await request.close();
    final responseBody = await utf8.decodeStream(response);

    if (response.statusCode >= 400) {
      throw Exception('❌ Failed: ${response.statusCode} - $responseBody');
    }

    print('✅ Issue created: $responseBody');
  }

  Future<List<Map<String, dynamic>>> fetchIssues({
    required String owner,
    required String repo,
  }) async {
    final uri = Uri.parse('$supabaseUrl/get_issues?owner=$owner&repo=$repo');

    final request = await HttpClient().getUrl(uri);
    request.headers.set(HttpHeaders.contentTypeHeader, 'application/json');
    request.headers.set('x-api-key', apiKey);

    final response = await request.close();
    final responseBody = await utf8.decodeStream(response);

    if (response.statusCode >= 400) {
      throw Exception('Failed to fetch issues: ${response.statusCode} - $responseBody');
    }

    final List<dynamic> data = jsonDecode(responseBody);
    return data.cast<Map<String, dynamic>>();
  }
}
