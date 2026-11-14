import 'package:flutter/widgets.dart';

import '../models/cart_model.dart';

/// Đặt CartModel lên cây widget. Widget con ở bất kỳ độ sâu nào lấy được qua context
/// và tự build lại khi CartModel gọi notifyListeners().
class CartScope extends InheritedNotifier<CartModel> {
  const CartScope({super.key, required CartModel cart, required super.child}) : super(notifier: cart);

  static CartModel of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<CartScope>()!
          .notifier!;
}
