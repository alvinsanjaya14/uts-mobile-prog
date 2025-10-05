import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNavbar extends StatelessWidget {
  final int currentIndex;

  const BottomNavbar({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      selectedItemColor: Colors.green[700],
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_border),
          label: 'Saved',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Browse',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_bag_outlined),
          label: 'Cart',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Profile',
        ),
      ],
      onTap: (index) {
        switch (index) {
          case 0:
            if (currentIndex != 0) {
              context.goNamed('home');
            }
            break;
          case 1:
            if (currentIndex != 1) {
              context.goNamed('saved');
            }
            break;
          case 2:
            // Browse - placeholder for future implementation
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Browse feature coming soon!'),
              ),
            );
            break;
          case 3:
            if (currentIndex != 3) {
              context.goNamed('cart'); // <-- Ubah ini
            }
            break;
          case 4:
            if (currentIndex != 4) {
              context.goNamed('profile');
            }
            break;
        }
      },
    );
  }
}