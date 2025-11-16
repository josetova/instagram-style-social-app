import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home/home_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthProvider, ThemeProvider>(
      builder: (context, authProvider, themeProvider, child) {
        return MaterialApp(
          title: 'Social Media App',
          debugShowCheckedModeBanner: false,
          theme: themeProvider.currentTheme,
          home: authProvider.isAuthenticated 
              ? const HomeScreen() 
              : const LoginScreen(),
        );
      },
    );
  }
}
