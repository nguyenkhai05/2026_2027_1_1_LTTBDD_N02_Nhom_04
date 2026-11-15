import 'package:flutter/material.dart';
import '../l10n/app_text.dart';

import '../models/book.dart';
import '../theme/library_colors.dart';
import 'book_cover_thumbnail.dart';

/// Cover and identity shared by the read-only book detail screen.
class BookDetailIdentity extends StatelessWidget {
  const BookDetailIdentity({super.key, required this.book});

  final Book book;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: const Color(0xFFE8EFE6),
      borderRadius: BorderRadius.circular(18),
    ),
    child: Row(
      children: [
        BookCoverThumbnail(book: book, width: 110, height: 165),
        const SizedBox(width: 18),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                book.title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: libraryGreen,
                ),
              ),
              const SizedBox(height: 8),
              Text(book.author, style: const TextStyle(color: libraryMuted)),
              if (book.genre != null) ...[
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Text(tr(context, book.genre!), style: const TextStyle(color: libraryGreen)),
                ),
              ],
            ],
          ),
        ),
      ],
    ),
  );
}

class BookDetailReading extends StatelessWidget {
  const BookDetailReading({super.key, required this.book});

  final Book book;

  @override
  Widget build(BuildContext context) {
    final status = switch (book.status) {
      BookStatus.wantToRead => 'Muốn đọc',
      BookStatus.reading => 'Đang đọc',
      BookStatus.completed => 'Đã đọc',
      BookStatus.paused => 'Tạm dừng',
    };
    final progress = book.progress;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(child: LText('Trạng thái đọc', style: TextStyle(fontSize: 16, color: libraryInk))),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: book.status == BookStatus.reading ? libraryGreen : const Color(0xFFE8EFE6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: LText(status, style: TextStyle(color: book.status == BookStatus.reading ? Colors.white : libraryGreen)),
            ),
          ],
        ),
        const SizedBox(height: 22),
        if (progress == null)
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LText('Chưa có thông tin tổng số trang', style: TextStyle(color: libraryMuted)),
              SizedBox(height: 8),
              LText('Bổ sung tổng số trang trong Chỉnh sửa để cập nhật tiến độ.', style: TextStyle(color: libraryMuted)),
            ],
          )
        else
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const LText('Tiến độ đọc', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: libraryInk)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: Text('${book.currentPage} / ${book.totalPages} ${tr(context, 'trang')}')),
                    Text('${(progress * 100).round()}%', style: const TextStyle(color: libraryGreen, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 14),
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 6,
                    backgroundColor: const Color(0xFFE3E5DF),
                    valueColor: const AlwaysStoppedAnimation(libraryGreen),
                  ),
                ),
              ],
            ),
          ),
        if (book.genre != null || book.totalPages != null) ...[
          const SizedBox(height: 20),
          Row(children: [
            if (book.genre != null)
              Expanded(child: _Metadata(label: 'THỂ LOẠI', value: tr(context, book.genre!))),
            if (book.totalPages != null)
              Expanded(child: _Metadata(label: 'TỔNG SỐ TRANG', value: '${book.totalPages} ${tr(context, 'trang')}')),
          ]),
        ],
        if (book.description != null) ...[
          const SizedBox(height: 26),
          const LText('Mô tả', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: libraryInk)),
          const SizedBox(height: 12),
          Text(book.description!, style: const TextStyle(color: libraryMuted, height: 1.5)),
        ],
        if (book.notes != null) ...[
          const SizedBox(height: 26),
          const LText('Ghi chú cá nhân', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: libraryInk)),
          const SizedBox(height: 12),
          Text(book.notes!, style: const TextStyle(color: libraryMuted, height: 1.5)),
        ],
      ],
    );
  }
}

class _Metadata extends StatelessWidget {
  const _Metadata({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      LText(label, style: const TextStyle(color: libraryMuted, fontSize: 11, fontWeight: FontWeight.w600)),
      const SizedBox(height: 7),
      Text(value, style: const TextStyle(color: libraryInk, fontSize: 15)),
    ],
  );
}
