import 'package:flutter/material.dart';
import '../l10n/app_text.dart';

Future<bool> showLibraryDeleteDialog(
  BuildContext context, {
  required String bookTitle,
}) async {
  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.white,
        insetPadding: const EdgeInsets.symmetric(horizontal: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const LText(
                'Xóa sách?',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF252A24),
                ),
              ),

              const SizedBox(height: 16),

              Text(
                tr(context, 'Bạn có chắc muốn xóa "{title}" khỏi thư viện không?')
                    .replaceAll('{title}', bookTitle),
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: Color(0xFF6C746A),
                ),
              ),

              const SizedBox(height: 12),

              const LText(
                'Thao tác này không thể hoàn tác.',
                style: TextStyle(fontSize: 13, color: Color(0xFF6C746A)),
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: FilledButton(
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFE8EEE5),
                          foregroundColor: const Color(0xFF354B36),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const LText(
                          'Hủy',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: FilledButton(
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFB74742),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const LText(
                          'Xóa',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );

  return result ?? false;
}
