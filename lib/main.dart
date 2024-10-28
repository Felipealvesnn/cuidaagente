import 'package:cuidaagente/app/utils/getstorages.dart';
import 'package:cuidaagente/app/utils/tema.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

void main() async {
  await inicializacaoGetStorage();
  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      theme: apptemprincipal,
    ),
  );
}
