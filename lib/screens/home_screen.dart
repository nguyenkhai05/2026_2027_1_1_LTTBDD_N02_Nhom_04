import 'package:flutter/material.dart';

import '../components/home_header.dart';
import '../components/overview_card.dart';
import '../components/home_book_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                // Header
                HomeHeader(),

                SizedBox(height: 20),

                // Thẻ thống kê
                OverviewCard(),

                SizedBox(height: 24),

                // Khu vực Đọc tiếp
                HomeBookSection(
                  title: 'Đọc tiếp',
                  hasBooks: false,
                  emptyTitle: 'Chưa có sách đang đọc',
                  emptyDescription:
                      'Hãy chọn một cuốn sách và bắt đầu hành trình đọc nhé!',
                ),

                SizedBox(height: 24),

                // Khu vực Mới thêm gần đây
                HomeBookSection(
                  title: 'Mới thêm gần đây',
                  hasBooks: true,
                  emptyTitle: 'Thư viện của bạn đang trống',
                  emptyDescription:
                      'Thêm sách đầu tiên để bắt đầu quản lý thư viện nhé!',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
