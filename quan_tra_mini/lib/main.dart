import 'package:flutter/material.dart';

import 'pages/cach1_truyen_tham_so.dart';
import 'pages/cach2_chia_se_trang_thai.dart';

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
