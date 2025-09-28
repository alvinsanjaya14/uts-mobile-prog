import 'package:flutter/material.dart';
import 'product_detail.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 44,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.search, color: Colors.grey),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Search',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.location_on, color: Colors.green),
                        SizedBox(width: 6),
                        Text(
                          '48 N 5th St - 2mi',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Categories horizontal
            SizedBox(
              height: 96,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  const SizedBox(width: 6),
                  _buildCategoryButton(Icons.filter_list, 'Filters'),
                  const SizedBox(width: 8),
                  _buildCategoryChip('Italian'),
                  const SizedBox(width: 8),
                  _buildCategoryChip('Mexican'),
                  const SizedBox(width: 8),
                  _buildCategoryChip('Indian'),
                  const SizedBox(width: 8),
                  _buildCategoryChip('Lebanese'),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Row(
                        children: const [
                          Text(
                            'Pick today',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Pick tomorrow',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Deals near you - horizontal cards
                      const Text(
                        'Deals near you',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 180,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            _buildFoodCard(
                              context,
                              'Vitello Tonnato',
                              '\$6.99',
                            ),
                            const SizedBox(width: 12),
                            _buildFoodCard(context, 'Pastelón', '\$5.99'),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Points banner
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF0AA67B), Color(0xFF39BFA0)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  '1100 points',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {},
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.white,
                                  ),
                                  child: const Text(
                                    'View history',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            // progress indicator mimic
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                LinearProgressIndicator(
                                  value: 0.55,
                                  color: Colors.white,
                                  backgroundColor: Colors.white24,
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Get a free meal when you collect 2000 points.',
                                          style: TextStyle(
                                            color: Colors.white70,
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: null,
                                          child: Text('Redeem'),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 18),

                      // Expiring soon
                      const Text(
                        'Expiring soon',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 160,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            _buildFoodCard(
                              context,
                              'Alcapurrias',
                              '\$6.99',
                              small: true,
                            ),
                            const SizedBox(width: 12),
                            _buildFoodCard(
                              context,
                              'Carrot–Harissa',
                              '\$4.99',
                              small: true,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 18),
                      const Text(
                        'Popular items',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 160,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            _buildFoodCard(
                              context,
                              'Fried rice',
                              '\$2.99',
                              small: true,
                            ),
                            const SizedBox(width: 12),
                            _buildFoodCard(
                              context,
                              'Rice desert',
                              '\$2.99',
                              small: true,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 18),
                      // Promo card
                      Container(
                        width: double.infinity,
                        height: 140,
                        decoration: BoxDecoration(
                          color: Colors.teal[50],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      'Grab Happiness by the Bite!',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Your Ultimate Happy Hour Meal App for Delicious Deals!',
                                    ),
                                    SizedBox(height: 12),
                                    ElevatedButton(
                                      onPressed: null,
                                      child: Text('Get Started now'),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              // placeholder image circle
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.green[200],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      // Bottom navigation
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Saved',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Browse'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.green[700],
        onTap: (i) {},
      ),
    );
  }

  Widget _buildCategoryButton(IconData icon, String label) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
          ),
          child: Icon(icon, color: Colors.black54),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildCategoryChip(String label) {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: Colors.orange[100],
            borderRadius: BorderRadius.circular(32),
          ),
          child: Center(
            child: Text(
              label[0],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildFoodCard(
    BuildContext context,
    String title,
    String price, {
    bool small = false,
  }) {
    return GestureDetector(
      onTap: () {
        // Sample product data based on the JSON structure
        final sampleProduct = {
          'product': {
            'imageurl': null, // You can add actual image URLs here
            'name': title,
            'rating': 4.3,
            'rating_count': 60,
            'location': '23 Spruce Street, Portland, OR 97214',
            'price': double.tryParse(price.replaceAll('\$', '')) ?? 0.0,
            'ingredients': [
              {'name': 'Chicken breast', 'qty': '200', 'unit': 'g'},
              {'name': 'Bell peppers', 'qty': '100', 'unit': 'g'},
              {'name': 'Onions', 'qty': '50', 'unit': 'g'},
              {'name': 'Tomatoes', 'qty': '150', 'unit': 'g'},
              {'name': 'Rice', 'qty': '1', 'unit': 'cup'},
            ],
            'allergens': ['Gluten', 'Dairy'],
            'availability': 'Pick up 1:00 PM - 3:00 PM',
          },
        };

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: sampleProduct),
          ),
        );
      },
      child: Container(
        width: small ? 160 : 260,
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: small ? 80 : 110,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: const Center(
                child: Icon(Icons.image, size: 36, color: Colors.grey),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    price,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: const [
                      Icon(Icons.access_time, size: 14, color: Colors.grey),
                      SizedBox(width: 6),
                      Text(
                        '08 - 10 pm',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.location_on, size: 14, color: Colors.grey),
                      SizedBox(width: 6),
                      Text(
                        '0.8 mi',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
