import 'package:flutter/foundation.dart';

import 'drink.dart';

/// Cách 2: giỏ hàng là một model riêng, báo thay đổi bằng notifyListeners().
class CartModel extends ChangeNotifier {
  final Map<String, int> _qty = {};

  int quantityOf(Drink d) => _qty[d.id] ?? 0;
  int get count => _qty.values.fold(0, (a, b) => a + b);
  int get total => drinks.fold(0, (sum, d) => sum + d.price * quantityOf(d));

  void add(Drink d) {
    _qty[d.id] = quantityOf(d) + 1;
    notifyListeners();
  }

  void clear() {
    _qty.clear();
    notifyListeners();
  }
}
