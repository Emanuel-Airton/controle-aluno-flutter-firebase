import 'package:flutter/material.dart';

class DropDownState extends ChangeNotifier {
  List<String> list = [
    "Últimos 7 dias",
    "Últimos 15 dias",
    "Últimos 30 dias",
    "todo periodo"
  ];
  String _selectedItem = "Últimos 7 dias";
  String get selectItem => _selectedItem;

  void updateSelectedItem(String value) {
    _selectedItem = value;
    notifyListeners();
  }
}
