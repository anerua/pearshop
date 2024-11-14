# PearShop Mobile App

A Flutter-based mobile application for the PearShop e-commerce platform. This app allows users to browse products, manage their shopping cart, and track their orders.

## Prerequisites

- Flutter SDK (3.20.0 or higher)
- Dart SDK (3.5 or higher)
- Android Studio / Xcode
- Access to PearShop Backend API

## Setup Instructions

1. **Clone the repository**

```
git clone https://github.com/anerua/pearshop.git
```
```
cd mobile
```

2. **Install dependencies**

```
flutter pub get
```

3. **Environment Setup**

Create a `.env` file at the root of the mobile directory with the .env provided.

**NOTE:** For Android, set the `API_BASE_URL` to `http://10.0.2.2:8000/api` if you are running the Android emulator and the API on the same machine. For iOS, set the `API_BASE_URL` to `http://localhost:8000/api` or `http://127.0.0.1:8000/api` if you are running the iOS simulator and the API on the same machine.

4. **Run the app**
```
flutter run
```

## Screens

### Authentication
- `LoginScreen` - User login and registration

### Shopping
- `ProductsScreen` - Browse available products
- `ProductDetailScreen` - View product details
- `CartScreen` - Manage shopping cart
- `OrderHistoryScreen` - View order history

## Features in Detail

### Shopping Cart
- Add/remove products to/from cart
- Adjust quantities
- Swipe-to-delete functionality

### Order Management
- Place new orders
- View order history
- Add delivery address

## Development

### Running in Development

```
flutter run
```

### Building for Release

#### Android
```
flutter build apk
```

#### iOS
```
flutter build ios
```

### Running Tests

```
flutter test
```

## License

This project is licensed under the MIT License - see the [LICENSE](../LICENSE) file for details