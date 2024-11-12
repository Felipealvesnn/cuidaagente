import 'dart:ui';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomNavigationvarDemanda extends StatelessWidget {
  const BottomNavigationvarDemanda({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBottomNavigationBar.builder(
      hideAnimationCurve: Curves.easeInOut,
      itemCount: 2,
      tabBuilder: (int index, bool isActive) {
        var color = Get.theme.primaryColor; // Define a cor como transparente
        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.home,
              size: 24,
              color: color, // Ícone invisível
            ),
            const SizedBox(height: 4),
            Text(
              'Home',
              style: TextStyle(color: color), // Texto invisível
            ),
          ],
        );
      },
      activeIndex: 0,
      gapLocation: GapLocation.center,
      notchSmoothness: NotchSmoothness.smoothEdge,
      notchMargin: 8,
      leftCornerRadius: 2,
      rightCornerRadius: 2,
      onTap: (index) {},
      splashColor: Get.theme.primaryColor, // Define a cor do splash como transparente
      backgroundColor: Get.theme.primaryColor, // Define o fundo como transparente
    );
  }
}
