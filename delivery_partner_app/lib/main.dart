import 'package:flutter/material.dart';
import 'theme.dart';
import 'screens/welcome_screen.dart';

void main() => runApp(const MeelocPartnerApp());

class MeelocPartnerApp extends StatelessWidget {
  const MeelocPartnerApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Meeloc Partner',
        debugShowCheckedModeBanner: false,
        theme: meelocTheme(),
        home: const PartnerWelcomeScreen(),
      );
}
