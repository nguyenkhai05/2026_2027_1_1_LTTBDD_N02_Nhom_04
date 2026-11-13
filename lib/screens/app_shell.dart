import 'package:flutter/material.dart';

import '../data/book_database.dart';
import '../data/book_repository.dart';
import 'home_screen.dart';
import 'library_screen.dart';

/// Shares one local repository between the available tabs.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  final BookDatabase _database = BookDatabase();
  late final BookRepository _books = BookRepository(_database);
  int _tab = 0;

  void _selectTab(int index) {
    // Statistics and Settings get their own screens in later issues.
    if (index > 1 || index == _tab) return;
    setState(() => _tab = index);
  }

  @override
  void dispose() {
    _database.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _tab == 1
      ? LibraryScreen(repository: _books, onTabSelected: _selectTab)
      : HomeScreen(onTabSelected: _selectTab);
}
