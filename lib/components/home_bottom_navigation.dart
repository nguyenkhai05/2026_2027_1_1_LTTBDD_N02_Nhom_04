import 'package:flutter/material.dart';
import '../l10n/app_text.dart';

class HomeBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const HomeBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,

      backgroundColor: Colors.white,
      selectedItemColor: const Color(0xFF526B50),
      unselectedItemColor: const Color(0xFF777D73),

      selectedFontSize: 10,
      unselectedFontSize: 10,
      iconSize: 20,
      elevation: 0,

      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.home_outlined),
          activeIcon: const Icon(Icons.home),
          label: tr(context, 'Trang chủ'),
        ),

        BottomNavigationBarItem(
          icon: const Icon(Icons.menu_book_outlined),
          activeIcon: const Icon(Icons.menu_book),
          label: tr(context, 'Thư viện'),
        ),

        BottomNavigationBarItem(
          icon: const Icon(Icons.bar_chart_outlined),
          activeIcon: const Icon(Icons.bar_chart),
          label: tr(context, 'Thống kê'),
        ),

        BottomNavigationBarItem(
          icon: const Icon(Icons.settings_outlined),
          activeIcon: const Icon(Icons.settings),
          label: tr(context, 'Cài đặt'),
        ),
      ],
    );
  }
}
