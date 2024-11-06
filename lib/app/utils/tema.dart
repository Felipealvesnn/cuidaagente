import 'package:flutter/material.dart';

Color colorVerde = const Color(0xFF86AE28);
Color colorAzulinfo = const Color(0xFF28A1AE);
Color VermelhoEscuro = const Color(0xFFAE2828);

ThemeData ThemaApp() {
  final MaterialColor customGreen = createMaterialColor(colorVerde);

  return ThemeData(
    fontFamily: 'Quicksand',
    primaryColor: colorVerde,
    primarySwatch: customGreen,
    scaffoldBackgroundColor: Colors.grey[200],
    dividerTheme: const DividerThemeData(
      space: 0,
      thickness: 1,
      color: Colors.grey,
    ),
    colorScheme: ColorScheme.fromSwatch(
      backgroundColor: Colors.blueGrey,
      primarySwatch: customGreen,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith<Color>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.disabled)) {
            return Colors.grey
                .withOpacity(0.5); // Cor para o estado desabilitado
          }
          if (states.contains(WidgetState.selected)) {
            return Colors.white; // Cor quando o switch está ativado
          }
          return colorVerde; // Cor quando o switch está desativado
        },
      ),
      trackColor: WidgetStateProperty.resolveWith<Color>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.disabled)) {
            return Colors.white; // Cor para o estado desabilitado
          }
          if (states.contains(WidgetState.selected)) {
            return colorVerde; // Cor quando o switch está ativado
          }
          return Colors.black12; // Cor quando o switch está desativado
        },
      ),
      trackOutlineColor: WidgetStateProperty.resolveWith<Color>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.disabled)) {
            return Colors.black12; // Cor para o estado desabilitado
          }
          if (states.contains(WidgetState.selected)) {
            return Colors.black12; // Cor quando o switch está ativado
          }
          return Colors.black12; // Cor quando o switch está desativado
        },
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: colorVerde,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all<Color>(
            Colors.white), // Define a cor da label
        backgroundColor:
            WidgetStateProperty.all<Color>(colorVerde), // Cor de fundo do botão
        textStyle: WidgetStateProperty.all<TextStyle>(
          const TextStyle(fontSize: 16), // Tamanho do texto
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: const TextStyle(
        color: Colors.black, // Cor do label
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
            12.0), // Defina o raio das bordas arredondadas
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
            12.0), // Bordas arredondadas quando o campo estiver focado
        borderSide: BorderSide(
          color: colorVerde, // Cor da borda quando o campo estiver focado
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
            12.0), // Bordas arredondadas quando o campo está habilitado
        borderSide: const BorderSide(
          color: Colors.grey, // Cor da borda quando o campo está habilitado
        ),
      ),
    ),
  );
}

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}
