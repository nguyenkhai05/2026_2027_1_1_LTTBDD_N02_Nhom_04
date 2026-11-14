import 'package:flutter/material.dart';

class OverviewCard extends StatelessWidget {
  const OverviewCard({
    super.key,
    required this.total,
    required this.reading,
    required this.completed,
  });

  final int total;
  final int reading;
  final int completed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF354B36),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _OverviewItem(number: '$total', label: 'Tổng số sách'),
          _OverviewItem(number: '$reading', label: 'Đang đọc'),
          _OverviewItem(number: '$completed', label: 'Đã đọc'),
        ],
      ),
    );
  }
}

class _OverviewItem extends StatelessWidget {
  final String number;
  final String label;

  const _OverviewItem({required this.number, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          number,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.white)),
      ],
    );
  }
}
