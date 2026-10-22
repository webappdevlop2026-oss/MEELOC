import 'package:flutter/material.dart';
import '../theme.dart';
import '../data.dart';
import '../widgets.dart';

class SearchScreen extends StatefulWidget {
  final bool productsOnly;
  const SearchScreen({super.key, this.productsOnly = false});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String q = '';
  static const popular = ['Grocery', 'Restaurant', 'Mobiles', 'Shoes', 'Salon', 'Pharmacy'];
  final ctrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final s = q.toLowerCase();
    final shopRes = widget.productsOnly || s.isEmpty
        ? <Shop>[]
        : shops.where((x) => '${x.name} ${x.category} ${x.offerNote}'.toLowerCase().contains(s)).toList();
    final prodRes = s.isEmpty
        ? <Product>[]
        : products.where((x) => '${x.name} ${x.brand} ${x.category}'.toLowerCase().contains(s)).toList();
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.only(right: 16),
          child: MSearchBar(
            hint: widget.productsOnly ? 'Search products, brands...' : 'Search offers, shops, products...',
            controller: ctrl,
            autofocus: true,
            onChanged: (v) => setState(() => q = v.trim()),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (s.isEmpty) ...[
            const Text('Popular searches', style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
            Wrap(spacing: 8, runSpacing: 8, children: [
              for (final p in popular)
                ActionChip(
                  label: Text(p),
                  onPressed: () {
                    ctrl.text = p;
                    setState(() => q = p);
                  },
                ),
            ]),
          ] else if (shopRes.isEmpty && prodRes.isEmpty)
            MEmpty(icon: Icons.search_off, text: 'No results for "$q"'),
          if (shopRes.isNotEmpty) ...[
            const Text('Local Shops', style: TextStyle(fontWeight: FontWeight.w700)),
            for (final x in shopRes) ShopCard(shop: x),
            const SizedBox(height: 16),
          ],
          if (prodRes.isNotEmpty) ...[
            const Text('Online Products', style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: .78,
              children: [for (final p in prodRes) ProductCard(p: p)],
            ),
          ],
        ],
      ),
    );
  }
}
