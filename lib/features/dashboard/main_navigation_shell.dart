import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'home_screen.dart';
import '../attendance/attendance_screen.dart';
import '../work/work_screen.dart';
import '../leave/leave_screen.dart';
import '../more/more_screen.dart';

class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _currentIndex = 0;

  void _switchTab(int index) {
    setState(() => _currentIndex = index);
  }

  void _goHome() {
    setState(() => _currentIndex = 0);
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomeScreen(onNavigateTab: _switchTab),
      AttendanceScreen(onBack: _goHome),
      WorkManagementScreen(onBack: _goHome),
      LeaveScreen(onBack: _goHome),
      MoreScreen(onBack: _goHome),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.border, width: 1.0)),
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          elevation: 0,
          backgroundColor: Colors.white,
          indicatorColor: AppColors.primaryLight,
          onDestinationSelected: (index) {
            setState(() => _currentIndex = index);
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded, color: AppColors.primary),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.calendar_today_outlined),
              selectedIcon: Icon(Icons.calendar_today_rounded, color: AppColors.primary),
              label: 'Attendance',
            ),
            NavigationDestination(
              icon: Icon(Icons.assignment_outlined),
              selectedIcon: Icon(Icons.assignment_rounded, color: AppColors.primary),
              label: 'Work',
            ),
            NavigationDestination(
              icon: Icon(Icons.time_to_leave_outlined),
              selectedIcon: Icon(Icons.time_to_leave_rounded, color: AppColors.primary),
              label: 'Leave',
            ),
            NavigationDestination(
              icon: Icon(Icons.grid_view_outlined),
              selectedIcon: Icon(Icons.grid_view_rounded, color: AppColors.primary),
              label: 'More',
            ),
          ],
        ),
      ),
    );
  }
}
