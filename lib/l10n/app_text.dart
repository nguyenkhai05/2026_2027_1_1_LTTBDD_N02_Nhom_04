import 'package:flutter/material.dart';

import '../models/app_language.dart';

/// The selected language is available to every page, including pushed routes.
class AppLanguageScope extends InheritedWidget {
  const AppLanguageScope({
    super.key,
    required this.language,
    required super.child,
  });

  final AppLanguage language;

  static AppLanguage of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppLanguageScope>()?.language ??
      AppLanguage.vietnamese;

  @override
  bool updateShouldNotify(AppLanguageScope oldWidget) => language != oldWidget.language;
}

// Vietnamese source strings are the stable lookup keys. Unknown strings, such
// as a user's book title, are never modified by the translation helper.
const englishText = <String, String>{
  'Cài đặt': 'Settings',
  'Nhẹ nhàng, theo cách của bạn.': 'Make it yours, at your own pace.',
  'TÙY CHỈNH': 'PREFERENCES',
  'Ngôn ngữ': 'Language',
  'Ngôn ngữ của bạn': 'Your language',
  'Chọn ngôn ngữ hiển thị trong ứng dụng. Tên sách và tác giả sẽ được giữ nguyên.':
      'Choose the app language. Book titles and authors stay as you entered them.',
  'Không thể lưu ngôn ngữ. Hãy thử lại.': 'Could not save the language. Please try again.',
  'VỀ ỨNG DỤNG': 'ABOUT THE APP',
  'Thư viện cá nhân, luôn bên bạn.': 'Your personal library, always with you.',
  'Quản lý sách và theo dõi tiến độ đọc.': 'Organize books and track your reading.',
  'Thông tin nhóm': 'Team information',
  'Một góc đọc, của riêng bạn.': 'A reading corner of your own.',
};

String tr(BuildContext context, String vietnamese) =>
    AppLanguageScope.of(context) == AppLanguage.english
        ? englishText[vietnamese] ?? vietnamese
        : vietnamese;

/// Translates static interface copy without changing the Flutter Text API used
/// by our shared components. Book titles and user-authored text use Text.
class LText extends StatelessWidget {
  const LText(this.data, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  final String data;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) => Text(
    tr(context, data),
    style: style,
    textAlign: textAlign,
    maxLines: maxLines,
    overflow: overflow,
  );
}
