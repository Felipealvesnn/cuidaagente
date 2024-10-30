import 'package:flutter/material.dart';

/*  Color _primaryColor = Color(0xff252aff);
  Color _accentColor = HexColor('#8A02AE'); */

final ThemeData appTema = ThemeData(
    iconTheme: IconThemeData(color: colorCustom),
    brightness: Brightness.light,
    visualDensity: VisualDensity.standard,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor:
            WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
          return colorCustom;
        }),
      ),
    ),
    primaryColor: createMaterialColor(Colors.blue
        .shade300), //HexColor("#85f900"), //Color.fromARGB(255, 38, 77, 250),
    primarySwatch: colorCustom,
    cardColor: Colors.white,
    scaffoldBackgroundColor: const Color.fromARGB(255, 233, 233, 233),
    dividerColor: Colors.grey,
    colorScheme: ColorScheme.fromSwatch(primarySwatch: colorCustom)
        .copyWith(secondary: const Color.fromARGB(255, 255, 0, 64)),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: Colors.grey,
      ),
    ),
    drawerTheme: DrawerThemeData(backgroundColor: colorCustom),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white30,
        elevation: 10,
        selectedItemColor: colorCustom,
        unselectedItemColor: Colors.black54),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: colorCustom,
    ));

final ThemeData appTemaDark = ThemeData(
    iconTheme: const IconThemeData(color: Colors.white),
    brightness: Brightness.dark,
    visualDensity: VisualDensity.standard,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor:
            WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
          return Colors.grey;
        }),
      ),
    ),
    primaryColor: Colors.grey,
    primarySwatch: Colors.grey,
    cardColor: Colors.white,
    scaffoldBackgroundColor: Colors.grey,
    dividerColor: Colors.white,
    colorScheme: ColorScheme.fromSwatch(
            primarySwatch: colorCustom, brightness: Brightness.dark)
        .copyWith(secondary: Colors.greenAccent, brightness: Brightness.dark),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: Colors.grey,
      ),
      bodyLarge: TextStyle(
        color: Colors.white,
      ),
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: Color.fromARGB(255, 44, 44, 44),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.black54,
        elevation: 10,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white10),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.black45,
    ));

Map<int, Color> color = {
  50: const Color.fromRGBO(0, 174, 249, .1),
  100: const Color.fromRGBO(0, 174, 249, .2),
  200: const Color.fromRGBO(0, 174, 249, .3),
  300: const Color.fromRGBO(0, 174, 249, .4),
  400: const Color.fromRGBO(0, 174, 249, .5),
  500: const Color.fromARGB(153, 39, 116, 20),
  600: const Color.fromARGB(177, 34, 131, 21),
  700: const Color.fromARGB(204, 23, 109, 44),
  800: const Color.fromARGB(228, 33, 143, 42),
  900: const Color.fromARGB(255, 41, 121, 65),
  //azul juno
};

//MaterialColor colorCustom = MaterialColor(0xFF252aff, color); //azul juno
MaterialColor colorCustom = MaterialColor(8780032, color); //azul juno

MaterialColor createMaterialColor(Color color) {
  List<int> strengths = <int>[50, 100, 200, 300, 400, 500, 600, 700, 800, 900];
  Map<int, Color> swatch = <int, Color>{};
  final int r = color.red, g = color.green, b = color.blue;

  for (int strength in strengths) {
    final double blend = 1.0 - (strength / 900);
    swatch[strength] = Color.fromRGBO(
      r,
      g,
      b,
      blend,
    );
  }
  return MaterialColor(color.value, swatch);
}

final apptemprincipal = ThemeData(
  primaryColor: Colors.blue.shade300,
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Colors.white,
  ),
  scaffoldBackgroundColor: Colors.grey[200],
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.all(Colors.blue.shade400),
      foregroundColor: WidgetStateProperty.all(Colors.white), // Cor do texto
      textStyle: WidgetStateProperty.all(
        const TextStyle(
          fontSize: 18,
        ),
      ),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    floatingLabelStyle: const TextStyle(fontSize: 14, color: Colors.black),
    outlineBorder: const BorderSide(
      color: Colors.grey,
      width: 2,
    ),
    isDense: true,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        color: Colors.grey,
        width: 2,
      ),
    ),
  ),
  appBarTheme: AppBarTheme(
    color: Colors.blue.shade300,
    centerTitle: true,
  ),
);
