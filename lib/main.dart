import 'package:flutter/material.dart';
import 'package:responsive_design/profile_card.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // this widget is the root of your application
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Responsive Design',
      home: const ProfileCard()
    );
  }
}

