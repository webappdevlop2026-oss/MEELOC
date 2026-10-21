import 'package:flutter/material.dart';
import 'theme.dart';
import 'screens/welcome_screen.dart';

void main() => runApp(const MeelocBusinessApp());

class MeelocBusinessApp extends StatelessWidget {
  const MeelocBusinessApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Meeloc Business',
        debugShowCheckedModeBanner: false,
        theme: meelocTheme(),
        home: const BusinessWelcomeScreen(),
      );
}
