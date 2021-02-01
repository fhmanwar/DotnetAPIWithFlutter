// The [dart:async] is neccessary for using streams
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:projectStore/src/models/productModel.dart';

class CartBloc with ChangeNotifier {
  List<Product> _prod = [];

  List<Product> get prod => _prod;

  set prod(List<Product> value) => _prod = value;

  addCart(Product data) {
    bool isNew = true;
    _prod.forEach((Product f) {
      if (f.id == data.id) {
        isNew = false;
        return;
      }
    });
    if (isNew) _prod.add(data);
    notifyListeners();
  }

  removeCart(data) {
    _prod.remove(data);
    notifyListeners();
  }

  double getTotalPrice() {
    double total = 0;
    if (_prod != null) {
      _prod.forEach((f) {
        total += f.price;
      });
    }
    return total;
  }
}
