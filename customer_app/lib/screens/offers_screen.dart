import 'package:flutter/material.dart';
import '../theme.dart';
import '../data.dart';
import 'local_shopping_screen.dart';

class OffersScreen extends StatelessWidget {
  const OffersScreen({super.key});
  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
        children: [
          const Text('All Offers', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          const MSearchBar(hint: 'Search offers...'),
          const SizedBox(height: 6),
          for (final s in shops) ShopCard(shop: s),
        ],
      );
}
