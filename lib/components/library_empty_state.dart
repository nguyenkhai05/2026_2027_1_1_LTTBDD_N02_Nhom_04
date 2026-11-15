import 'package:flutter/material.dart';
import '../l10n/app_text.dart';

import '../theme/library_colors.dart';

/// Reused for an empty library, an empty search and a storage error.
class LibraryEmptyState extends StatelessWidget {
  const LibraryEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.action,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String description;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          color: const Color(0xFFE8EFE6),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Icon(icon, color: libraryGreen, size: 32),
      ),
      const SizedBox(height: 20),
      LText(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Color(0xFF354B36),
          fontSize: 21,
          fontWeight: FontWeight.w700,
        ),
      ),
      const SizedBox(height: 14),
      LText(
        description,
        textAlign: TextAlign.center,
        style: const TextStyle(color: libraryMuted, height: 1.5),
      ),
      if (action != null && onAction != null) ...[
        const SizedBox(height: 18),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: FilledButton(
            onPressed: onAction,
            style: FilledButton.styleFrom(backgroundColor: libraryGreen),
            child: LText(action!),
          ),
        ),
      ],
    ],
  );
}
