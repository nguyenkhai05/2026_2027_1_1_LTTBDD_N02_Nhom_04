import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/book.dart';
import '../theme/library_colors.dart';

class LibraryBookCard extends StatelessWidget {
  const LibraryBookCard({
    super.key,
    required this.book,
    required this.onFavorite,
  });

  final Book book;
  final VoidCallback? onFavorite;

  @override
  Widget build(BuildContext context) {
    final progress = book.progress;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cover(),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  book.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: libraryInk,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  book.author,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, color: libraryMuted),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _statusBadge(),
                    const Spacer(),
                    IconButton(
                      onPressed: onFavorite,
                      tooltip: book.isFavorite
                          ? 'Bỏ khỏi yêu thích'
                          : 'Thêm vào yêu thích',
                      visualDensity: VisualDensity.compact,
                      icon: Icon(
                        book.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: libraryGreen,
                      ),
                    ),
                  ],
                ),
                if (progress != null) ...[
                  const SizedBox(height: 3),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 4,
                      backgroundColor: const Color(0xFFE5E7DF),
                      valueColor: const AlwaysStoppedAnimation(libraryGreen),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${book.currentPage} / ${book.totalPages} · ${(progress * 100).round()}%',
                    style: const TextStyle(fontSize: 11, color: libraryMuted),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _cover() {
    final coverPath = book.coverPath;
    final fallback = Container(
      width: 78,
      height: 116,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: switch (book.status) {
          BookStatus.reading => const Color(0xFFC69B52),
          BookStatus.completed => const Color(0xFF985340),
          BookStatus.wantToRead => const Color(0xFF34505A),
          BookStatus.paused => const Color(0xFF717364),
        },
        borderRadius: BorderRadius.circular(4),
      ),
      alignment: Alignment.topLeft,
      child: Text(
        book.title.toUpperCase(),
        maxLines: 4,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 10,
          height: 1.2,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
    if (coverPath == null || kIsWeb) return fallback;
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Image.file(
        File(coverPath),
        width: 78,
        height: 116,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => fallback,
      ),
    );
  }

  Widget _statusBadge() {
    final label = switch (book.status) {
      BookStatus.wantToRead => 'Muốn đọc',
      BookStatus.reading => 'Đang đọc',
      BookStatus.completed => 'Đã đọc',
      BookStatus.paused => 'Tạm dừng',
    };
    final active = book.status == BookStatus.reading;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: active ? libraryGreen : const Color(0xFFE8EFE6),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          color: active ? Colors.white : libraryGreen,
        ),
      ),
    );
  }
}
