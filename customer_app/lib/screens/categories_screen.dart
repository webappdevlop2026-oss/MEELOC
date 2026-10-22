import 'package:flutter/material.dart';
import '../data.dart';
import '../widgets.dart';
import 'local_shopping_screen.dart';
import 'product_screens.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
      children: [
        const Text('Categories', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
        const SizedBox(height: 10),
        const Text('Local Shopping', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        GridView.count(
          crossAxisCount: 4,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: .9,
          children: [
            for (final c in homeCats.where((c) => c.name != 'More'))
              CatIcon(cat: c, onTap: () => push(context, LocalShoppingScreen(initial: c.name))),
          ],
        ),
        const SizedBox(height: 12),
        const Text('Online Shopping', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        GridView.count(
          crossAxisCount: 4,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: .9,
          children: [
            for (final c in onlineCats.where((c) => c.name != 'More'))
              CatIcon(cat: c, onTap: () => push(context, ProductListScreen(title: c.name, category: c.name))),
          ],
        ),
      ],
    );
  }
}
