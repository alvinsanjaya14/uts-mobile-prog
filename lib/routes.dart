import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'models/product.dart';
import 'screens/home_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/profile_screen.dart';

/// Centralized route names
class AppRoutes {
  static const home = '/';
  static const productDetail = '/product';
  static const profile = '/profile';
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
      path: AppRoutes.profile,
      name: 'profile',
      builder: (context, state) => const ProfileScreen(),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    appBar: AppBar(title: const Text('Error')),
    body: Center(child: Text(state.error.toString())),
  ),
);
