# PearShop Admin Interface

A Next.js-based admin interface for managing the PearShop e-commerce platform. This interface provides administrators with tools to manage products, view orders, and monitor the platform.

## Prerequisites

- Node.js 18.20 or later
- npm 10.8 or later
- Access to PearShop Backend API

## Setup Instructions

1. **Clone the repository**

```
git clone https://github.com/anerua/pearshop.git
```
```
cd admin
```

2. **Install dependencies**

```
npm install
```

3. **Environment Setup**

Create a `.env` file at the root of the admin directory with the .env provided

4. **Run development server**

```
npm run dev
```

The admin interface will be available at `http://localhost:3000`

## Pages

- `/` - Login page
- `/dashboard` - Main dashboard
- `/products` - Product management
- `/orders` - Order management

## Authentication

The interface uses JWT authentication with the PearShop API. Tokens are stored securely and automatically refreshed when needed.


## Available Scripts

### Development
```
npm run dev
```

### Build
```
npm run build
```

### Production
```
npm run start
```

## License

This project is licensed under the MIT License - see the [LICENSE](../LICENSE) file for details
