import 'book.dart';

/// Counts reading statuses from the same snapshot shown by the statistics tab.
class ReadingStatistics {
  ReadingStatistics(Iterable<Book> books)
    : _counts = {
        for (final status in BookStatus.values) status: 0,
      } {
    for (final book in books) {
      _counts[book.status] = _counts[book.status]! + 1;
      total++;
    }
  }

  final Map<BookStatus, int> _counts;
  int total = 0;

  int count(BookStatus status) => _counts[status]!;

  String percentage(BookStatus status) {
    if (total == 0) return '0%';
    final value = count(status) * 100 / total;
    final formatted = value.toStringAsFixed(1);
    return '${formatted.endsWith('.0') ? formatted.substring(0, formatted.length - 2) : formatted}%';
  }
}
