import 'package:abo_abed_clothing/screens/admin/admin_orders_screen.dart';
import 'package:abo_abed_clothing/screens/admin/admin_products_screen.dart';
import 'package:abo_abed_clothing/screens/auth/profile_screen.dart';
import 'package:flutter/material.dart';

class MainAdminHome extends StatefulWidget {
  const MainAdminHome({super.key});

  @override
  State<MainAdminHome> createState() => _MainAdminHomeState();
}

class _MainAdminHomeState extends State<MainAdminHome> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    // const None(), // DAshboard
    const AdminOrdersScreen(), // Orders
    const AdminProductsScreen(), // Products
    const ProfileScreen(), // Profile
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        body: _screens[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const <BottomNavigationBarItem>[
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.dashboard_outlined),
            //   label: 'لوحة التحكم',
            // ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_outlined),
              label: 'الطلبات',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.inventory_2_outlined),
              label: 'المنتجات',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_2_outlined),
              label: 'الملف الشخصي',
            ),
          ],
        ),
      ),
    );
  }
}
