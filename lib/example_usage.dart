import 'package:flutter/material.dart';
import 'welcome_screen.dart';

/// Example showing how to integrate the animated welcome screen
/// This demonstrates the beautiful animated splash screen with:
/// - Gradient background
/// - Elastic scale animation for SVG
/// - Fade-in animations
/// - Slide-up text animation
/// - Pulsing loading indicator
/// - Animated dots
class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Samadhan - Animated Splash',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'SF Pro Display', // You can add custom fonts
      ),
      home: const WelcomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

/// You can also create a splash screen controller to handle navigation
class SplashController {
  static Future<void> navigateAfterDelay(
    BuildContext context,
    Widget nextScreen, {
    Duration delay = const Duration(seconds: 3),
  }) async {
    await Future.delayed(delay);
    if (context.mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => nextScreen,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    }
  }
}
