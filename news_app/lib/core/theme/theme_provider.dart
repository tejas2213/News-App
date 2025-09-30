import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:news_app/core/theme/app_theme.dart';

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeData>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<ThemeData> {
  ThemeNotifier() : super(lightTheme);

  void toggleTheme() {
    state = state.brightness == Brightness.light ? darkTheme : lightTheme;
  }
}