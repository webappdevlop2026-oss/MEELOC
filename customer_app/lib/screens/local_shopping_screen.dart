import 'package:flutter/material.dart';
import '../theme.dart';
import '../data.dart';
import 'home_screen.dart';
import 'offer_details_screen.dart';

class LocalShoppingScreen extends StatefulWidget {
  final String initial;
  const LocalShoppingScreen({super.key, this.initial = 'All'});
  @override
  State<LocalShoppingScreen> createState() => _LocalShoppingScreenState();
}

class _LocalShoppingScreenState extends State<LocalShoppingScreen> {
  static const filters = ['All', 'Grocery', 'Restaurant', 'Electronics', 'Beauty', 'Fashion'];
  late String sel = filters.contains(widget.initial) ? widget.initial : 'All';

  @override
  Widget build(BuildContext context) {
    final list = sel == 'All' ? shops : shops.where((s) => s.category == sel).toList();
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 64,
        title: const Column(mainAxisSize: MainAxisSize.min, children: [
          Text('Local Shopping'),
          Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.location_on, size: 13, color: MC.green),
            Text(' Dubrajpur 731123', style: TextStyle(fontSize: 12, color: MC.sub, fontWeight: FontWeight.w400)),
          ]),
        ]),
        actions: [
          IconButton(onPressed: () => mSnack(context, 'Cart is empty'), icon: const Icon(Icons.shopping_bag_outlined)),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
        children: [
          const MSearchBar(hint: 'Search local shops, offers...'),
          const SizedBox(height: 12),
          SizedBox(
            height: 34,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                for (final f in filters)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => setState(() => sel = f),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: sel == f ? MC.green : Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: sel == f ? MC.green : MC.line),
                        ),
                        child: Text(f,
                            style: TextStyle(
                                fontSize: 13,
                                color: sel == f ? Colors.white : MC.text,
                                fontWeight: FontWeight.w500)),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          if (list.isEmpty)
            const Padding(
              padding: EdgeInsets.all(40),
              child: Center(child: Text('No shops found', style: TextStyle(color: MC.sub))),
            ),
          for (final s in list) ShopCard(shop: s),
        ],
      ),
    );
  }
}

class ShopCard extends StatelessWidget {
  final Shop shop;
  const ShopCard({super.key, required this.shop});
  @override
  Widget build(BuildContext context) => InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => OfferDetailsScreen(shop: shop))),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: MC.line))),
          child: Row(children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(shop.image, width: 96, height: 78, fit: BoxFit.cover),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(shop.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Row(children: [
                  const Icon(Icons.star_rounded, color: MC.star, size: 16),
                  Text(' ${shop.rating}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  Text(' (${shop.reviews})', style: const TextStyle(fontSize: 12, color: MC.sub)),
                  const SizedBox(width: 12),
                  const Icon(Icons.location_on_outlined, size: 13, color: MC.sub),
                  Text(shop.distance, style: const TextStyle(fontSize: 12, color: MC.sub)),
                ]),
                const SizedBox(height: 8),
                Row(children: [
                  OffBadge(text: shop.offer),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(shop.offerNote,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 11, color: MC.red)),
                  ),
                ]),
              ]),
            ),
          ]),
        ),
      );
}
