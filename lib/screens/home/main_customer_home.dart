import 'package:abo_abed_clothing/screens/auth/profile_screen.dart';
import 'package:abo_abed_clothing/screens/cart/cart_screen.dart';
import 'package:flutter/material.dart';
import '../place_holder.dart';
import 'home_screen.dart';

class MainCustomerHome extends StatefulWidget {
  const MainCustomerHome({super.key});

  @override
  State<MainCustomerHome> createState() => _MainCustomerHomeState();
}

class _MainCustomerHomeState extends State<MainCustomerHome> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(), // Home
    const None(), // Search
    const CartScreen(), // Cart
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
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'الرئيسية',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search_outlined),
              label: 'البحث',
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined),
              label: 'السلة',
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
