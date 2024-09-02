import 'package:flutter/material.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';

class BottomNavbarWidget extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavbarWidget({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SafeArea(
        child: FloatingNavbar(
          currentIndex: currentIndex,
          onTap: onTap,
          borderRadius: 25,
          iconSize: 24,
          margin: const EdgeInsets.symmetric(horizontal: 15),
          padding: const EdgeInsets.all(8),
          selectedBackgroundColor: Colors.transparent,
          selectedItemColor: Colors.transparent,
          unselectedItemColor: Colors.white70,
          backgroundColor: const Color.fromARGB(255, 26, 33, 109),
          items: [
            FloatingNavbarItem(icon: Icons.home),
            FloatingNavbarItem(icon: Icons.add),
            FloatingNavbarItem(icon: Icons.payment),
            FloatingNavbarItem(icon: Icons.person),
          ],
        ),
      ),
    );
  }
}
