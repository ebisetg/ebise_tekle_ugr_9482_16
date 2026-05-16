import 'package:flutter/foundation.dart';
import '../models/heritage_item.dart';
import '../services/heritage_api_service.dart';

class HeritageProvider extends ChangeNotifier {
  final HeritageApiService _apiService = HeritageApiService();

  List<HeritageItem> _items = [];
  List<HeritageItem> get items => _items;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<void> loadItems() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _items = await _apiService.fetchItems();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addItem(HeritageItem item) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final newItem = await _apiService.createItem(item);
      _items.add(newItem);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateItem(String id, HeritageItem updatedItem) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _apiService.updateItem(id, updatedItem);
      final index = _items.indexWhere((item) => item.id == id);
      if (index != -1) {
        _items[index] = result;
      }
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteItem(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _apiService.deleteItem(id);
      _items.removeWhere((item) => item.id == id);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  HeritageItem? getItemById(String id) {
    try {
      return _items.firstWhere((item) => item.id == id);
    } catch (_) {
      return null;
    }
  }
}