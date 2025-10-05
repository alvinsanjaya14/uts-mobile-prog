import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HelpCentreScreen extends StatelessWidget {
  const HelpCentreScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help Centre'),
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
          ListTile(
            title: const Text('Contact us'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/help/contact'),
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text('How Bitedeal work'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/help/how-it-works'),
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text('How can I cancel my order?'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/help/cancel-order'),
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text('I missed my collection time'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/help/collection-time'),
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text('Join us'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/help/join'),
          ),
        ],
      ),
    );
  }
}
