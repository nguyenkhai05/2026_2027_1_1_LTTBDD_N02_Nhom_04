import 'package:flutter/material.dart';

import 'home_book_card.dart';

class HomeBookSection extends StatelessWidget {
  final String title;
  final bool hasBooks;
  final String emptyTitle;
  final String emptyDescription;

  const HomeBookSection({
    super.key,
    required this.title,
    required this.hasBooks,
    required this.emptyTitle,
    required this.emptyDescription,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tiêu đề khu vực
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Color(0xFF252A24),
              ),
            ),

            const Text(
              'Xem tất cả',
              style: TextStyle(fontSize: 10, color: Color(0xFF526B50)),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Kiểm tra có sách hay không
        if (hasBooks)
          const HomeBookCard()
        else
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.menu_book_outlined,
                  size: 30,
                  color: Color(0xFF526B50),
                ),

                const SizedBox(height: 8),

                Text(
                  emptyTitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF252A24),
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  emptyDescription,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF777D73),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
