enum AppLanguage {
  vietnamese('vi', 'Tiếng Việt'),
  english('en', 'English');

  const AppLanguage(this.code, this.label);

  final String code;
  final String label;

  static AppLanguage fromCode(String? code) =>
      code == AppLanguage.english.code ? AppLanguage.english : AppLanguage.vietnamese;
}
