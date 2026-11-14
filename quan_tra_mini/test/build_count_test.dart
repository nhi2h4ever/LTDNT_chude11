import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quan_tra_mini/main.dart';
import 'package:quan_tra_mini/widgets/views.dart';

const parts = ['ShopPage', 'MenuList', 'Tile.ts', 'Tile.td', 'Tile.cp', 'CartBadge', 'TotalBar'];

Map<String, int> snap(String v) => {for (final p in parts) p: buildCountOf('$v.$p')};

List<String> rebuilt(Map<String, int> before, Map<String, int> after) =>
    [for (final p in parts) if (after[p]! > before[p]!) p];

void main() {
  testWidgets('số widget build lại sau mỗi thao tác', (tester) async {
    await tester.binding.setSurfaceSize(const Size(420, 700));
    await tester.pumpWidget(const DemoApp());
    await tester.pumpAndSettle();

    var b = snap('V1');
    await tester.tap(find.byIcon(Icons.add_circle_outline).first);
    await tester.pumpAndSettle();
    final c1 = rebuilt(b, snap('V1'));
    expect(c1.length, 7);

    await tester.tap(find.text('Cách 2'));
    await tester.pumpAndSettle();
    b = snap('V2');
    await tester.tap(find.byIcon(Icons.add_circle_outline).first);
    await tester.pumpAndSettle();
    final c2 = rebuilt(b, snap('V2'));
    expect(c2, ['Tile.ts', 'Tile.td', 'Tile.cp', 'CartBadge', 'TotalBar']);

    b = snap('V2');
    await tester.tap(find.text('Xóa giỏ'));
    await tester.pumpAndSettle();
    final c3 = rebuilt(b, snap('V2'));
    expect(c3.length, 5);
    expect(find.text('0 ly · 0đ'), findsOneWidget);
    // ignore: avoid_print
    print('Cách 1 bấm +: $c1\nCách 2 bấm +: $c2\nCách 2 Xóa giỏ: $c3');
  });
}
