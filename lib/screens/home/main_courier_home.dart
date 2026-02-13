import 'package:abo_abed_clothing/screens/auth/profile_screen.dart';
import 'package:flutter/material.dart';
import '../place_holder.dart';

class MainCourierHome extends StatefulWidget {
  const MainCourierHome({super.key});

  @override
  State<MainCourierHome> createState() => _MainCourierHomeState();
}

class _MainCourierHomeState extends State<MainCourierHome> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const None(), // Deliveries
    const None(), // History
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
              icon: Icon(Icons.local_shipping_outlined),
              label: 'التوصيلات',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history_outlined),
              label: 'السجل',
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
