import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HelpDetailScreen extends StatelessWidget {
  final String title;
  final String content;
  final String? actionLabel;
  final VoidCallback? action;

  const HelpDetailScreen({
    super.key,
    required this.title,
    required this.content,
    this.actionLabel,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(content, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),
            if (actionLabel != null && action != null)
              ElevatedButton(onPressed: action, child: Text(actionLabel!)),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => context.push('/help/contact'),
              child: const Text('Contact us'),
            ),
          ],
        ),
      ),
    );
  }
}
