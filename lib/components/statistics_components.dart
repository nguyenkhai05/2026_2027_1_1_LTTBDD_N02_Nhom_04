import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../l10n/app_text.dart';

import '../models/book.dart';
import '../models/reading_statistics.dart';
import '../theme/library_colors.dart';

class StatisticsSummaryCard extends StatelessWidget {
  const StatisticsSummaryCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.wide = false,
    this.iconColor = libraryGreen,
  });

  final String label;
  final int value;
  final IconData icon;
  final bool wide;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: wide ? double.infinity : null,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 19),
          const SizedBox(height: 5),
          Text(
            '$value',
            style: const TextStyle(
              color: libraryInk,
              fontSize: 21,
              height: 1.1,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 5),
          LText(
            label,
            style: const TextStyle(color: libraryMuted, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class ReadingStatusChart extends StatelessWidget {
  const ReadingStatusChart({super.key, required this.statistics});

  final ReadingStatistics statistics;

  static const _statuses = [
    _StatusStyle(BookStatus.wantToRead, 'Muốn đọc', Color(0xFFC7D2BD)),
    _StatusStyle(BookStatus.reading, 'Đang đọc', Color(0xFF526B50)),
    _StatusStyle(BookStatus.completed, 'Đã đọc', Color(0xFFD0A05A)),
    _StatusStyle(BookStatus.paused, 'Tạm dừng', Color(0xFF9A9E93)),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const LText(
            'Trạng thái đọc',
            style: TextStyle(
              color: libraryInk,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 5,
                child: SizedBox(
                  height: 112,
                  child: CustomPaint(
                    painter: _ReadingStatusPainter(
                      values: _statuses
                          .map((item) => statistics.count(item.status))
                          .toList(),
                      colors: _statuses.map((item) => item.color).toList(),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 44),
                        child: Text(
                          '${statistics.total}',
                          style: const TextStyle(
                            color: libraryInk,
                            fontSize: 19,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final item in _statuses)
                      _LegendItem(
                        label: item.label,
                        count: statistics.count(item.status),
                        percentage: statistics.percentage(item.status),
                        color: item.color,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.label,
    required this.count,
    required this.percentage,
    required this.color,
  });

  final String label;
  final int count;
  final String percentage;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 7),
          Expanded(
            child: LText(
              label,
              style: const TextStyle(color: libraryInk, fontSize: 10),
            ),
          ),
          Text(
            '$count · $percentage',
            style: const TextStyle(color: libraryMuted, fontSize: 10),
          ),
        ],
      ),
    );
  }
}

class _StatusStyle {
  const _StatusStyle(this.status, this.label, this.color);
  final BookStatus status;
  final String label;
  final Color color;
}

class _ReadingStatusPainter extends CustomPainter {
  const _ReadingStatusPainter({required this.values, required this.colors});

  final List<int> values;
  final List<Color> colors;

  @override
  void paint(Canvas canvas, Size size) {
    final total = values.fold<int>(0, (sum, value) => sum + value);
    final diameter = math.min(size.width * .92, size.height * 1.65).toDouble();
    final rect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height * .82),
      width: diameter,
      height: diameter,
    );
    const gap = .045;
    var start = math.pi;

    for (var index = 0; index < values.length; index++) {
      final sweep = total == 0 ? 0.0 : math.pi * values[index] / total;
      if (sweep > 0) {
        final paint = Paint()
          ..color = colors[index]
          ..style = PaintingStyle.stroke
          ..strokeWidth = 13
          ..strokeCap = StrokeCap.butt;
        canvas.drawArc(
          rect,
          start,
          math.max(0.0, sweep - gap).toDouble(),
          false,
          paint,
        );
      }
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _ReadingStatusPainter oldDelegate) =>
      !listEquals(oldDelegate.values, values) ||
      !listEquals(oldDelegate.colors, colors);
}
