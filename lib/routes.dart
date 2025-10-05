import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'models/product.dart';
import 'screens/cart_screen.dart';
import 'screens/home_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/saved_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/personal_details_screen.dart';
import 'screens/my_orders_screen.dart';
import 'screens/privacy_and_data_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/help_centre_screen.dart';
import 'screens/help_contact_screen.dart';
import 'screens/help_detail_screen.dart';
import 'screens/payment_success_screen.dart';

/// Centralized route names
class AppRoutes {
  static const home = '/';
  static const productDetail = '/product';
  static const saved = '/saved';
  static const cart = '/cart';
  static const profile = '/profile';
  static const personalDetails = '/profile/personal-details';
  static const myOrders = '/profile/my-orders';
  static const privacy = '/profile/privacy';
  static const notifications = '/profile/notifications';
  static const help = '/help';
  static const helpContact = '/help/contact';
  static const helpCancel = '/help/cancel-order';
  static const helpCollection = '/help/collection-time';
  static const helpHowItWorks = '/help/how-it-works';
  static const helpJoin = '/help/join';
  static const terms = '/profile/terms';
  static const paymentSuccess = '/payment-success';
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
      // <-- Tambahkan GoRoute ini
      path: AppRoutes.cart,
      name: 'cart',
      builder: (context, state) => const CartScreen(),
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
      path: AppRoutes.helpHowItWorks,
      name: 'help-how-it-works',
      builder: (context, state) => const HelpDetailScreen(
        title: 'How Bitedeal work',
        content:
            'Bitedeal connects customers with local restaurants and shops offering surplus or discounted meals. Browse deals, place an order for pickup, and enjoy tasty food at a great price. Restaurants list limited-time offers and collection windows; once available, customers can claim and collect within the specified timeframe.',
      ),
    ),
    GoRoute(
      path: AppRoutes.helpJoin,
      name: 'help-join',
      builder: (context, state) => const HelpDetailScreen(
        title: 'Join us',
        content:
            'Interested in partnering with Bitedeal? Join our network to reach new customers and reduce food waste. Register your business, list surplus meals or special offers, and manage collections through our simple dashboard. Get in touch to learn more about onboarding and benefits.',
      ),
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
    GoRoute(
      path: AppRoutes.help,
      name: 'help',
      builder: (context, state) => const HelpCentreScreen(),
    ),
    GoRoute(
      path: AppRoutes.helpContact,
      name: 'help-contact',
      builder: (context, state) => const HelpContactScreen(),
    ),
    GoRoute(
      path: AppRoutes.helpCancel,
      name: 'help-cancel',
      builder: (context, state) => const HelpDetailScreen(
        title: 'Cancel order',
        content:
            'You can cancel up to 2 hours before the start of your collection time by going to your order.\n\nThis ensures that the food can be saved by someone else.',
        actionLabel: 'Go to my orders',
        action: null,
      ),
    ),
    GoRoute(
      path: AppRoutes.helpCollection,
      name: 'help-collection',
      builder: (context, state) => const HelpDetailScreen(
        title: 'Collection time',
        content:
            'You can cancel up to 2 hours before the start of your collection time by going to your order.\n\nThis ensures that the food can be saved by someone else.',
      ),
    ),
    GoRoute(
      path: AppRoutes.terms,
      name: 'terms',
      builder: (context, state) => const HelpDetailScreen(
        title: 'Terms and conditions',
        content:
            'By using Bitedeal, you agree to our terms and conditions. This includes acceptance of our privacy policy, order and collection policies, and the rules governing promotions and refunds. Bitedeal is a marketplace connecting customers and restaurants; we are not responsible for the content provided by restaurants. For detailed legal terms, please review the full policy on our website or contact support for clarifications.',
      ),
    ),
    GoRoute(
      // <-- TAMBAHKAN BLOK INI
      path: AppRoutes.paymentSuccess,
      name: 'payment-success',
      builder: (context, state) => const PaymentSuccessScreen(),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    appBar: AppBar(title: const Text('Error')),
    body: Center(child: Text(state.error.toString())),
  ),
);
