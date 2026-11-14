import 'package:flutter/material.dart';

import '../models/drink.dart';
import '../widgets/views.dart';

/// Cách 1: giỏ hàng nằm trong State của ShopPageV1.
/// Dữ liệu truyền xuống qua constructor, sự kiện báo lên qua callback.
class ShopPageV1 extends StatefulWidget {
  const ShopPageV1({super.key});

  @override
  State<ShopPageV1> createState() => _ShopPageV1State();
}

class _ShopPageV1State extends State<ShopPageV1> {
  final Map<String, int> _qty = {};

  int get _count => _qty.values.fold(0, (a, b) => a + b);
  int get _total => drinks.fold(0, (sum, d) => sum + d.price * (_qty[d.id] ?? 0));

  void _add(Drink d) => setState(() {
        _qty[d.id] = (_qty[d.id] ?? 0) + 1;
      });

  void _clear() => setState(_qty.clear);

  @override
  Widget build(BuildContext context) {
    final n = countBuild('V1.ShopPage');
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: PageTitle('Cách 1: Truyền tham số', n),
        actions: [CartBadgeV1(count: _count)],
      ),
      body: MenuListV1(qty: _qty, onAdd: _add),
      bottomNavigationBar: TotalBarV1(count: _count, total: _total, onClear: _clear),
    );
  }
}

/// Không dùng qty và onAdd, chỉ nhận rồi chuyển tiếp xuống DrinkTileV1.
class MenuListV1 extends StatelessWidget {
  const MenuListV1({super.key, required this.qty, required this.onAdd});

  final Map<String, int> qty;
  final ValueChanged<Drink> onAdd;

  @override
  Widget build(BuildContext context) {
    final n = countBuild('V1.MenuList');
    return ListView(children: [
      MenuHeader(n),
      for (final d in drinks)
        DrinkTileV1(
          drink: d,
          quantity: qty[d.id] ?? 0,
          onAdd: () => onAdd(d),
        ),
    ]);
  }
}

class DrinkTileV1 extends StatelessWidget {
  const DrinkTileV1({super.key, required this.drink, required this.quantity, required this.onAdd});

  final Drink drink;
  final int quantity;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final n = countBuild('V1.Tile.${drink.id}');
    return DrinkRow(drink: drink, quantity: quantity, n: n, onAdd: onAdd);
  }
}

class CartBadgeV1 extends StatelessWidget {
  const CartBadgeV1({super.key, required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final n = countBuild('V1.CartBadge');
    return CartIcon(count: count, n: n);
  }
}

class TotalBarV1 extends StatelessWidget {
  const TotalBarV1({super.key, required this.count, required this.total, required this.onClear});

  final int count;
  final int total;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final n = countBuild('V1.TotalBar');
    return TotalBarView(count: count, total: total, n: n, onClear: count == 0 ? null : onClear);
  }
}
