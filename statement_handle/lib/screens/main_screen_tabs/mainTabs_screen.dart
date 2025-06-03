import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import 'package:statement_handle/screens/main_screen/main_screen.dart';

class MainTabsScreen extends StatefulWidget {
  const MainTabsScreen({super.key});

  @override
  State<MainTabsScreen> createState() => _MainTabsScreenState();
}

class _MainTabsScreenState extends State<MainTabsScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    MainScreen(),
    Center(child: Text('Buscar')),
    Center(child: Text('Compras')),
    Center(child: Text('Perfil')),
  ];


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<BottomNavigationBarItem> _bottomItems = [
    BottomNavigationBarItem(
      icon: Icon(LucideIcons.house),
      label: 'Timeline',
    ),
    BottomNavigationBarItem(
      icon: Icon(LucideIcons.search),
      label: 'Buscar',
    ),
    BottomNavigationBarItem(
      icon: Icon(LucideIcons.shopping_bag),
      label: 'Compras',
    ),
    BottomNavigationBarItem(
      icon: Icon(LucideIcons.user),
      label: 'Perfil',
    ),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: _bottomItems,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }
}
