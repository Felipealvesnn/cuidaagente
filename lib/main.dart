import 'package:cuidaagente/app/utils/FirebaseMenssagensFunctions.dart';
import 'package:cuidaagente/app/utils/getstorages.dart';
import 'package:cuidaagente/app/utils/tema.dart';
import 'package:cuidaagente/app/utils/ultil.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await iniciarFirebasemsg();

  await inicializacaoGetStorage();
  //await initializeForegroundService();
  await initializeBackgroundService();

  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      theme: apptemprincipal,
    ),
  );
}
