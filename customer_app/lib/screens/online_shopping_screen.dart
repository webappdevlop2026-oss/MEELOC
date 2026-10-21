import 'package:flutter/material.dart';
import '../theme.dart';
import '../data.dart';
import 'home_screen.dart';

class OnlineShoppingScreen extends StatelessWidget {
  const OnlineShoppingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Online Shopping')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
        children: [
          const MSearchBar(hint: 'Search products, brands, offers...'),
          const SizedBox(height: 14),
          // Brands
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (final b in brands)
                GestureDetector(
                  onTap: () => mSnack(context, 'Opening ${b.name} deals'),
                  child: Column(children: [
                    Container(
                      width: 46,
                      height: 46,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: b.bg,
                        shape: BoxShape.circle,
                        border: Border.all(color: MC.line),
                      ),
                      child: Text(b.letter,
                          style: TextStyle(
                              color: b.fg,
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              fontStyle: b.name == 'Nykaa' || b.name == 'Flipkart' ? FontStyle.italic : null)),
                    ),
                    const SizedBox(height: 5),
                    Text(b.name, style: const TextStyle(fontSize: 11)),
                  ]),
                ),
            ],
          ),
          const SizedBox(height: 14),
          // Big Billion banner
          Container(
            height: 120,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: const LinearGradient(colors: [Color(0xFF0B2E8A), Color(0xFF1C47C9)]),
            ),
            child: Row(children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 4, 12),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('BIG',
                        style: TextStyle(
                            color: Color(0xFFFFD233), fontSize: 26, fontWeight: FontWeight.w900, height: 1)),
                    const Text('BILLION',
                        style: TextStyle(
                            color: Color(0xFFFFD233), fontSize: 20, fontWeight: FontWeight.w900, height: 1.1)),
                    const Text('UP TO 80% OFF',
                        style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                      decoration:
                          BoxDecoration(color: const Color(0xFFFFC928), borderRadius: BorderRadius.circular(6)),
                      child: const Text('Shop Now', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                    ),
                  ]),
                ),
              ),
              Image.asset('assets/images/big_billion_art.png', width: 150, height: 120, fit: BoxFit.cover),
            ]),
          ),
          const SizedBox(height: 14),
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 6,
            childAspectRatio: .9,
            children: [
              for (final c in onlineCats) CatIcon(cat: c, onTap: () => mSnack(context, '${c.name} deals')),
            ],
          ),
          const SizedBox(height: 10),
          Row(children: [
            const Text('Top Deals', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            const Spacer(),
            GestureDetector(
              onTap: () => mSnack(context, 'All deals'),
              child: const Text('See All', style: TextStyle(color: MC.green, fontWeight: FontWeight.w600)),
            ),
          ]),
          const SizedBox(height: 10),
          Row(children: [
            for (int i = 0; i < deals.length; i++) ...[
              if (i > 0) const SizedBox(width: 10),
              Expanded(child: _DealCard(deal: deals[i])),
            ],
          ]),
        ],
      ),
    );
  }
}

class _DealCard extends StatelessWidget {
  final Deal deal;
  const _DealCard({required this.deal});
  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: MC.line),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Stack(children: [
            Container(
              color: Colors.white,
              height: 90,
              width: double.infinity,
              padding: const EdgeInsets.only(top: 14),
              child: Image.asset(deal.image, fit: BoxFit.contain),
            ),
            Positioned(left: 0, top: 0, child: OffBadge(text: deal.off, small: true)),
          ]),
          Padding(
            padding: const EdgeInsets.all(6),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(deal.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11)),
              Text(deal.price, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
            ]),
          ),
        ]),
      );
}
