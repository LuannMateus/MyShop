import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  final String error;

  const ErrorDialog({this.error});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('An error has occured.'),
      content: Text(
        error != null ? error : 'An error occurred while saving the product.'),
      actions: [
        TextButton(
          child: Text('Ok'),
          onPressed: () => Navigator.of(context).pop(),
        )
      ],
    );
  }
}
