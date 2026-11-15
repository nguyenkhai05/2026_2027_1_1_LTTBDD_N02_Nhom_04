import 'package:flutter/material.dart';
import '../l10n/app_text.dart';

import '../theme/library_colors.dart';

/// The neutral cover used until a book has its own cover image.
class BookCoverPlaceholder extends StatelessWidget {
  const BookCoverPlaceholder({super.key});

  @override
  Widget build(BuildContext context) => Container(
    width: 80,
    height: 120,
    decoration: BoxDecoration(
      color: const Color(0xFFE8EFE6),
      borderRadius: BorderRadius.circular(4),
    ),
    child: const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.menu_book_outlined, color: libraryGreen, size: 26),
        SizedBox(height: 8),
        LText('Chưa có bìa', style: TextStyle(fontSize: 9, color: libraryMuted)),
      ],
    ),
  );
}
