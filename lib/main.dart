import 'package:flutter/services.dart';
import 'package:cuidaagente/app/utils/FirebaseMenssagensFunctions.dart';
import 'package:cuidaagente/app/utils/getstorages.dart';
import 'package:cuidaagente/app/utils/tema.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  // Carregue o audio source no player

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: colorVerde, // navigation bar color
    statusBarColor: colorVerde, // status bar color
  ));

  await iniciarFirebasemsg();

  await inicializacaoGetStorage();
  //await initializeForegroundService();

  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      theme: ThemaApp(),
    ),
  );
}
