import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'M Y S H E L F',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Color(0xFF526B50),
            letterSpacing: 2,
          ),
        ),

        const SizedBox(height: 12),

        const Text(
          'Xin chào!',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF252A24),
          ),
        ),

        const SizedBox(height: 4),

        const Text(
          'Hôm nay bạn muốn đọc gì?',
          style: TextStyle(fontSize: 14, color: Color(0xFF777D73)),
        ),
      ],
    );
  }
}
