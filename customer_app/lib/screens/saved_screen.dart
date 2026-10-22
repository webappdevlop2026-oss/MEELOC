import 'package:flutter/material.dart';
import '../theme.dart';
import '../data.dart';
import '../state.dart';
import '../widgets.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});
  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: app,
        builder: (context, _) {
          final list = shops.where((s) => app.saved.contains(s.name)).toList();
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
            children: [
              const Text('Saved Offers', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
              if (list.isEmpty)
                const MEmpty(icon: Icons.favorite_border, text: 'No saved offers yet.\nTap ♡ on any offer to save it.'),
              for (final s in list) ShopCard(shop: s),
            ],
          );
        },
      );
}
