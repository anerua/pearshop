import 'package:mockito/mockito.dart';
import 'package:mobile/services/cart_service.dart';
import 'package:mobile/models/cart_item.dart';
import 'package:mobile/models/product.dart';

class MockCartService extends Mock implements CartService {
  final List<CartItem> _cart = [];

  @override
  Future<List<CartItem>> getCart() async {
    return _cart;
  }

  @override
  Future<void> addToCart(int productId, int quantity) async {
    final existingItem = _cart.firstWhere(
      (item) => item.product.id == productId,
      orElse: () => CartItem(
        id: _cart.length + 1,
        product: Product(
          id: productId,
          name: 'Test Product $productId',
          description: 'Test Description',
          price: 100.0,
          image: 'assets/images/placeholder.png',
        ),
        quantity: 0,
      ),
    );

    if (existingItem.quantity == 0) {
      existingItem.quantity = quantity;
      _cart.add(existingItem);
    } else {
      existingItem.quantity += quantity;
    }
  }

  @override
  Future<void> updateQuantity(int cartItemId, int quantity) async {
    final item = _cart.firstWhere((item) => item.id == cartItemId);
    item.quantity = quantity;
  }

  @override
  Future<void> removeFromCart(int cartItemId) async {
    _cart.removeWhere((item) => item.id == cartItemId);
  }

  @override
  Future<void> checkout(String address, List<int> orderItemIds) async {
    if (address.isEmpty) {
      throw Exception('Address is required');
    }
    _cart.clear();
  }
}