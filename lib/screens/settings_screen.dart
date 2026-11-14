import 'package:flutter/material.dart';

import '../components/home_bottom_navigation.dart';
import '../theme/library_colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    super.key,
    required this.onTabSelected,
    required this.language,
    required this.onLanguageChanged,
  });

  final ValueChanged<int> onTabSelected;
  final String language;
  final ValueChanged<String> onLanguageChanged;

  void _openLanguage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _LanguageScreen(
          selectedLanguage: language,
          onLanguageChanged: onLanguageChanged,
        ),
      ),
    );
  }

  void _openAboutTeam(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const _AboutTeamScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F6F0),
      bottomNavigationBar: HomeBottomNavigation(
        currentIndex: 3,
        onTap: onTabSelected,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Cài đặt',
                style: TextStyle(
                  color: libraryInk,
                  fontSize: 23,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Nhẹ nhàng, theo cách của bạn.',
                style: TextStyle(color: libraryMuted, fontSize: 13),
              ),
              const SizedBox(height: 24),
              const _SectionLabel('TÙY CHỈNH'),
              const SizedBox(height: 12),
              _SettingsTile(
                icon: Icons.language_outlined,
                title: 'Ngôn ngữ',
                subtitle: language,
                onTap: () => _openLanguage(context),
              ),
              const SizedBox(height: 20),
              const _SectionLabel('VỀ ỨNG DỤNG'),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.menu_book_outlined,
                          color: libraryGreen,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'MyShelf',
                          style: TextStyle(
                            color: Color(0xFF354B36),
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Thư viện cá nhân, luôn bên bạn.',
                      style: TextStyle(color: libraryMuted, fontSize: 13),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Quản lý sách và theo dõi tiến độ đọc.',
                      style: TextStyle(color: libraryMuted, fontSize: 13),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _SettingsTile(
                icon: Icons.info_outline,
                title: 'Thông tin nhóm',
                onTap: () => _openAboutTeam(context),
              ),
              const SizedBox(height: 18),
              const Text(
                'Một góc đọc, của riêng bạn.',
                style: TextStyle(color: libraryMuted, fontSize: 11),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: Color(0xFF687064),
        fontSize: 10,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: SizedBox(
          height: subtitle == null ? 56 : 62,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: [
                Icon(icon, color: libraryGreen, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: libraryInk,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 3),
                        Text(
                          subtitle!,
                          style: const TextStyle(
                            color: libraryMuted,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  color: Color(0xFF687064),
                  size: 21,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LanguageScreen extends StatelessWidget {
  const _LanguageScreen({
    required this.selectedLanguage,
    required this.onLanguageChanged,
  });

  final String selectedLanguage;
  final ValueChanged<String> onLanguageChanged;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F6F0),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F6F0),
        surfaceTintColor: Colors.transparent,
        title: const Text('Ngôn ngữ'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Chọn ngôn ngữ hiển thị trong ứng dụng',
              style: TextStyle(color: libraryMuted, fontSize: 13),
            ),
            const SizedBox(height: 20),
            _LanguageOption(
              label: 'Tiếng Việt',
              selected: selectedLanguage == 'Tiếng Việt',
              onTap: () {
                onLanguageChanged('Tiếng Việt');
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 12),
            _LanguageOption(
              label: 'English',
              selected: selectedLanguage == 'English',
              onTap: () {
                onLanguageChanged('English');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  const _LanguageOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: libraryInk,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(
                selected ? Icons.check_circle : Icons.circle_outlined,
                color: selected ? libraryGreen : libraryMuted,
                size: 21,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AboutTeamScreen extends StatelessWidget {
  const _AboutTeamScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F6F0),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F6F0),
        surfaceTintColor: Colors.transparent,
        title: const Text('Thông tin nhóm'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              children: [
                Icon(Icons.menu_book_outlined, color: libraryGreen, size: 42),
                SizedBox(height: 12),
                Text(
                  'MyShelf',
                  style: TextStyle(
                    color: Color(0xFF354B36),
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Ứng dụng quản lý sách cá nhân',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: libraryInk, fontSize: 14),
                ),
                SizedBox(height: 10),
                Text(
                  'Ứng dụng hỗ trợ quản lý thư viện cá nhân và theo dõi tiến độ đọc.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: libraryMuted, fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Thông tin thành viên',
                  style: TextStyle(
                    color: libraryInk,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Thông tin thành viên nhóm sẽ được cập nhật tại đây.',
                  style: TextStyle(color: libraryMuted, fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Center(
            child: Text(
              'Cảm ơn bạn đã sử dụng MyShelf.',
              style: TextStyle(color: libraryMuted, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
