import 'package:flutter/material.dart';
import '../theme.dart';
import '../data.dart';
import 'local_shopping_screen.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});
  @override
  Widget build(BuildContext context) => ValueListenableBuilder<Set<String>>(
        valueListenable: savedShops,
        builder: (_, saved, __) {
          final list = shops.where((s) => saved.contains(s.name)).toList();
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
            children: [
              const Text('Saved Offers', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
              if (list.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 80),
                  child: Column(children: [
                    Icon(Icons.favorite_border, size: 56, color: MC.line),
                    SizedBox(height: 10),
                    Text('No saved offers yet', style: TextStyle(color: MC.sub)),
                  ]),
                ),
              for (final s in list) ShopCard(shop: s),
            ],
          );
        },
      );
}
