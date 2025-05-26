import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const GitHubGPTIssueManagerApp());
}

class GitHubGPTIssueManagerApp extends StatelessWidget {
  const GitHubGPTIssueManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GitHub GPT Issue Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
