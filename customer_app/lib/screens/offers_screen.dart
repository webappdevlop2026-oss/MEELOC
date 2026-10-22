import 'package:flutter/material.dart';
import '../theme.dart';
import '../data.dart';
import '../widgets.dart';

class OffersScreen extends StatefulWidget {
  const OffersScreen({super.key});
  @override
  State<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {
  String q = '';
  @override
  Widget build(BuildContext context) {
    final list = shops
        .where((s) => q.isEmpty || '${s.name} ${s.category} ${s.offerNote}'.toLowerCase().contains(q))
        .toList();
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
      children: [
        const Text('All Offers', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
        const SizedBox(height: 10),
        MSearchBar(hint: 'Search offers...', onChanged: (v) => setState(() => q = v.toLowerCase())),
        const SizedBox(height: 6),
        if (list.isEmpty) const MEmpty(icon: Icons.local_offer_outlined, text: 'No offers found'),
        for (final s in list) ShopCard(shop: s),
      ],
    );
  }
}
