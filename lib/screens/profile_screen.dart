import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uts_mobile_restoran/routes.dart';
import '../widgets/bottom_navbar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.green[100],
                  child: const Icon(
                    Icons.person,
                    size: 32,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'John Smith',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'johndoe@gmail.com',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Quick stats row
            Row(
              children: [
                _statCard('\$13', 'Wallet'),
                _statCard('2', 'Orders'),
                _statCard('11 lb', 'CO₂'),
              ],
            ),

            const SizedBox(height: 18),

            Expanded(
              child: ListView(
                children: [
                  _buildListTile(
                    'Personal details',
                    onTap: () {
                      context.push(AppRoutes.personalDetails);
                    },
                  ),
                  _buildListTile(
                    'My Orders',
                    onTap: () {
                      context.push(AppRoutes.myOrders);
                    },
                  ),
                  _buildListTile(
                    'App notifications',
                    onTap: () {
                      context.push(AppRoutes.notifications);
                    },
                  ),
                  _buildListTile(
                    'Help centre',
                    onTap: () {
                      context.push(AppRoutes.help);
                    },
                  ),
                  _buildListTile(
                    'Privacy and data',
                    onTap: () {
                      context.push(AppRoutes.privacy);
                    },
                  ),
                  _buildListTile(
                    'Terms and conditions',
                    onTap: () {
                      context.push(AppRoutes.terms);
                    },
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[50],
                      foregroundColor: Colors.black,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.0),
                      child: Text('Sign out'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Delete account',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavbar(currentIndex: 4),
    );
  }

  Widget _statCard(String value, String label) {
    return Expanded(
      child: Container(
        height: 72,
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(String title, {VoidCallback? onTap}) {
    return Column(
      children: [
        ListTile(
          title: Text(title),
          trailing: const Icon(Icons.chevron_right),
          onTap: onTap,
        ),
        const Divider(height: 1),
      ],
    );
  }
}
