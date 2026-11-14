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
