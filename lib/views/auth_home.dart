import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_project/providers/auth_provider.dart';
import 'package:shop_project/views/auth_screen.dart';
import 'package:shop_project/views/products_overview_screen.dart';

class AuthOrHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    AuthProvider auth = Provider.of(context);

    return FutureBuilder(
      future: auth.tryAutoLogin(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.error != null) {
          return Center(child: Text('An error occured'));
        } else {
          return auth.isAuth ? ProductOverViewScreen() : AuthScreen();
        }
      }
    );
  }
}
