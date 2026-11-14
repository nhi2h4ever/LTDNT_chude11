import 'package:flutter/material.dart';

import '../models/cart_model.dart';
import '../models/drink.dart';
import '../state/cart_scope.dart';
import '../widgets/views.dart';

/// Cách 2: CartModel đặt lên cây bằng CartScope.
/// Widget nào cần giỏ hàng thì tự lấy qua CartScope.of(context).
class ShopPageV2 extends StatefulWidget {
  const ShopPageV2({super.key});

  @override
  State<ShopPageV2> createState() => _ShopPageV2State();
}

class _ShopPageV2State extends State<ShopPageV2> {
  final _cart = CartModel();

  @override
  void dispose() {
    _cart.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final n = countBuild('V2.ShopPage');
    return CartScope(
      cart: _cart,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: PageTitle('Cách 2: Chia sẻ trạng thái', n),
          actions: const [CartBadgeV2()],
        ),
        body: const MenuListV2(),
        bottomNavigationBar: const TotalBarV2(),
      ),
    );
  }
}

/// Không còn tham số giỏ hàng.
class MenuListV2 extends StatelessWidget {
  const MenuListV2({super.key});

  @override
  Widget build(BuildContext context) {
    final n = countBuild('V2.MenuList');
    return ListView(children: [
      MenuHeader(n),
      for (final d in drinks) DrinkTileV2(drink: d),
    ]);
  }
}

class DrinkTileV2 extends StatelessWidget {
  const DrinkTileV2({super.key, required this.drink});

  final Drink drink;

  @override
  Widget build(BuildContext context) {
    final n = countBuild('V2.Tile.${drink.id}');
    final cart = CartScope.of(context);
    return DrinkRow(
      drink: drink,
      quantity: cart.quantityOf(drink),
      onAdd: () => cart.add(drink),
      n: n,
    );
  }
}

class CartBadgeV2 extends StatelessWidget {
  const CartBadgeV2({super.key});

  @override
  Widget build(BuildContext context) {
    final n = countBuild('V2.CartBadge');
    return CartIcon(count: CartScope.of(context).count, n: n);
  }
}

class TotalBarV2 extends StatelessWidget {
  const TotalBarV2({super.key});

  @override
  Widget build(BuildContext context) {
    final n = countBuild('V2.TotalBar');
    final cart = CartScope.of(context);
    return TotalBarView(count: cart.count, total: cart.total, n: n, onClear: cart.count == 0 ? null : cart.clear);
  }
}
