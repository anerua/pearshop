import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/product.dart';
import '../../services/product_service.dart';
import '../../services/cart_service.dart';
import '../../services/auth_service.dart';

class ProductsScreen extends StatefulWidget {
  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final ProductService _productService = ProductService();
  final CartService _cartService = CartService();
  final AuthService _authService = AuthService();
  List<Product> _products = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      final products = await _productService.getProducts();
      setState(() {
        _products = products;
      });
    } catch (e) {
      if (e.toString().contains('401')) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load products')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/images/pearshop.png',
              height: 40,
              fit: BoxFit.contain,
            ),
            SizedBox(width: 8),
            Text('PearShop'),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () => Navigator.pushNamed(context, '/cart'),
          ),
          PopupMenuButton(
            icon: CircleAvatar(
              child: Icon(Icons.person),
              backgroundColor: Theme.of(context).primaryColorLight,
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: ListTile(
                  leading: Icon(Icons.history),
                  title: Text('Order History'),
                  dense: true,
                ),
                onTap: () {
                  // Need to delay navigation because of PopupMenuButton's built-in navigation
                  Future.delayed(
                    Duration.zero,
                    () => Navigator.pushNamed(context, '/order-history'),
                  );
                },
              ),
              PopupMenuItem(
                child: ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Sign Out'),
                  dense: true,
                ),
                onTap: () async {
                  await _authService.logout();
                  Navigator.pushReplacementNamed(context, '/login');
                },
              ),
            ],
          ),
          SizedBox(width: 8),
        ],
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(8),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: _products.length,
        itemBuilder: (ctx, i) => GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              '/product-detail',
              arguments: _products[i].id,
            );
          },
          child: Card(
            child: Column(
              children: [
                Expanded(
                  child: Hero(
                    // Added Hero widget for smooth transition
                    tag: 'product-${_products[i].id}',
                    child: Image.network(
                      _products[i].image ?? 'assets/images/placeholder.png',
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, error, _) => Image.asset(
                        'assets/images/placeholder.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Text(
                        _products[i].name,
                        style: TextStyle(fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text('${NumberFormat('#,##0.00').format(_products[i].price)} NGN'),
                      ElevatedButton(
                        child: Text('Add to Cart'),
                        onPressed: () async {
                          try {
                            await _cartService.addToCart(_products[i].id, 1);
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
          ),
        ),
      ),
    );
  }
}
