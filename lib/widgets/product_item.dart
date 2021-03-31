import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_project/providers/product.dart';
import 'package:shop_project/providers/products_provider.dart';
import 'package:shop_project/utils/app_routes.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  const ProductItem({this.product});

  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);

    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(
          product.imageUrl,
        ),
      ),
      title: Text(product.title),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.edit,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(
                  AppRoutes.PRODUCT_FORM,
                  arguments: product,
                );
              },
            ),
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Theme.of(context).errorColor,
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text('Remove a Product'),
                    content: Text(
                        'You want to remove the product from the products?'),
                    actions: <Widget>[
                      TextButton(
                        child: Text('No'),
                        onPressed: () => Navigator.of(context).pop(false),
                      ),
                      TextButton(
                        child: Text('Yes'),
                        onPressed: () => Navigator.of(context).pop(true),
                      ),
                    ],
                  ),
                ).then((value) async {
                  if (value) {
                    try {
                      await Provider.of<ProductsProvider>(context, listen: false)
                          .removeProduct(id: product.id);
                    } catch (err) {
                      scaffold.showSnackBar(
                        SnackBar(
                          content: Text(err.toString()),
                        ),
                      );
                    }
                  }
                });
              },
            )
          ],
        ),
      ),
    );
  }
}
