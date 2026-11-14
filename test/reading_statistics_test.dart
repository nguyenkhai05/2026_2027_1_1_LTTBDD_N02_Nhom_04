import 'package:flutter_test/flutter_test.dart';
import 'package:lt_tbdd/models/book.dart';
import 'package:lt_tbdd/models/reading_statistics.dart';

void main() {
  test('counts all four statuses and keeps half percentages', () {
    final statuses = [
      BookStatus.reading,
      BookStatus.reading,
      BookStatus.reading,
      BookStatus.completed,
      BookStatus.completed,
      BookStatus.wantToRead,
      BookStatus.wantToRead,
      BookStatus.paused,
    ];
    final statistics = ReadingStatistics([
      for (var i = 0; i < statuses.length; i++)
        Book(title: 'Sách $i', author: 'Tác giả', status: statuses[i]),
    ]);

    expect(statistics.total, 8);
    expect(statistics.count(BookStatus.reading), 3);
    expect(statistics.count(BookStatus.completed), 2);
    expect(statistics.count(BookStatus.wantToRead), 2);
    expect(statistics.count(BookStatus.paused), 1);
    expect(statistics.percentage(BookStatus.reading), '37.5%');
    expect(statistics.percentage(BookStatus.completed), '25%');
    expect(statistics.percentage(BookStatus.paused), '12.5%');
  });

  test('an empty library has zero counts and no division by zero', () {
    final statistics = ReadingStatistics([]);
    expect(statistics.total, 0);
    for (final status in BookStatus.values) {
      expect(statistics.count(status), 0);
      expect(statistics.percentage(status), '0%');
    }
  });
}
