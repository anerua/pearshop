import 'package:flutter_test/flutter_test.dart';
import 'mocks/mock_cart_service.dart';

void main() {
  late MockCartService cartService;

  setUp(() {
    cartService = MockCartService();
  });

  group('Cart Tests', () {
    test('Add item to cart', () async {
      await cartService.addToCart(1, 1);
      final cart = await cartService.getCart();
      
      expect(cart.length, 1);
      expect(cart[0].quantity, 1);
    });

    test('Update item quantity', () async {
      await cartService.addToCart(1, 1);
      final cart = await cartService.getCart();
      final itemId = cart[0].id;

      await cartService.updateQuantity(itemId, 3);
      final updatedCart = await cartService.getCart();
      
      expect(updatedCart[0].quantity, 3);
    });

    test('Remove item from cart', () async {
      await cartService.addToCart(1, 1);
      final cart = await cartService.getCart();
      final itemId = cart[0].id;

      await cartService.removeFromCart(itemId);
      final updatedCart = await cartService.getCart();
      
      expect(updatedCart.length, 0);
    });

    test('Checkout with valid address should clear cart', () async {
      await cartService.addToCart(1, 1);
      await cartService.checkout('123 Test St', [1]);
      final cart = await cartService.getCart();
      
      expect(cart.length, 0);
    });

    test('Checkout with empty address should fail', () async {
      await cartService.addToCart(1, 1);
      
      expect(
        () => cartService.checkout('', [1]),
        throwsException,
      );
    });
  });
}