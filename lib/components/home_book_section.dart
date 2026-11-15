import 'package:flutter/material.dart';
import '../l10n/app_text.dart';

import '../models/book.dart';
import '../theme/library_colors.dart';
import 'home_book_card.dart';

class HomeBookSection extends StatelessWidget {
  const HomeBookSection({
    super.key,
    required this.title,
    required this.books,
    required this.emptyTitle,
    required this.emptyDescription,
    required this.onViewAll,
    this.onAddBook,
    this.onBookTap,
  });

  final String title;
  final List<Book> books;
  final String emptyTitle;
  final String emptyDescription;
  final VoidCallback onViewAll;
  final VoidCallback? onAddBook;
  final ValueChanged<Book>? onBookTap;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          LText(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: libraryInk,
            ),
          ),
          TextButton(onPressed: onViewAll, child: const LText('Xem tất cả')),
        ],
      ),
      const SizedBox(height: 12),
      if (books.isNotEmpty)
        for (final book in books) ...[
          HomeBookCard(book: book, onTap: onBookTap == null ? onViewAll : () => onBookTap!(book)),
          const SizedBox(height: 10),
        ]
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
              const Icon(Icons.menu_book_outlined, size: 30, color: libraryGreen),
              const SizedBox(height: 8),
              LText(
                emptyTitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: libraryInk,
                ),
              ),
              const SizedBox(height: 5),
              LText(
                emptyDescription,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 11, color: libraryMuted),
              ),
              if (onAddBook != null) ...[
                const SizedBox(height: 12),
                FilledButton(onPressed: onAddBook, child: const LText('Thêm sách đầu tiên')),
              ],
            ],
          ),
        ),
    ],
  );
}
