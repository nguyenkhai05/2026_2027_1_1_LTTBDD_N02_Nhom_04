import 'package:flutter/material.dart';

import 'screens/app_shell.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MyShelf',

      theme: ThemeData(
        useMaterial3: true,

        scaffoldBackgroundColor: const Color(0xFFF7F6F0),

        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF526B50)),
      ),

      home: const AppShell(),
    );
  }
}
