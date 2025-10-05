import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/cart_controller.dart'; // <-- Tambahkan import
import 'controllers/product_controller.dart';
import 'controllers/restaurant_controller.dart';
import 'services/product_service.dart';
import 'services/restaurant_service.dart';
import 'routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProductController(ProductService())..loadProducts(),
        ),
        ChangeNotifierProvider(
          create: (_) => RestaurantController(RestaurantService())..loadRestaurants(),
        ),
        ChangeNotifierProvider( // <-- Tambahkan ini
          create: (_) => CartController(),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Restaurant App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 0, 127, 95)),
          scaffoldBackgroundColor: Colors.white,
          useMaterial3: true,
        ),
        routerConfig: appRouter,
      ),
    );
  }
}