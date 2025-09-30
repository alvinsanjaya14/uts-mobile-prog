# uts_mobile_restoran

Restaurant ordering sample app demonstrating a lightweight MVC architecture plus declarative navigation using `go_router`.

## Tech Stack
| Concern | Choice |
|---------|--------|
| UI | Flutter (Material 3) |
| Architecture | MVC (Models / Views / Controllers / Services) |
| State mgmt | `ChangeNotifier` (simple controller pattern) + `Provider` DI |
| Routing | `go_router` |
| Equality helpers | `equatable` |

## Project Structure (MVC)
```
lib/
	main.dart              # App bootstrap (providers + GoRouter wiring)
	routes.dart            # Central GoRouter configuration
	models/                # Data structures / domain entities
		product.dart
	controllers/           # ChangeNotifiers coordinating services & views
		product_controller.dart
	services/              # External/data access (API, DB, mock)
		product_service.dart
	views/                 # UI widgets (Stateless/Stateful) - one screen per file
		home_view.dart
		product_detail_view.dart
```

### MVC Roles
* Model (`models/product.dart`): Pure data, serialization helpers, immutable, no Flutter imports (except equality helpers).
* View (`views/*.dart`): Stateless/Stateful Widgets building UI. No business logic beyond simple formatting & user interaction relay.
* Controller (`controllers/product_controller.dart`): Holds UI state, calls services, exposes reactive fields (`notifyListeners()`).
* Service (`services/product_service.dart`): Data source abstraction (currently mock). Replace with real API client later.

## Routing with `go_router`
Central config lives in `lib/routes.dart`:
```dart
final GoRouter appRouter = GoRouter(
	routes: [
		GoRoute(path: '/', name: 'home', builder: (_, __) => const HomeView()),
		GoRoute(
			path: '/product/:id',
			name: 'product-detail',
			builder: (ctx, state) {
				final extra = state.extra;
				if (extra is Product) return ProductDetailView(product: extra);
				return const Scaffold(body: Center(child: Text('Missing product data.')));
			},
		),
	],
);
```

In `main.dart` we wire it using `MaterialApp.router`:
```dart
MaterialApp.router(
	routerConfig: appRouter,
	theme: ThemeData(
		colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0AA67B)),
	),
);
```

### Navigating Between Screens
From a view (e.g., `home_view.dart`) to product detail:
```dart
final id = product.id.isNotEmpty ? product.id : product.name.hashCode.toString();
context.push('/product/$id', extra: product);
```
Passing the entire `Product` via `extra` avoids re-fetching until a backend/service layer is ready for on-demand detail requests.

### Adding a New Route
1. Create the new view: `lib/views/some_feature_view.dart`.
2. (Optional) Add model/service/controller pieces if needed.
3. Register route in `routes.dart`:
```dart
GoRoute(
	path: '/some-feature',
	name: 'some-feature',
	builder: (_, __) => const SomeFeatureView(),
),
```
4. Navigate with: `context.push('/some-feature');` or `context.go('/some-feature');` (use `go` for stack replacement, `push` to keep history).

### When to Add a Controller
Add a controller if:
* View needs async loading or mutation.
* Same data feeds multiple widgets.
* You anticipate caching or pagination.

Keep controllers lean: fetch, hold state, transform minimal UI-ready values. Offload heavy parsing or mapping to services/helpers.

## Extending the Data Layer
Current `ProductService` returns a hardcoded list. To integrate an API:
```dart
class ApiProductService extends ProductService {
	final http.Client _client;
	ApiProductService(this._client);
	@override
	Future<List<Product>> fetchProducts() async {
		final resp = await _client.get(Uri.parse('https://example.com/products'));
		final data = jsonDecode(resp.body) as List;
		return data.map((m) => Product.fromMap(m)).toList();
	}
}
```
Swap in `main.dart` provider creation.

## Adding State Fields Safely
1. Add fields to `Product` (ensure immutability & update `fromMap`).
2. Re-run any mock service to include the new key.
3. Expose computed/UI-friendly getters in controller if transformation needed.

## Testing Suggestions (Not yet included)
| Layer | Suggested Test |
|-------|----------------|
| Service | Mock HTTP and assert parsing |
| Controller | Load success & error paths |
| View | Golden / widget smoke test for `HomeView` |

## Running
```bash
flutter pub get
flutter run
```
Hot reload for quick UI tweaks; controllers retain state across reloads.

## Roadmap Ideas
* Shell route for bottom navigation (persistent nav across tabs)
* Extract constants (spacing, colors) into a design system file
* Introduce repository abstraction if multiple data sources appear
* Add deep link support & web URL strategy
* Unit + widget tests

---
Original Flutter starter instructions below (kept for reference):

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
