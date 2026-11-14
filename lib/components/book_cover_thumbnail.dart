import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/book.dart';

/// Displays a saved cover or a compact cover generated from the book title.
class BookCoverThumbnail extends StatelessWidget {
  const BookCoverThumbnail({
    super.key,
    required this.book,
    required this.width,
    required this.height,
  });

  final Book book;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final fallback = Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(6),
      alignment: Alignment.topLeft,
      decoration: BoxDecoration(
        color: switch (book.status) {
          BookStatus.reading => const Color(0xFFC69B52),
          BookStatus.completed => const Color(0xFF985340),
          BookStatus.wantToRead => const Color(0xFF34505A),
          BookStatus.paused => const Color(0xFF717364),
        },
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        book.title.toUpperCase(),
        maxLines: 4,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: width < 60 ? 7 : 10,
          height: 1.2,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );

    final coverPath = book.coverPath;
    if (coverPath == null || kIsWeb) return fallback;
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Image.file(
        File(coverPath),
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => fallback,
      ),
    );
  }
}
