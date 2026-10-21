import 'package:flutter/material.dart';
import '../theme.dart';
import '../data.dart';
import 'local_shopping_screen.dart';
import 'online_shopping_screen.dart';
import 'offer_details_screen.dart';

class HomeScreen extends StatelessWidget {
  final ValueChanged<int> onTab;
  const HomeScreen({super.key, required this.onTab});

  void _go(BuildContext c, Widget w) => Navigator.push(c, MaterialPageRoute(builder: (_) => w));

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
      children: [
        // Header
        Row(children: [
          const Icon(Icons.location_on_rounded, color: MC.green, size: 30),
          const SizedBox(width: 4),
          const Text('Meeloc', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: MC.text)),
          const SizedBox(width: 8),
          const Icon(Icons.location_on, size: 14, color: MC.text),
          const Text('Dubrajpur 731123', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          const Spacer(),
          IconButton(
            onPressed: () => mSnack(context, 'No new notifications'),
            icon: const Icon(Icons.notifications_none_rounded, size: 26),
          ),
        ]),
        const SizedBox(height: 8),
        const MSearchBar(hint: 'Search offers, shops, products...'),
        const SizedBox(height: 14),
        // Local / Online cards
        Row(children: [
          Expanded(
            child: _BigCard(
              colors: const [Color(0xFF1BB27E), Color(0xFF0E9268)],
              icon: Icons.storefront_rounded,
              title: 'Local Shopping',
              sub: 'Near You',
              onTap: () => _go(context, const LocalShoppingScreen()),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _BigCard(
              colors: const [Color(0xFFFF8A3D), Color(0xFFF2542D)],
              icon: Icons.shopping_cart_outlined,
              title: 'Online Shopping',
              sub: 'All India Deals',
              onTap: () => _go(context, const OnlineShoppingScreen()),
            ),
          ),
        ]),
        const SizedBox(height: 16),
        // Categories
        GridView.count(
          crossAxisCount: 4,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 6,
          childAspectRatio: .9,
          children: [
            for (final c in homeCats)
              CatIcon(
                cat: c,
                onTap: () => c.name == 'More'
                    ? onTab(2)
                    : _go(context, LocalShoppingScreen(initial: c.name)),
              ),
          ],
        ),
        const SizedBox(height: 10),
        // Local Deals banner
        GestureDetector(
          onTap: () => _go(context, const LocalShoppingScreen()),
          child: Container(
            height: 92,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: const LinearGradient(colors: [Color(0xFF138A3E), Color(0xFF2DB04F)]),
            ),
            child: Row(children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 12, 4, 10),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('Local Deals',
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
                    const Text('Big Savings Near You', style: TextStyle(color: Colors.white, fontSize: 12)),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: const Color(0xFFFFC928), borderRadius: BorderRadius.circular(6)),
                      child: const Text('Shop Now',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: MC.text)),
                    ),
                  ]),
                ),
              ),
              Image.asset('assets/images/local_deals_art.png', width: 140, height: 92, fit: BoxFit.cover),
            ]),
          ),
        ),
        const SizedBox(height: 16),
        Row(children: [
          const Text("Today's Best Offers", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          const Spacer(),
          GestureDetector(
            onTap: () => onTab(1),
            child: const Text('See All', style: TextStyle(color: MC.green, fontWeight: FontWeight.w600)),
          ),
        ]),
        const SizedBox(height: 10),
        SizedBox(
          height: 150,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: shops.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (_, i) {
              final s = shops[i];
              return GestureDetector(
                onTap: () => _go(context, OfferDetailsScreen(shop: s)),
                child: SizedBox(
                  width: 130,
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Stack(children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(s.image, width: 130, height: 95, fit: BoxFit.cover),
                      ),
                      Positioned(left: 6, top: 6, child: OffBadge(text: s.offer, small: true)),
                    ]),
                    const SizedBox(height: 6),
                    Text(s.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                    Text(s.distance, style: const TextStyle(fontSize: 11, color: MC.sub)),
                  ]),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _BigCard extends StatelessWidget {
  final List<Color> colors;
  final IconData icon;
  final String title, sub;
  final VoidCallback onTap;
  const _BigCard({required this.colors, required this.icon, required this.title, required this.sub, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          height: 96,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: colors),
          ),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(icon, color: Colors.white, size: 38),
            const SizedBox(height: 4),
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
            Text(sub, style: const TextStyle(color: Colors.white, fontSize: 11)),
          ]),
        ),
      );
}

/// Round light icon + label used for categories.
class CatIcon extends StatelessWidget {
  final Cat cat;
  final VoidCallback? onTap;
  const CatIcon({super.key, required this.cat, this.onTap});
  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFF3F4F6),
              border: Border.all(color: MC.line),
            ),
            child: Icon(cat.icon, color: cat.color, size: 26),
          ),
          const SizedBox(height: 6),
          Text(cat.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 11, color: MC.text)),
        ]),
      );
}

/// Red discount pill.
class OffBadge extends StatelessWidget {
  final String text;
  final bool small;
  const OffBadge({super.key, required this.text, this.small = false});
  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.symmetric(horizontal: small ? 6 : 10, vertical: small ? 2 : 5),
        decoration: BoxDecoration(color: MC.red, borderRadius: BorderRadius.circular(small ? 4 : 6)),
        child: Text(text,
            style: TextStyle(color: Colors.white, fontSize: small ? 10 : 12, fontWeight: FontWeight.w600)),
      );
}
