import 'package:flutter/material.dart';

class SnackBarWidget {
  snackbar(BuildContext context, Color cor, String texto) {
    return SnackBar(
        duration: const Duration(seconds: 4),
        backgroundColor: cor,
        content: Center(child: Text(texto)));
  }
}
