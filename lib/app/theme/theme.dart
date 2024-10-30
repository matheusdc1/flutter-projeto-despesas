import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData buildTheme(brightness) {
  var baseTheme = ThemeData(brightness: brightness);

  return baseTheme.copyWith(
    appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
    textTheme: GoogleFonts.nunitoTextTheme(baseTheme.textTheme),
  );
}
