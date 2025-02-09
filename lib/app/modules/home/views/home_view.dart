import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: FlutterSplashScreen.fadeIn(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Get.theme.primaryColor,
            Get.theme.primaryColor
                .withRed((Get.theme.primaryColor.red * 0.8).toInt())
                .withGreen((Get.theme.primaryColor.green * 0.8).toInt())
                .withBlue((Get.theme.primaryColor.blue * 0.8).toInt())
          ],
        ),
        onEnd: () async {
          debugPrint("On End");
          await controller.verifyAuth();
        },
        childWidget: SizedBox(
          height: 50,
          // child: Image.asset("assets/icon/icon.png"),
        ),
        duration: const Duration(milliseconds: 1000),
        animationDuration: const Duration(milliseconds: 500),
        onAnimationEnd: () => debugPrint("On Scale End"),
      )),
    );
  }
}
