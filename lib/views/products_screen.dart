import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_project/providers/product.dart';
import 'package:shop_project/providers/products_provider.dart';
import 'package:shop_project/utils/app_routes.dart';
import 'package:shop_project/widgets/app_drawer.dart';
import 'package:shop_project/widgets/product_item.dart';

class ProductsScreen extends StatelessWidget {
  Future<void> _onrRefreshProducts(BuildContext context) async {
    await Provider.of<ProductsProvider>(context, listen: false).loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);
    final List<Product> products = productsData.items;

    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.PRODUCT_FORM);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _onrRefreshProducts(context),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListView.builder(
            itemCount: productsData.itemsCount,
            itemBuilder: (ctx, i) => Column(
              children: [
                ProductItem(
                  product: products[i],
                ),
                Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
