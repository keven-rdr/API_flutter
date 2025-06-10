import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:statement_handle/screens/main_screen_tabs/mainTabs_screen.dart';
import 'package:statement_handle/utils/app_colors.dart';
import 'package:statement_handle/viewmodels/cart_viewmodel.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CartViewModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Statement Handle',
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        primaryColor: AppColors.primary,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.background,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.background,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: Colors.grey,
        ),
      ),
      home: const MainTabsScreen(),
    );
  }
}

