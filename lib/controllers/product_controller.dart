import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../services/product_service.dart';

class ProductController extends ChangeNotifier {
  final ProductService _service;
  ProductController(this._service);

  List<Product> _products = [];
  List<Product> _savedProducts = [];
  bool _loading = false;
  bool _savedLoading = false;
  String? _error;
  String? _savedError;

  List<Product> get products => _products;
  List<Product> get savedProducts => _savedProducts;
  bool get isLoading => _loading;
  bool get isSavedLoading => _savedLoading;
  String? get error => _error;
  String? get savedError => _savedError;

  Future<void> loadProducts() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _products = await _service.fetchProducts();
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> loadSavedProducts() async {
    _savedLoading = true;
    _savedError = null;
    notifyListeners();
    try {
      _savedProducts = await _service.fetchSavedProducts();
    } catch (e) {
      _savedError = e.toString();
    } finally {
      _savedLoading = false;
      notifyListeners();
    }
  }
}
