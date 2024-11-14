# PearShop E-commerce Platform

A full-stack e-commerce platform consisting of a Django REST API backend, Next.js admin interface, and Flutter mobile application.

## Tech Stack

- **Backend**: Django, Django REST Framework
- **Admin Interface**: Next.js, TypeScript, CSS
- **Mobile App**: Flutter, Dart
- **Database**: SQLite
- **Authentication**: JWT (JSON Web Tokens)

## Project Structure

```
.
├── admin/ # Next.js Admin Interface
├── backend/ # Django REST API
├── mobile/ # Flutter Mobile App
└── README.md
```

## Components

### 🔧 Backend (Django REST API)
- JWT Authentication
- Product Management
- Shopping Cart System
- Order Processing
- Permission-based Access Control

[View Backend Documentation](backend/README.md)

### 💻 Admin Interface (Next.js)
- Product Management (CRUD)
- Order Management (View orders)
- JWT Authentication
- Responsive Design

[View Admin Documentation](admin/README.md)

### 📱 Mobile App (Flutter)
- Product Browsing
- Shopping Cart Management
- Make Orders
- View past orders
- JWT Authentication

[View Mobile Documentation](mobile/README.md)


## Scaling and Optimization to handle 10,000 requests per minute
In order to scale and optimize the system to handle 10,000 requests per minute, the following core areas should be considered:
1. **Database Scaling andOptimization**
1. **Caching and Content Delivery Network (CDN)**
1. **Application Level Optimizations**
1. **Infrastructure Scaling**
1. **Security and Monitoring**

### 1. Database Scaling and Optimization
For database scaling and optimization, the following strategies can be employed:
- Use a more scalable database such as PostgreSQL or MySQL as against SQLite
- Use connection pooling to manage database connections. For Django, we can use the `django-db-connection-pool` library
- We can optimize queries by indexing frequently queried fields
- We can also optimize queries by using select_related and prefetch_related for related field queries
- We can implement query caching for read-heavy operations
- We can also setup read replicas of the database for read-heavy operations

### 2. Caching and CDN
Caching will help reduce the load on the database by reducing the number of read operations on the database. It will also ensure faster response time, especially for frequently accessed data. We can implement the following caching strategies:
- Use Django's built-in caching framework to cache frequently accessed data. This can be configured with Redis or Memcached
- We can employ a multi-level caching strategy for both the database and API responses
- We use both write-through and lazy loading caching patterns and we set an appropriate cache expiration policy after monitoring the cache hit ratio
- A CDN can be used to cache static assets, e.g. product images. CDN also helps to serve static assets faster and reduce the load on the server
- We can also use browser caching to cache static assets at the client side

### 3. Application Level Optimizations
There are several optimizations that can be applied at the application level to improve performance:
- We can implement exponential backoff retry mechanism for the mobile app and admin interface to reduce the number of requests to the backend
- We can also implement request batching to reduce the number of requests to the backend
- We can implement pagination on the backend to reduce the size of records returned in each request
- We can optimize the serializer to return only the necessary fields and avoid over-fetching
- We can also add field filtering on the backend, so that the mobile app and admin interface can offload filtering to the backend.

### 4. Infrastructure Scaling
In order to scale the infrastructure, we can deploy the application on a cloud platform such as AWS, GCP or Azure that allows for easy scaling of resources, both vertically and horizontally.The following are some of the strategies that can be employed:
- We can setup a load balancer to distribute incoming traffic across multiple servers
- We can setup autoscaling groups to automatically scale the number of servers in response to varying loads
- We can also use a DNS service (e.g. AWS Route 53) to route incoming traffic to the nearest server, and for DNS load balancing

For the web server itself, we can use Nginx which is a high performance web server that can handle a large number of concurrent connections, and can be easily configured to work with Django. We can enable compression and caching on Nginx to reduce the amount of data transferred and the load on the server. Finally, we can set request timeouts on Nginx to prevent slow requests from blocking other requests.

### 5. Security and Monitoring
We can setup the following security measures:
- We can implement rate limiting to prevent abuse and ensure fair usage
- We can setup a firewall to block common attacks such as SQL injection and XSS
- We can also setup DDoS protection to protect the application from DDoS attacks
- On Django, we can configure CORS to only allow requests from the admin interface and mobile app
- Django already has a built-in CSRF protection so we don't have to worry about that.

It is also important to setup a monitoring system to monitor the health and performance of the application. We can use a combination of tools to monitor the application, including:
- Django Health Checks to monitor the health of the Django application
- Nginx logs to monitor the health of the web server
- Database monitoring tools such as Prometheus and Grafana to monitor the database performance
- Uptime monitoring tools such as UptimeRobot to monitor the uptime and responsiveness of the application
- On AWS, we can also use CloudWatch for monitoring and we can setup alarms to notify us when certain metrics exceed certain thresholds.


These are some of the measures that we can take to ensure the application is scalable and can handle 10,000 requests per minute.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details