import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laundry_customer/constants/app_colors.dart';
import 'package:laundry_customer/generated/l10n.dart';
import 'package:laundry_customer/providers/address_provider.dart';
import 'package:laundry_customer/providers/misc_providers.dart';
import 'package:upgrader/upgrader.dart';

class HomeScreenWrapper extends ConsumerStatefulWidget {
  const HomeScreenWrapper({
    super.key,
    required this.screens,
  });

  final List<Widget> screens;

  @override
  ConsumerState<HomeScreenWrapper> createState() => _HomeScreenWrapperState();
}

class _HomeScreenWrapperState extends ConsumerState<HomeScreenWrapper> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    ref.watch(addresListProvider);

    return Scaffold(
      body: UpgradeAlert(
        upgrader: Upgrader(
          durationUntilAlertAgain: const Duration(minutes: 10),
        ),
        child: widget.screens[_selectedIndex],
      ),
      bottomNavigationBar: Container(
        height: 80,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 15,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
            ref.read(homeScreenIndexProvider.notifier).state = index;
          },
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textColor,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home_outlined),
              label: S.of(context).home,
            ),

            BottomNavigationBarItem(
              icon: const Icon(Icons.notifications_none_rounded),
              label: S.of(context).ntfctns,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.menu),
              label: S.of(context).myorder,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person_2_outlined),
              label: S.of(context).prfl,
            ),
          ],
        ),
      ),
    );
  }
}
