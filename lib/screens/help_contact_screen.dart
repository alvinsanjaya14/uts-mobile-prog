import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HelpContactScreen extends StatefulWidget {
  const HelpContactScreen({Key? key}) : super(key: key);

  @override
  State<HelpContactScreen> createState() => _HelpContactScreenState();
}

class _HelpContactScreenState extends State<HelpContactScreen> {
  String? _topic;
  String? _order;
  final _messageController = TextEditingController();

  final List<String> _topics = [
    'The store was closed at the collection time',
    "I'm allergic to some of the food I received",
    'Item missing from my order',
  ];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _send() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Message sent')));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact us'),
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
          children: [
            const Text(
              'Got a question about the order?\nIf you need help regarding a specific order, please fill out the form and we\'ll get back to you as soon as possible.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(border: OutlineInputBorder()),
              hint: const Text('Choose a topic'),
              value: _topic,
              items: _topics
                  .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                  .toList(),
              onChanged: (v) => setState(() => _topic = v),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(border: OutlineInputBorder()),
              hint: const Text('Select an order'),
              value: _order,
              items: const [
                DropdownMenuItem(value: 'order1', child: Text('Order #1')),
              ],
              onChanged: (v) => setState(() => _order = v),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.camera_alt),
              label: const Text('Add images'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _messageController,
              maxLines: 6,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your message here',
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: _send, child: const Text('Send')),
          ],
        ),
      ),
    );
  }
}
