import 'dart:ui';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomNavigationvarocorencia extends StatelessWidget {
  final VoidCallback onImageSourceSelection;

  const BottomNavigationvarocorencia({
    super.key,
    required this.onImageSourceSelection, // Parâmetro para a função
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBottomNavigationBar.builder(
      hideAnimationCurve: Curves.easeInOut,
      itemCount: 2,
      tabBuilder: (int index, bool isActive) {
        // Define a lista de ícones e cores
        final iconList = [Icons.home, Icons.camera_alt];
        final colorList = [Get.theme.primaryColor, Colors.white];

        // Escolhe a cor e o ícone da lista com base no índice
        var color = colorList[index];
        var icon = iconList[index];

        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 24,
              color: color,
            ),
            const SizedBox(height: 4),
            Text(
              index == 0 ? 'Home' : 'Foto', // Label para cada item
              style: TextStyle(color: color),
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
      onTap: (index) {
        if (index == 1) {
          onImageSourceSelection(); // Chama a função passada como parâmetro
        }
      },
      splashColor: Get.theme.primaryColor,
      backgroundColor: Get.theme.primaryColor,
    );
  }
}
