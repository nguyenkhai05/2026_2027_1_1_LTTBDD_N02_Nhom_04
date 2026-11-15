import 'package:flutter/material.dart';
import '../l10n/app_text.dart';

import '../models/book.dart';
import '../theme/library_colors.dart';
import 'book_cover_thumbnail.dart';

class HomeBookCard extends StatelessWidget {
  const HomeBookCard({super.key, required this.book, this.onTap});

  final Book book;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final progress = book.progress;
    final statusText = switch (book.status) {
      BookStatus.wantToRead => 'Muốn đọc',
      BookStatus.reading => 'Đang đọc',
      BookStatus.completed => 'Đã đọc',
      BookStatus.paused => 'Tạm dừng',
    };

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BookCoverThumbnail(book: book, width: 48, height: 72),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: libraryInk,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      book.author,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 11, color: libraryMuted),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: libraryGreen,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: LText(
                        statusText,
                        style: const TextStyle(fontSize: 9, color: Colors.white),
                      ),
                    ),
                    if (progress != null) ...[
                      const SizedBox(height: 7),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 3,
                          backgroundColor: const Color(0xFFE3E5DF),
                          valueColor: const AlwaysStoppedAnimation(libraryGreen),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${book.currentPage} / ${book.totalPages} · ${(progress * 100).round()}%',
                        style: const TextStyle(fontSize: 9, color: libraryMuted),
                      ),
                    ],
                  ],
                ),
              ),
              if (book.isFavorite) ...[
                const SizedBox(width: 8),
                const Icon(Icons.favorite, color: libraryGreen, size: 18),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
