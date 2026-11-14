// Demo Chủ đề 11: Chia sẻ trạng thái giữa các widget — Quán trà mini.
// Bản gộp một file, nội dung giống thư mục quan_tra_mini/lib/. Dán vào DartPad hoặc lib/main.dart để chạy.
import 'package:flutter/material.dart';

// ======================================================================
// DỮ LIỆU CỐ ĐỊNH
// ======================================================================

/// Dữ liệu cố định của thực đơn, không thay đổi nên không phải trạng thái.
class Drink {
  const Drink(this.id, this.name, this.price);

  final String id;
  final String name;
  final int price;
}

const drinks = [
  Drink('ts', 'Trà sữa', 30000),
  Drink('td', 'Trà đào', 35000),
  Drink('cp', 'Cà phê', 25000),
];

/// 30000 -> "30.000đ"
String vnd(int v) => '${v.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => '.')}đ';

// ======================================================================
// CÁCH 2: MODEL GIỎ HÀNG (ChangeNotifier)
// ======================================================================

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

// ======================================================================
// CÁCH 2: ĐƯA MODEL XUỐNG CÂY (InheritedNotifier)
// ======================================================================

/// Đặt CartModel lên cây widget. Widget con ở bất kỳ độ sâu nào lấy được qua context
/// và tự build lại khi CartModel gọi notifyListeners().
class CartScope extends InheritedNotifier<CartModel> {
  const CartScope({super.key, required CartModel cart, required super.child}) : super(notifier: cart);

  static CartModel of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<CartScope>()!
          .notifier!;
}

// ======================================================================
// ỨNG DỤNG VÀ HAI TAB
// ======================================================================

void main() => runApp(const DemoApp());

class DemoApp extends StatelessWidget {
  const DemoApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Quán trà mini',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(colorSchemeSeed: Colors.teal, useMaterial3: true),
        home: const HomePage(),
      );
}

/// Hai tab cùng giao diện, khác cách đưa giỏ hàng đến các widget.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _tab = 0; // chỉ HomePage dùng nên giữ tại chỗ

  @override
  Widget build(BuildContext context) => Scaffold(
        body: IndexedStack(index: _tab, children: const [ShopPageV1(), ShopPageV2()]),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _tab,
          onDestinationSelected: (i) => setState(() => _tab = i),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.call_split), label: 'Cách 1'),
            NavigationDestination(icon: Icon(Icons.hub_outlined), label: 'Cách 2'),
          ],
        ),
      );
}

// ======================================================================
// CÁCH 1: CONSTRUCTOR VÀ CALLBACK
// ======================================================================

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

// ======================================================================
// CÁCH 2: CHIA SẺ TRẠNG THÁI
// ======================================================================

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

// ======================================================================
// GIAO DIỆN DÙNG CHUNG VÀ BỘ ĐẾM BUILD
// ======================================================================

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
