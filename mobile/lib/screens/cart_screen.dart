import 'package:flutter/material.dart';
import '../../models/cart_item.dart';
import '../../services/cart_service.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartService _cartService = CartService();
  List<CartItem> _cartItems = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  Future<void> _loadCart() async {
    try {
      final items = await _cartService.getCart();
      setState(() {
        _cartItems = items;
      });
    } catch (e) {
      if (e.toString().contains('401')) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load cart')),
      );
    }
  }

  double get totalAmount {
    return _cartItems.fold(0.0,
        (sum, item) => sum + (item.product.price * item.quantity));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _cartItems.length,
                    itemBuilder: (ctx, i) => Card(
                      margin: EdgeInsets.all(8),
                      child: ListTile(
                        leading: Image.network(
                          _cartItems[i].product.image ??
                              'assets/images/placeholder.png',
                          width: 50,
                          errorBuilder: (ctx, error, _) =>
                              Image.asset('assets/images/placeholder.png', width: 50),
                        ),
                        title: Text(_cartItems[i].product.name),
                        subtitle: Text(
                            '\$${_cartItems[i].product.price.toStringAsFixed(2)} x ${_cartItems[i].quantity}'),
                        trailing: Text(
                            '\$${(_cartItems[i].product.price * _cartItems[i].quantity).toStringAsFixed(2)}'),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total:',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '\$${totalAmount.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _cartItems.isEmpty
                            ? null
                            : () async {
                                setState(() => _isLoading = true);
                                try {
                                  await _cartService.checkout();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text('Order placed successfully')),
                                  );
                                  await _loadCart(); // Refresh cart after checkout
                                } catch (e) {
                                  if (e.toString().contains('401')) {
                                    Navigator.of(context).pushReplacementNamed('/login');
                                  }
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text('Failed to place order')),
                                  );
                                } finally {
                                  setState(() => _isLoading = false);
                                }
                              },
                        child: Text('Checkout'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 50),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}