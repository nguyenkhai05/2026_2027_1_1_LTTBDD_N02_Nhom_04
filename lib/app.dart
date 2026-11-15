import 'package:flutter/material.dart';

import 'data/app_language_store.dart';
import 'data/book_database.dart';
import 'data/book_repository.dart';
import 'l10n/app_text.dart';
import 'models/app_language.dart';
import 'screens/app_shell.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key, this.repository, this.languageStore});

  final BookStore? repository;
  final AppLanguageStore? languageStore;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final BookDatabase? _database =
      widget.repository == null || widget.languageStore == null ? BookDatabase() : null;
  late final BookStore _books = widget.repository ?? BookRepository(_database!);
  late final AppLanguageStore _settings =
      widget.languageStore ?? SqliteAppLanguageStore(_database!);
  AppLanguage _language = AppLanguage.vietnamese;

  @override
  void initState() {
    super.initState();
    _restoreLanguage();
  }

  Future<void> _restoreLanguage() async {
    try {
      final saved = await _settings.load();
      if (mounted) setState(() { _language = saved; });
    } catch (_) {
      // The app remains usable in Vietnamese if preferences cannot be read.
    }
  }

  Future<bool> _saveLanguage(AppLanguage language) async {
    try {
      await _settings.save(language);
      if (!mounted) return false;
      setState(() { _language = language; });
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  void dispose() {
    _database?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AppLanguageScope(
    language: _language,
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MyShelf',

      theme: ThemeData(
        useMaterial3: true,

        scaffoldBackgroundColor: const Color(0xFFF7F6F0),

        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF526B50)),
      ),

      home: AppShell(
        repository: _books,
        language: _language,
        onLanguageChanged: _saveLanguage,
      ),
    ),
  );
}
