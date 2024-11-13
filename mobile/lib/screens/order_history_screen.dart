import 'package:flutter/material.dart';
import '../models/order.dart';
import '../services/order_service.dart';

class OrderHistoryScreen extends StatefulWidget {
  @override
  _OrderHistoryScreenState createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  final OrderService _orderService = OrderService();
  List<Order> _orders = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() => _isLoading = true);
    try {
      final orders = await _orderService.getOrders();
      setState(() => _orders = orders);
    } catch (e) {
      if (e.toString().contains('401')) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
      print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load orders')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order History'),
      ),
      body: RefreshIndicator(
        onRefresh: _loadOrders,
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _orders.isEmpty
                ? Center(child: Text('No orders found'))
                : ListView.builder(
                    itemCount: _orders.length,
                    itemBuilder: (ctx, i) => Card(
                      margin: EdgeInsets.all(8),
                      child: ExpansionTile(
                        title: Text('Order #${_orders[i].id}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Date: ${_orders[i].createdAt.toString().split('.')[0]}',
                              style: TextStyle(fontSize: 12),
                            ),
                            Text(
                              'Total: ${_orders[i].total.toStringAsFixed(2)} NGN',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        children: [
                          Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Delivery Address:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(_orders[i].deliveryAddress),
                                SizedBox(height: 8),
                                Text(
                                  'Items:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                ...(_orders[i].items.map((item) => ListTile(
                                      dense: true,
                                      title: Text(item.product.name),
                                      subtitle: Text(
                                          'Quantity: ${item.quantity} x ${item.product.price.toStringAsFixed(2)} NGN'),
                                      trailing: Text(
                                        '${(item.quantity * item.product.price).toStringAsFixed(2)} NGN',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ))),
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
