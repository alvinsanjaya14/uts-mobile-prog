import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'models/product.dart';
import 'screens/home_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/saved_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/personal_details_screen.dart';

/// Centralized route names
class AppRoutes {
  static const home = '/';
  static const productDetail = '/product';
  static const saved = '/saved';
  static const profile = '/profile';
  static const personalDetails = '/profile/personal-details';
}

/// GoRouter configuration
final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: AppRoutes.home,
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '${AppRoutes.productDetail}/:id',
      name: 'product-detail',
      builder: (context, state) {
        final extra = state.extra;
        if (extra is Product) {
          return ProductDetailScreen(product: extra);
        }
        // Fallback error UI
        return Scaffold(
          appBar: AppBar(title: const Text('Product not found')),
          body: const Center(child: Text('Missing product data.')),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.saved,
      name: 'saved',
      builder: (context, state) => const SavedScreen(),
    ),
    GoRoute(
      path: AppRoutes.profile,
      name: 'profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: AppRoutes.personalDetails,
      name: 'personal-details',
      builder: (context, state) => const PersonalDetailsScreen(),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    appBar: AppBar(title: const Text('Error')),
    body: Center(child: Text(state.error.toString())),
  ),
);
