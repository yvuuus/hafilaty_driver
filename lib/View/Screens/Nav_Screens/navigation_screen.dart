import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hafilaty_driver/View/Screens/Main_Screens/History_Screen/history_screen.dart';
import 'package:hafilaty_driver/View/Screens/Main_Screens/Home_Screen/home_screen.dart';
import 'package:hafilaty_driver/View/Screens/Main_Screens/Schedule_Screen/Schedule_screen.dart';
import 'package:hafilaty_driver/View/Screens/Main_Screens/Profile_Screen/profile_screen.dart';
import 'package:hafilaty_driver/View/Screens/Nav_Screens/navigation_providers.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  List<Widget> screens = [
    const HomeScreen(),
    const ScheduleScreen(), // Replace this with the Schedule screen.
    const HistoryScreen(), // Replace this with the Inbox screen.
    const ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return Scaffold(
          body: screens[ref.watch(navigationStateProvider)],
          bottomNavigationBar: NavigationBar(
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined, color: Colors.white),
                label: "",
                selectedIcon: Icon(Icons.home, color: Colors.white),
              ),
              NavigationDestination(
                icon: Icon(Icons.schedule_outlined, color: Colors.white),
                label: "",
                selectedIcon: Icon(Icons.schedule, color: Colors.white),
              ),
              NavigationDestination(
                icon: Icon(Icons.inbox_outlined, color: Colors.white),
                label: "",
                selectedIcon: Icon(Icons.inbox, color: Colors.white),
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outlined, color: Colors.white),
                label: "",
                selectedIcon: Icon(Icons.person, color: Colors.white),
              )
            ],
            onDestinationSelected: (int selection) {
              ref
                  .watch(navigationStateProvider.notifier)
                  .update((state) => selection);
            },
            backgroundColor: Colors.purple.shade700,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
            selectedIndex: ref.watch(navigationStateProvider),
          ),
        );
      },
    );
  }
}
