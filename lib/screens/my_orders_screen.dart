import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/product_controller.dart';
import '../widgets/product_card.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  int _tabIndex = 0;

  @override
  void initState() {
    super.initState();
    // ensure saved products are loaded if needed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // No longer automatically loading saved favorites here; orders are in-memory.
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _tabIndex = 0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: _tabIndex == 0
                            ? Colors.green[50]
                            : Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(child: Text('New orders')),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _tabIndex = 1),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: _tabIndex == 1
                            ? Colors.green[50]
                            : Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(child: Text('Past orders')),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<ProductController>(
              builder: (context, ctrl, _) {
                final items = _tabIndex == 0 ? ctrl.newOrders : ctrl.pastOrders;
                // No loading indicator for orders (they are in-memory)
                if (items.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.shopping_bag_outlined,
                            size: 96,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'You haven\'t placed an order',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'You haven\'t placed any orders yet. Start shopping now to fill your cart with your favorite items!',
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Browse menu'),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.only(top: 8),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final p = items[index];
                    return ProductRowCard(
                      product: p,
                      onTap: () {},
                      onFavoriteToggle: () {
                        // Toggle favorite and show snack — this keeps Saved screen in sync
                        () async {
                          final ctrl = Provider.of<ProductController>(
                            context,
                            listen: false,
                          );
                          final wasSaved = await ctrl.isProductSaved(p.id);
                          await ctrl.toggleProductSaved(p);
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  wasSaved
                                      ? '${p.name} removed from saved items'
                                      : '${p.name} added to saved items',
                                ),
                                duration: const Duration(seconds: 2),
                                backgroundColor: Colors.grey[800],
                              ),
                            );
                          }
                        }();
                      },
                      orderStatus: _tabIndex == 0 ? 'In delivery' : null,
                      onFinish: _tabIndex == 0
                          ? () {
                              final ctrl = Provider.of<ProductController>(
                                context,
                                listen: false,
                              );
                              ctrl.markOrderAsPast(p);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Marked as finished'),
                                ),
                              );
                            }
                          : null,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
