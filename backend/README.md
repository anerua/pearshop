# PearShop Backend API

A Django REST API for an e-commerce platform that handles products, shopping cart, and orders.

## Features

- JWT Authentication
- Product Management
- Shopping Cart
- Order Processing
- Permission-based Access Control

## Prerequisites

- Python 3.8+
- pip (Python package manager)
- Virtual environment (recommended)

## Setup Instructions

1. **Clone the repository**

```
git clone https://github.com/anerua/pearshop.git
```
```
cd backend
```

2. **Create and activate virtual environment**

```
python -m venv .venv
```
To activate the virtual environment (Mac and Linux):
```
source .venv/bin/activate
```
On Windows:
```
venv\Scripts\activate
```

3. **Install dependencies**

```
pip install -r requirements.txt
```

4. **Environment Variables**

Create a `.env` file in the root of the backend directory with the values provided.

5. **Database Setup**

SQLite is used as the database. Django will automatically create the database when you run migrate the first time
```
python manage.py migrate
```

6. **Create Superuser (Admin)**

The Superuser is required to access the admin dashboard and to create products.

```
python manage.py createsuperuser
```

7. **Run Development Server**
```
python manage.py runserver
```

The API will be available at `http://localhost:8000/api/`

## API Endpoints

### Authentication
- `POST /api/register/` - Register new user
- `POST /api/login/` - Login user (get JWT tokens)
- `POST /api/token/refresh/` - Refresh JWT token
- `GET /api/check/` - Check authentication status

### Products
- `GET /api/product/` - List all products
- `POST /api/product/` - Create new product (Admin only)
- `GET /api/product/<id>/` - Get product details
- `PUT /api/product/<id>/` - Update product (Admin only)
- `DELETE /api/product/<id>/` - Delete product (Admin only)

### Order Items (Shopping Cart)
- `GET /api/order-item/` - List user's cart items
- `POST /api/order-item/` - Add item to cart
- `GET /api/order-item/<id>/` - Get cart item details
- `PUT /api/order-item/<id>/` - Update cart item (e.g. increase quantity)
- `DELETE /api/order-item/<id>/` - Remove item from cart

### Orders
- `GET /api/order/` - List user's orders
- `POST /api/order/` - Create new order
- `GET /api/order/<id>/` - Get order details

## Models

### Product
- name (CharField)
- price (IntegerField)
- image (URLField)
- description (TextField)

### OrderItem
- user (ForeignKey to User)
- product (ForeignKey to Product)
- quantity (IntegerField)
- total_price (IntegerField)

### Order
- user (ForeignKey to User)
- delivery_address (CharField)
- order_items (ManyToManyField to OrderItem)
- total_price (IntegerField)

## Authentication

The API uses JWT (JSON Web Tokens) for authentication. Include the token in the Authorization header:
```
Authorization: Bearer <your_jwt_token>
```

## Running Tests

```
python manage.py test
```

## License

This project is licensed under the MIT License - see the [LICENSE](../LICENSE) file for details