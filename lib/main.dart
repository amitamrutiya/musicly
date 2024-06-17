import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:musicly/page/splash_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(backgroundColor: Color(0xff2C2C54), body: SplashScreen()),
    );
  }
}
