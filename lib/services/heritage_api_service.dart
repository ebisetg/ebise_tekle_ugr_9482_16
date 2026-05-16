import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants/api_constants.dart';
import '../core/exceptions/api_exception.dart';
import '../models/heritage_item.dart';

class HeritageApiService {
  Future<List<HeritageItem>> fetchItems() async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.itemsEndpoint}'),
      headers: ApiConstants.headers,
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => HeritageItem.fromJson(json)).toList();
    } else {
      throw ApiException('Failed to load items', statusCode: response.statusCode);
    }
  }

  Future<HeritageItem> createItem(HeritageItem item) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.itemsEndpoint}'),
      headers: ApiConstants.headers,
      body: jsonEncode(item.toJson()),
    );
    if (response.statusCode == 201) {
      return HeritageItem.fromJson(jsonDecode(response.body));
    } else {
      throw ApiException('Failed to create item', statusCode: response.statusCode);
    }
  }

  Future<HeritageItem> updateItem(String id, HeritageItem item) async {
    final response = await http.put(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.itemsEndpoint}/$id'),
      headers: ApiConstants.headers,
      body: jsonEncode(item.toJson()),
    );
    if (response.statusCode == 200) {
      return HeritageItem.fromJson(jsonDecode(response.body));
    } else {
      throw ApiException('Failed to update item', statusCode: response.statusCode);
    }
  }

  Future<void> deleteItem(String id) async {
    final response = await http.delete(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.itemsEndpoint}/$id'),
      headers: ApiConstants.headers,
    );
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw ApiException('Failed to delete item', statusCode: response.statusCode);
    }
  }
}