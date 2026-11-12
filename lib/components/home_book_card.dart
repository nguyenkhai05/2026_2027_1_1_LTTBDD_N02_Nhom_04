import 'package:flutter/material.dart';

class HomeBookCard extends StatelessWidget {
  const HomeBookCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ảnh bìa sách
          Container(
            width: 48,
            height: 72,
            decoration: BoxDecoration(
              color: const Color(0xFFC9A45B),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Center(
              child: Icon(Icons.menu_book, color: Colors.white, size: 24),
            ),
          ),

          const SizedBox(width: 10),

          // Thông tin sách
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Nhà Giả Kim',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF252A24),
                  ),
                ),

                const SizedBox(height: 4),

                const Text(
                  'Paulo Coelho',
                  style: TextStyle(fontSize: 11, color: Color(0xFF777D73)),
                ),

                const SizedBox(height: 6),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF526B50),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Đang đọc',
                    style: TextStyle(fontSize: 9, color: Colors.white),
                  ),
                ),

                const SizedBox(height: 7),

                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: const LinearProgressIndicator(
                    value: 0.6,
                    minHeight: 3,
                    backgroundColor: Color(0xFFE3E5DF),
                    valueColor: AlwaysStoppedAnimation(Color(0xFF526B50)),
                  ),
                ),

                const SizedBox(height: 4),

                const Text(
                  '120 / 200 - 60%',
                  style: TextStyle(fontSize: 9, color: Color(0xFF777D73)),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // Nút yêu thích
          const Icon(Icons.favorite, color: Color(0xFF526B50), size: 18),
        ],
      ),
    );
  }
}
