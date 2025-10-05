import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'models/product.dart';
import 'screens/home_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/saved_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/personal_details_screen.dart';
import 'screens/my_orders_screen.dart';
import 'screens/privacy_and_data_screen.dart';
import 'screens/notifications_screen.dart';

/// Centralized route names
class AppRoutes {
  static const home = '/';
  static const productDetail = '/product';
  static const saved = '/saved';
  static const profile = '/profile';
  static const personalDetails = '/profile/personal-details';
  static const myOrders = '/profile/my-orders';
  static const privacy = '/profile/privacy';
  static const notifications = '/profile/notifications';
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
    GoRoute(
      path: AppRoutes.myOrders,
      name: 'my-orders',
      builder: (context, state) => const MyOrdersScreen(),
    ),
    GoRoute(
      path: AppRoutes.privacy,
      name: 'privacy',
      builder: (context, state) => const PrivacyAndDataScreen(),
    ),
    GoRoute(
      path: AppRoutes.notifications,
      name: 'notifications',
      builder: (context, state) => const NotificationsScreen(),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    appBar: AppBar(title: const Text('Error')),
    body: Center(child: Text(state.error.toString())),
  ),
);
