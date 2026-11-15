import 'package:flutter/material.dart';
import '../l10n/app_text.dart';

class LibrarySearchField extends StatelessWidget {
  const LibrarySearchField({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) => TextField(
    controller: controller,
    textInputAction: TextInputAction.search,
    decoration: InputDecoration(
      hintText: tr(context, 'Tìm tên sách hoặc tác giả'),
      prefixIcon: const Icon(Icons.search),
      suffixIcon: controller.text.isEmpty
          ? null
          : IconButton(
              tooltip: tr(context, 'Xóa từ khóa'),
              icon: const Icon(Icons.close),
              onPressed: controller.clear,
            ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFE2E5DE)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFE2E5DE)),
      ),
    ),
  );
}
