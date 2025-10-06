import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:uts_mobile_restoran/routes.dart';
import 'package:uts_mobile_restoran/screens/loginOrSignup_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/bottom_navbar.dart';
import '../controllers/product_controller.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _name = 'John Smith';
  String _email = 'johndoe@gmail.com';

  static const _kName = 'user_name';
  static const _kEmail = 'user_email';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final name = prefs.getString(_kName);
      final email = prefs.getString(_kEmail);
      if (mounted) {
        setState(() {
          if (name != null) _name = name;
          if (email != null) _email = email;
        });
      }
    } catch (_) {}
  }

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
                  children: [
                    Text(
                      _name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(_email, style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Quick stats row (wallet/orders/co2). Orders count is read from ProductController
            Consumer<ProductController>(
              builder: (context, ctrl, _) {
                final ordersCount =
                    ctrl.newOrders.length + ctrl.pastOrders.length;
                return Row(
                  children: [
                    _statCard('\$13', 'Wallet'),
                    _statCard(ordersCount.toString(), 'Orders'),
                    _statCard('11 lb', 'CO₂'),
                  ],
                );
              },
            ),

            const SizedBox(height: 18),

            Expanded(
              child: ListView(
                children: [
                  _buildListTile(
                    'Personal details',
                    onTap: () async {
                      await context.push(AppRoutes.personalDetails);
                      // refresh profile header (name/email) after returning
                      _loadProfile();
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
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Signed out successfully!"),
                        ),
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AccountScreen(),
                        ),
                      );
                    },
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
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Account deleted successfully!"),
                        ),
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AccountScreen(),
                        ),
                      );
                    },
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
