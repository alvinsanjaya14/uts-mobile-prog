# Flutter Restaurant App - AI Coding Guide

## Project Overview
This is a Flutter mobile application for food ordering from restaurants. The app features a home screen displaying restaurant offerings and a detailed product view for individual items.

## Architecture

### Clean Architecture Structure
The project follows Clean Architecture principles with the following layers:

- **Presentation Layer**: UI components and state management
  - `lib/presentation/screens/` - UI screens (to be migrated from `lib/screens/`)
  - `lib/presentation/widgets/` - Reusable UI components
  - `lib/presentation/blocs/` - State management using BLoC/Cubit pattern

- **Domain Layer**: Business logic and entities
  - `lib/domain/entities/` - Business objects and models
  - `lib/domain/repositories/` - Abstract repository definitions
  - `lib/domain/usecases/` - Use cases that encapsulate business rules

- **Data Layer**: Data sources and repository implementations
  - `lib/data/models/` - Data models (DTOs)
  - `lib/data/repositories/` - Implementation of domain repositories
  - `lib/data/datasources/` - Remote and local data sources

### Current Structure (Pre-migration to Clean Architecture)
- **Entry Point**: `lib/main.dart` - Initializes the app with `MaterialApp` and sets the home screen
- **Screen Layer**: `lib/screens/` - Contains UI screens like `home_screen.dart` and `product_detail.dart`
- **Core Layer**: `lib/core/` - Reserved for business logic (currently empty)

### UI Pattern
- Follows Flutter's widget composition pattern
- Utilizes stateful and stateless widgets based on needs
- Screen layouts are built with nested widgets (Scaffold, Container, Row, Column)

## Key Workflows

### Development
```bash
# Run the application in development mode
flutter run

# Hot reload (when app is running)
r

# Hot restart (when app is running)
shift+r
```

### Project Structure Patterns
- Screen widgets are placed in `lib/screens/`
- Each screen is responsible for its own UI logic
- The app uses direct navigation between screens via `Navigator.push()`
- UI components are built as private methods within screen classes (e.g., `_buildFoodCard`)

## UI Component Patterns

### Custom App Bar
Product detail uses `SliverAppBar` for collapsible header with product image:
```dart
SliverAppBar(
  expandedHeight: 300,
  pinned: true,
  backgroundColor: Colors.white,
  // ... additional configuration
)
```

### Card Components
Cards are built using container with shadow decorations:
```dart
Container(
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 8,
      ),
    ],
  ),
  // ... child content
)
```

### Navigation
Screen-to-screen navigation is handled with:
```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => ProductDetailScreen(product: productData),
  ),
);
```

## Current Project State
- Basic UI implementation for home and product detail screens
- No state management solution implemented yet (planned to use BLoC/Cubit)
- No backend integration yet
- In process of migrating to Clean Architecture

## Clean Architecture Guidelines

### Entity Creation
Create domain entities in `lib/domain/entities/`:

```dart
// lib/domain/entities/product.dart
class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String? imageUrl;
  
  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.imageUrl,
  });
}
```

### Repository Pattern
Define repository interfaces in domain layer:

```dart
// lib/domain/repositories/product_repository.dart
import '../entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts();
  Future<Product> getProductById(String id);
}
```

### Use Case Implementation
Create use cases for business logic:

```dart
// lib/domain/usecases/get_products.dart
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetProducts {
  final ProductRepository repository;
  
  GetProducts(this.repository);
  
  Future<List<Product>> call() async {
    return await repository.getProducts();
  }
}
```

### Data Flow
Data flows from outer layers to inner layers:
1. UI (Presentation) calls use cases (Domain)
2. Use cases work with repositories (Domain interfaces)
3. Repository implementations (Data) fetch from data sources
4. Data sources retrieve data from APIs or local storage

## Conventions
- Colors use the Material design system with custom gradients for highlights
- UI measurements are in logical pixels with responsive layouts
- All strings are currently hardcoded (no localization setup)
- Use dependency injection for providing repositories and use cases
- Keep domain entities free of UI or data source dependencies