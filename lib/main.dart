import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'package:shop_project/providers/auth_provider.dart';
import 'package:shop_project/providers/cart_provider.dart';
import 'package:shop_project/providers/orders_provider.dart';
import 'package:shop_project/providers/products_provider.dart';

import 'package:shop_project/utils/app_routes.dart';

import 'package:shop_project/views/auth_home.dart';
import 'package:shop_project/views/cart_screen.dart';
import 'package:shop_project/views/orders_screen.dart';
import 'package:shop_project/views/product_detail_screen.dart';
import 'package:shop_project/views/product_form_screen.dart';
import 'package:shop_project/views/products_screen.dart';

void main() async {

  await DotEnv().load('.env');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => new AuthProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, ProductsProvider>(
          create: (ctx) => new ProductsProvider(),
          update: (ctx, auth, previousProducts) => new ProductsProvider(
            auth.token,
            auth.userId,
            previousProducts.items,
          ),
        ),
        ChangeNotifierProvider(
          create: (ctx) => new CartProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, OrdersProvider>(
          create: (ctx) => new OrdersProvider(),
          update: (ctx, auth, previousOrders) => new OrdersProvider(
            auth.token,
            auth.userId,
            previousOrders.items,
          ),
        ),
      ],
      child: MaterialApp(
        title: 'My Shop',
        theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
            splashColor: Colors.black45),
        routes: {
          AppRoutes.AUTH_HOME: (ctx) => AuthOrHomeScreen(),
          AppRoutes.PRODUCT_DETAIL: (ctx) => ProductDetailScreen(),
          AppRoutes.CART: (ctx) => CartScreen(),
          AppRoutes.ORDERS: (ctx) => OrdersScreen(),
          AppRoutes.PRODUCTS: (ctx) => ProductsScreen(),
          AppRoutes.PRODUCT_FORM: (ctx) => ProductFormScreen(),
        },
      ),
    );
  }
}
