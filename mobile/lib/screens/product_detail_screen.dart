import 'package:flutter/material.dart';
import '../../models/product.dart';
import '../../services/product_service.dart';
import '../../services/cart_service.dart';

class ProductDetailScreen extends StatelessWidget {
  final ProductService _productService = ProductService();
  final CartService _cartService = CartService();

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as int;

    return Scaffold(
      appBar: AppBar(
        title: Text('Product Detail'),
      ),
      body: FutureBuilder<Product>(
        future: _productService.getProductDetails(productId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            if (snapshot.error.toString().contains('401')) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context).pushReplacementNamed('/login');
              });
              return Center(child: CircularProgressIndicator());
            }
            return Center(child: Text('Error loading product'));
          }
          final product = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  product.image ?? 'assets/images/placeholder.png',
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (ctx, error, _) => Image.asset(
                    'assets/images/placeholder.png',
                    height: 300,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '${product.price.toStringAsFixed(2)} NGN',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.green,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(product.description),
                      SizedBox(height: 16),
                      ElevatedButton(
                        child: Text('Add to Cart'),
                        onPressed: () async {
                          try {
                            await _cartService.addToCart(product.id, 1);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Added to cart')),
                            );
                          } catch (e) {
                            if (e.toString().contains('401')) {
                              Navigator.of(context)
                                  .pushReplacementNamed('/login');
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Failed to add to cart')),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
