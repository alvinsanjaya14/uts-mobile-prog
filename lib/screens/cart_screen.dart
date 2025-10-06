import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:uts_mobile_restoran/widgets/custom_button.dart';

import '../controllers/cart_controller.dart';
import '../controllers/product_controller.dart';
import '../models/cart_item.dart';
import '../widgets/bottom_navbar.dart';
import '../routes.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  /// Method untuk menampilkan modal bottom sheet metode pembayaran
  void _showPaymentMethods(BuildContext context) {
    final cartController = context.read<CartController>();

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext bc) {
        // Fungsi untuk menangani proses setelah pembayaran dipilih
        void handlePaymentSelection() {
          // 1. Add each cart item as a new order so it appears in My Orders -> New orders
          final productCtrl = Provider.of<ProductController>(
            context,
            listen: false,
          );
          for (final ci in cartController.items) {
            productCtrl.addOrder(ci.product);
          }
          // 2. Bersihkan keranjang belanja
          cartController.clearCart();
          // 3. Arahkan ke halaman sukses pembayaran
          context.go(AppRoutes.paymentSuccess);
        }

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Center(
                  child: Text(
                    'Select Payment Method',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 24),
                _buildPaymentMethodTile(
                  assetPath:
                      'assets/paypal.png', // Anda perlu menambahkan gambar ini
                  title: 'PayPal',
                  onTap: handlePaymentSelection,
                ),
                const Divider(),
                _buildPaymentMethodTile(
                  icon: Icons.credit_card,
                  iconColor: Colors.grey.shade700,
                  title: 'Credit or Debit Card',
                  onTap: handlePaymentSelection,
                ),
                const Divider(),
                _buildPaymentMethodTile(
                  assetPath:
                      'assets/apple_pay.png', // Anda perlu menambahkan gambar ini
                  title: 'Apple Pay',
                  onTap: handlePaymentSelection,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Helper widget untuk membangun setiap item metode pembayaran
  Widget _buildPaymentMethodTile({
    String? assetPath,
    IconData? icon,
    Color iconColor = Colors.black,
    required String title,
    required VoidCallback onTap,
  }) {
    Widget leadingWidget;
    if (assetPath != null) {
      leadingWidget = Image.asset(assetPath, width: 36, height: 36);
    } else {
      leadingWidget = Icon(icon, color: iconColor, size: 36);
    }

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
      leading: leadingWidget,
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
      ),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Consumer<CartController>(
        builder: (context, cart, child) {
          if (cart.items.isEmpty) {
            return _buildEmptyState(context);
          }
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) {
                    final item = cart.items[index];
                    return _buildCartItemCard(context, item);
                  },
                ),
              ),
              _buildCheckoutSection(context, cart),
            ],
          );
        },
      ),
      bottomNavigationBar: const BottomNavbar(currentIndex: 3),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.shopping_cart_outlined,
              size: 96,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            const Text(
              'Your Cart is Empty',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Looks like you haven\'t added anything to your cart yet.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('Browse Menu'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartItemCard(BuildContext context, CartItem item) {
    final cartController = context.read<CartController>();
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              item.product.imageUrl ?? '',
              width: 70,
              height: 70,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 70,
                height: 70,
                color: Colors.grey[200],
                child: const Icon(Icons.restaurant, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${item.product.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.remove_circle_outline,
                  color: Colors.grey,
                ),
                onPressed: () =>
                    cartController.decrementItemQuantity(item.product.id),
              ),
              Text(
                item.quantity.toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.add_circle_outline,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () =>
                    cartController.incrementItemQuantity(item.product.id),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutSection(BuildContext context, CartController cart) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Subtotal',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  '\$${cart.totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            CustomButton.primary(
              text: 'Confirm and Checkout',
              onPressed: () {
                // Panggil method untuk menampilkan pop-up pembayaran
                _showPaymentMethods(context);
              },
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }
}
