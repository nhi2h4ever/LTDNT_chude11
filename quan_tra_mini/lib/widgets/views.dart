import 'package:flutter/material.dart';

import '../models/drink.dart';

// Bộ đếm số lần build: mỗi widget gọi countBuild ở đầu build() và hiện "build #n".
final Map<String, int> _builds = {};

int countBuild(String name) => _builds[name] = (_builds[name] ?? 0) + 1;

int buildCountOf(String name) => _builds[name] ?? 0;

class BuildLabel extends StatelessWidget {
  const BuildLabel(this.n, {super.key});

  final int n;

  @override
  Widget build(BuildContext context) =>
      Text('build #$n', style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.outline));
}

// Các khối giao diện dùng chung cho hai cách, chỉ nhận dữ liệu qua constructor.
class PageTitle extends StatelessWidget {
  const PageTitle(this.title, this.n, {super.key});

  final String title;
  final int n;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [Text(title, style: const TextStyle(fontSize: 18)), BuildLabel(n)],
      );
}

class MenuHeader extends StatelessWidget {
  const MenuHeader(this.n, {super.key});

  final int n;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
        child: Row(children: [
          Text('Thực đơn', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(width: 8),
          BuildLabel(n),
        ]),
      );
}

class DrinkRow extends StatelessWidget {
  const DrinkRow({super.key, required this.drink, required this.quantity, required this.n, required this.onAdd});

  final Drink drink;
  final int quantity;
  final int n;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) => ListTile(
        title: Text(drink.name),
        subtitle: Text('${vnd(drink.price)}  ·  build #$n'),
        trailing: Row(mainAxisSize: MainAxisSize.min, children: [
          Text('$quantity', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          IconButton(tooltip: 'Thêm', icon: const Icon(Icons.add_circle_outline), onPressed: onAdd),
        ]),
      );
}

class CartIcon extends StatelessWidget {
  const CartIcon({super.key, required this.count, required this.n});

  final int count;
  final int n;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(right: 16),
        child: Row(children: [
          Badge(isLabelVisible: count > 0, label: Text('$count'), child: const Icon(Icons.shopping_bag_outlined)),
          const SizedBox(width: 6),
          BuildLabel(n),
        ]),
      );
}

class TotalBarView extends StatelessWidget {
  const TotalBarView({super.key, required this.count, required this.total, required this.n, this.onClear});

  final int count;
  final int total;
  final int n;
  final VoidCallback? onClear; // null khi giỏ trống: nút tự mờ

  @override
  Widget build(BuildContext context) => Material(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
          child: Row(children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                Text('$count ly · ${vnd(total)}', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                BuildLabel(n),
              ]),
            ),
            FilledButton.tonal(onPressed: onClear, child: const Text('Xóa giỏ')),
          ]),
        ),
      );
}
