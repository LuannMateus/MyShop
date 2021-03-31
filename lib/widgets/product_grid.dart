import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_project/providers/product.dart';
import 'package:shop_project/providers/products_provider.dart';
import 'package:shop_project/widgets/product_grid_item.dart';

class ProductGrid extends StatelessWidget {
  final showFavoriteOnly;

  const ProductGrid({this.showFavoriteOnly});

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);
    final List<Product> products = showFavoriteOnly
        ? productsProvider.favoriteItems
        : productsProvider.items;

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: products.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: products[i],
        child: ProductGridItem(),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
