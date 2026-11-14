import 'package:flutter/material.dart';

import '../models/book.dart';
import '../theme/library_colors.dart';
import 'book_cover_thumbnail.dart';

class LibraryBookCard extends StatelessWidget {
  const LibraryBookCard({
    super.key,
    required this.book,
    required this.onFavorite,
    required this.onDelete,
    required this.onUpdateProgress,
    this.onTap,
  });

  final Book book;
  final VoidCallback? onFavorite;
  final VoidCallback? onDelete;
  final VoidCallback? onUpdateProgress;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final progress = book.progress;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BookCoverThumbnail(book: book, width: 78, height: 116),
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

                    IconButton(
                      onPressed: onUpdateProgress,
                      tooltip: 'Cập nhật tiến độ',
                      visualDensity: VisualDensity.compact,
                      icon: const Icon(
                        Icons.edit_note_outlined,
                        color: libraryGreen,
                      ),
                    ),

                    IconButton(
                      onPressed: onDelete,
                      tooltip: 'Xóa sách',
                      visualDensity: VisualDensity.compact,
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Color(0xFFB74742),
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
        ),
      ),
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
