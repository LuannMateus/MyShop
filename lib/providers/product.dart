import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shop_project/error/http_exception.dart';
import 'package:shop_project/utils/constants.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  Future<void> toggleFavorite({String token, String userId}) async {
    final Uri baseUrl =
        Uri.parse('${Constants.BASE_API_URL}/userFavorites/$userId/$id.json?auth=$token');

    isFavorite = !isFavorite;
    notifyListeners();

    final response = await http.put(
      baseUrl,
      body: json.encode(isFavorite),
    );

    if (response.statusCode >= 400) {
      isFavorite = !isFavorite;
      notifyListeners();
      throw HttpException(msg: 'An error occurred while favoring the product.');
    }
  }
}
