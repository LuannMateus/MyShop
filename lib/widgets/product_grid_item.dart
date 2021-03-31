import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_project/providers/auth_provider.dart';
import 'package:shop_project/providers/cart_provider.dart';

import 'package:shop_project/providers/product.dart';
import 'package:shop_project/utils/app_routes.dart';

class ProductGridItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Product product = Provider.of(context, listen: false);
    final CartProvider cart = Provider.of(context, listen: false);
    final AuthProvider auth = Provider.of(context, listen: false);

    final scaffold = ScaffoldMessenger.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              AppRoutes.PRODUCT_DETAIL,
              arguments: product,
            );
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            builder: (ctx, product, _) => IconButton(
              icon: Icon(
                product.isFavorite ? Icons.favorite : Icons.favorite_border,
              ),
              color: Theme.of(context).accentColor,
              onPressed: () async {
                try {
                  await product.toggleFavorite(token: auth.token, userId: auth.userId);
                } catch (err) {
                  scaffold.showSnackBar(SnackBar(
                    duration: Duration(milliseconds: 500),
                    content: Text(err.toString()),
                  ));
                }
              },
            ),
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            splashColor: Theme.of(context).splashColor,
            icon: Icon(Icons.shopping_cart),
            color: Theme.of(context).accentColor,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Add Product with success!'),
                duration: Duration(milliseconds: 1000),
                action: SnackBarAction(
                  label: 'Undone',
                  onPressed: () {
                    cart.removeSingleItem(product.id);
                  },
                ),
              ));
              cart.addItem(product);
            },
          ),
        ),
      ),
    );
  }
}
