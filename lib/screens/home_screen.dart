import 'package:flutter/material.dart';

import '../components/overview_card.dart';
import '../components/home_header.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              HomeHeader(),
              SizedBox(height: 20),
              OverviewCard(),
            ],
          ),
        ),
      ),
    );
  }
}
