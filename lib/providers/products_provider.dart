import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import 'package:shop_project/error/http_exception.dart';
import 'package:shop_project/providers/product.dart';
import 'package:shop_project/utils/constants.dart';

class ProductsProvider with ChangeNotifier {
  final Uri baseUrl = Uri.parse('${Constants.BASE_API_URL}/products');
  List<Product> _items = [];
  String _token;
  String _userId;

  ProductsProvider([this._token, this._userId, this._items = const []]);

  List<Product> get items => [..._items];

  List<Product> get favoriteItems {
    return _items.where((product) => product.isFavorite).toList();
  }

  int get itemsCount {
    return _items.length;
  }

  Future<void> loadProducts() async {
    final response = await http.get(Uri.parse('$baseUrl.json?auth=$_token'));
  
    Map<String, dynamic> data = await json.decode(response.body);

    final favResponse = await http.get(Uri.parse('${Constants.BASE_API_URL}/userFavorites/$_userId.json?auth=$_token'));
    final favMap = json.decode(favResponse.body);



    _items.clear();

    if (data != null) {
      data.forEach((productId, product) {

        final isFavorite = favMap == null ? false : favMap[productId] ?? false;
        _items.add(
          Product(
            id: productId,
            title: product['title'],
            description: product['description'],
            price: product['price'],
            imageUrl: product['imageUrl'],
            isFavorite: isFavorite,
          ),
        );
      });

      notifyListeners();
    }

    return Future.value();
  }

  Future<void> addProduct(Product newProduct) async {
    final res = await http.post(
      Uri.parse('$baseUrl.json?auth=$_token'),
      body: json.encode(
        {
          'title': newProduct.title,
          'description': newProduct.description,
          'price': newProduct.price,
          'imageUrl': newProduct.imageUrl,
        },
      ),
    );

    _items.add(
      Product(
        id: json.decode(res.body)['name'],
        title: newProduct.title,
        description: newProduct.description,
        price: newProduct.price,
        imageUrl: newProduct.imageUrl,
      ),
    );

    notifyListeners();
  }

  Future<void> updateProduct(Product product) async {
    if (product == null && product.id == null) return;

    final index = _items.indexWhere((prod) => prod.id == product.id);

    if (index >= 0) {
      await http.put(Uri.parse('$baseUrl/${product.id}.json?auth=$_token'),
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
          }));

      _items[index] = product;
      notifyListeners();
    }
  }

  Future<void> removeProduct({@required String id}) async {
    final index = _items.indexWhere((product) => product.id == id);

    if (index >= 0) {
      final product = _items[index];
      _items.remove(product);

      notifyListeners();

      final response = await http.delete(Uri.parse('$baseUrl/$id.json?auth=$_token'));

      if (response.statusCode >= 400) {
        _items.insert(index, product);
        notifyListeners();
        throw HttpException(msg: 'There was an error deleting the product.');
      }
    }
  }
}
