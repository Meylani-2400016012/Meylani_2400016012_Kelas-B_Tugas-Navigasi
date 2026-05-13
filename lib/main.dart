import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const ReminderTugasApp());
}

class ReminderTugasApp extends StatelessWidget {
  const ReminderTugasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reminder Tugas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF8FAB),
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}