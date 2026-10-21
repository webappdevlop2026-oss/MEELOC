import 'package:flutter/material.dart';
import '../data.dart';
import 'home_screen.dart';
import 'local_shopping_screen.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final cats = homeCats.where((c) => c.name != 'More').toList();
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
      children: [
        const Text('Categories', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        const Text('Local', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        GridView.count(
          crossAxisCount: 4,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: .9,
          children: [
            for (final c in cats)
              CatIcon(
                cat: c,
                onTap: () => Navigator.push(
                    context, MaterialPageRoute(builder: (_) => LocalShoppingScreen(initial: c.name))),
              ),
          ],
        ),
        const SizedBox(height: 12),
        const Text('Online', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        GridView.count(
          crossAxisCount: 4,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: .9,
          children: [for (final c in onlineCats.where((c) => c.name != 'More')) CatIcon(cat: c)],
        ),
      ],
    );
  }
}
