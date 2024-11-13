import 'package:flutter/material.dart';
import 'screens/order_history_screen.dart';
import 'screens/login_screen.dart';
import 'screens/products_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/cart_screen.dart';
import 'services/auth_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PearShop App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          elevation: 1,
        ),
      ),
      home: FutureBuilder<String?>(
        future: _authService.getAccessToken(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return snapshot.hasData ? ProductsScreen() : LoginScreen();
        },
      ),
      routes: {
        '/login': (ctx) => LoginScreen(),
        '/products': (ctx) => ProductsScreen(),
        '/product-detail': (ctx) => ProductDetailScreen(),
        '/cart': (ctx) => CartScreen(),
        '/order-history': (ctx) => OrderHistoryScreen(),
      },
    );
  }
}