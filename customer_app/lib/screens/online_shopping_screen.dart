import 'package:flutter/material.dart';
import '../theme.dart';
import '../data.dart';
import '../widgets.dart';
import 'product_screens.dart';
import 'search_screen.dart';

class OnlineShoppingScreen extends StatelessWidget {
  const OnlineShoppingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Online Shopping'), actions: const [CartButton()]),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
        children: [
          MSearchBar(
            hint: 'Search products, brands, offers...',
            onTap: () => push(context, const SearchScreen(productsOnly: true)),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (final b in brands)
                GestureDetector(
                  onTap: () => push(context, ProductListScreen(title: b.name, brand: b.name)),
                  child: Column(children: [
                    Container(
                      width: 46,
                      height: 46,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(color: b.bg, shape: BoxShape.circle, border: Border.all(color: MC.line)),
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
          GestureDetector(
            onTap: () => push(context, const ProductListScreen(title: 'Big Billion Deals')),
            child: Container(
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
          ),
          const SizedBox(height: 14),
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 6,
            childAspectRatio: .9,
            children: [
              for (final c in onlineCats)
                CatIcon(
                  cat: c,
                  onTap: () => push(
                    context,
                    c.name == 'More'
                        ? const ProductListScreen(title: 'All Products')
                        : ProductListScreen(title: c.name, category: c.name),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          SectionHeader(
            title: 'Top Deals',
            onSeeAll: () => push(context, const ProductListScreen(title: 'Top Deals')),
          ),
          const SizedBox(height: 10),
          Row(children: [
            for (int i = 0; i < 3; i++) ...[
              if (i > 0) const SizedBox(width: 10),
              Expanded(child: ProductCard(p: products[i])),
            ],
          ]),
        ],
      ),
    );
  }
}
