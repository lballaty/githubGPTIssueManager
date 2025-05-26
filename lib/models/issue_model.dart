class GitHubIssue {
  final int id;
  final String title;
  final String state;
  final String url;
  final String createdAt;
  final String? body;

  GitHubIssue({
    required this.id,
    required this.title,
    required this.state,
    required this.url,
    required this.createdAt,
    this.body,
  });

  factory GitHubIssue.fromJson(Map<String, dynamic> json) {
    return GitHubIssue(
      id: json['id'],
      title: json['title'] ?? 'No title',
      state: json['state'] ?? 'open',
      url: json['html_url'] ?? '',
      createdAt: json['created_at'] ?? '',
      body: json['body'],
    );
  }
}
