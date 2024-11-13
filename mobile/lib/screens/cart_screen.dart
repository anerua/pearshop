import 'package:flutter/material.dart';
import '../../models/cart_item.dart';
import '../../services/cart_service.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartService _cartService = CartService();
  final _addressController = TextEditingController();
  List<CartItem> _cartItems = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
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

  Future<bool?> _showCheckoutDialog() async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delivery Address'),
          content: TextField(
            controller: _addressController,
            decoration: InputDecoration(
              hintText: 'Enter your delivery address',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
                _addressController.clear();
              },
            ),
            TextButton(
              child: Text('Confirm'),
              onPressed: () async {
                if (_addressController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter a delivery address')),
                  );
                  return;
                }
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
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
                    itemBuilder: (ctx, i) => Dismissible(  // swipe-to-delete
                      key: Key(_cartItems[i].id.toString()),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(right: 20),
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                      onDismissed: (direction) async {
                        final removedItem = _cartItems[i];
                        setState(() {
                          _cartItems.removeAt(i);
                        });
                        try {
                          await _cartService.removeFromCart(removedItem.id);
                        } catch (e) {
                          if (e.toString().contains('401')) {
                            Navigator.of(context).pushReplacementNamed('/login');
                          }
                          setState(() {
                            _cartItems.insert(i, removedItem);
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Failed to remove item')),
                          );
                        }
                      },
                      child: Card(
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
                          subtitle: Row(
                            children: [
                              Text('\$${_cartItems[i].product.price.toStringAsFixed(2)}'),
                              Spacer(),
                              // Quantity controls
                              IconButton(
                                icon: Icon(Icons.remove_circle_outline),
                                onPressed: _cartItems[i].quantity > 1
                                    ? () async {
                                        try {
                                          setState(() => _isLoading = true);
                                          await _cartService.updateQuantity(
                                            _cartItems[i].id,
                                            _cartItems[i].quantity - 1,
                                          );
                                          await _loadCart(); // Refresh the cart
                                        } catch (e) {
                                          if (e.toString().contains('401')) {
                                            Navigator.of(context)
                                                .pushReplacementNamed('/login');
                                          }
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                                content:
                                                    Text('Failed to update quantity')),
                                          );
                                        } finally {
                                          setState(() => _isLoading = false);
                                        }
                                      }
                                    : null, // Disable if quantity is 1
                              ),
                              Text(
                                '${_cartItems[i].quantity}',
                                style: TextStyle(fontSize: 16),
                              ),
                              IconButton(
                                icon: Icon(Icons.add_circle_outline),
                                onPressed: () async {
                                  try {
                                    setState(() => _isLoading = true);
                                    await _cartService.updateQuantity(
                                      _cartItems[i].id,
                                      _cartItems[i].quantity + 1,
                                    );
                                    await _loadCart(); // Refresh the cart
                                  } catch (e) {
                                    if (e.toString().contains('401')) {
                                      Navigator.of(context)
                                          .pushReplacementNamed('/login');
                                    }
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text('Failed to update quantity')),
                                    );
                                  } finally {
                                    setState(() => _isLoading = false);
                                  }
                                },
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '\$${(_cartItems[i].product.price * _cartItems[i].quantity).toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 16),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () async {
                                  try {
                                    setState(() => _isLoading = true);
                                    await _cartService.removeFromCart(_cartItems[i].id);
                                    await _loadCart();
                                  } catch (e) {
                                    if (e.toString().contains('401')) {
                                      Navigator.of(context)
                                          .pushReplacementNamed('/login');
                                    }
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Failed to remove item')),
                                    );
                                  } finally {
                                    setState(() => _isLoading = false);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
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
                                final proceed = await _showCheckoutDialog();
                                if (proceed == true) {
                                  setState(() => _isLoading = true);
                                  try {
                                    // Get list of cart item IDs
                                    final List<int> orderItemIds = _cartItems
                                        .map((item) => item.id)
                                        .toList();

                                    await _cartService.checkout(
                                      _addressController.text.trim(),
                                      orderItemIds,
                                    );

                                    _addressController.clear();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Order placed successfully'),
                                      ),
                                    );
                                    await _loadCart(); // Refresh cart after checkout
                                  } catch (e) {
                                    if (e.toString().contains('401')) {
                                      Navigator.of(context)
                                          .pushReplacementNamed('/login');
                                    }
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Failed to place order'),
                                      ),
                                    );
                                  } finally {
                                    setState(() => _isLoading = false);
                                  }
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
