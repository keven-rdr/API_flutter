import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:statement_handle/screens/main_screen/main_screen.dart';
import 'package:statement_handle/screens/checkout/checkout_screen.dart';
import 'package:statement_handle/screens/profile/profile_screen.dart';
import 'package:statement_handle/screens/favorites/favorites_screen.dart';

class MainTabsScreen extends StatefulWidget {
  const MainTabsScreen({super.key});

  @override
  State<MainTabsScreen> createState() => _MainTabsScreenState();
}

class _MainTabsScreenState extends State<MainTabsScreen> {
  int _selectedIndex = 0;
  int _homeScreenKey = 0;

  List<Widget> _buildScreens() {
    return [
      MainScreen(key: ValueKey(_homeScreenKey)),
      const FavoritesScreen(),
      const CheckoutScreen(),
      const ProfileScreen(),
    ];
  }

  void _onItemTapped(int index) {
    if (index == 0 && _selectedIndex == index) {
      setState(() {
        _homeScreenKey++;
      });
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  final List<BottomNavigationBarItem> _bottomItems = [
    const BottomNavigationBarItem(
      icon: Icon(LucideIcons.house),
      label: 'Timeline',
    ),
    const BottomNavigationBarItem(
      icon: Icon(LucideIcons.heart),
      label: 'Favoritos',
    ),
    const BottomNavigationBarItem(
      icon: Icon(LucideIcons.shopping_bag),
      label: 'Compras',
    ),
    const BottomNavigationBarItem(
      icon: Icon(LucideIcons.user),
      label: 'Perfil',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final screens = _buildScreens();

    return Scaffold(
      body: screens[_selectedIndex],
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