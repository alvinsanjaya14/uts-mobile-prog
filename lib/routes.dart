import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'models/product.dart';
import 'views/home_view.dart';
import 'views/product_detail_view.dart';

/// Centralized route names
class AppRoutes {
  static const home = '/';
  static const productDetail = '/product';
}

/// GoRouter configuration
final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: AppRoutes.home,
      name: 'home',
      builder: (context, state) => const HomeView(),
    ),
    GoRoute(
      path: '${AppRoutes.productDetail}/:id',
      name: 'product-detail',
      builder: (context, state) {
        final extra = state.extra;
        if (extra is Product) {
          return ProductDetailView(product: extra);
        }
        // Fallback error UI
        return Scaffold(
          appBar: AppBar(title: const Text('Product not found')),
          body: const Center(child: Text('Missing product data.')),
        );
      },
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    appBar: AppBar(title: const Text('Error')),
    body: Center(child: Text(state.error.toString())),
  ),
);