import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PersonalDetailsScreen extends StatelessWidget {
  const PersonalDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal details'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 8),
          _buildDetailTile('Name', 'John Doe'),
          _buildDetailTile('Email', 'johndoe@gmail.com'),
          _buildDetailTile('Phone', '+1 778 646 1646'),
        ],
      ),
    );
  }

  Widget _buildDetailTile(String title, String value) {
    return Column(
      children: [
        ListTile(
          title: Text(title, style: const TextStyle(color: Colors.grey)),
          subtitle: Text(value, style: const TextStyle(fontSize: 16)),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {},
        ),
        const Divider(height: 1),
      ],
    );
  }
}
