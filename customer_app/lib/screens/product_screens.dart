import 'package:flutter/material.dart';
import '../theme.dart';
import '../data.dart';
import '../state.dart';
import '../widgets.dart';
import 'cart_screens.dart';

class ProductListScreen extends StatefulWidget {
  final String title;
  final String? category, brand;
  const ProductListScreen({super.key, required this.title, this.category, this.brand});
  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  String sort = 'Popular';

  @override
  Widget build(BuildContext context) {
    final list = products
        .where((p) => widget.category == null || p.category == widget.category)
        .where((p) => widget.brand == null || p.brand == widget.brand)
        .toList();
    if (sort == 'Low to High') list.sort((a, b) => a.priceValue.compareTo(b.priceValue));
    if (sort == 'High to Low') list.sort((a, b) => b.priceValue.compareTo(a.priceValue));
    return Scaffold(
      appBar: AppBar(title: Text(widget.title), actions: [
        PopupMenuButton<String>(
          icon: const Icon(Icons.sort),
          onSelected: (v) => setState(() => sort = v),
          itemBuilder: (_) => const [
            PopupMenuItem(value: 'Popular', child: Text('Popular')),
            PopupMenuItem(value: 'Low to High', child: Text('Price: Low to High')),
            PopupMenuItem(value: 'High to Low', child: Text('Price: High to Low')),
          ],
        ),
        const CartButton(),
      ]),
      body: list.isEmpty
          ? const MEmpty(icon: Icons.inventory_2_outlined, text: 'No products yet')
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: list.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: .78,
              ),
              itemBuilder: (_, i) => ProductCard(p: list[i]),
            ),
    );
  }
}

class ProductDetailScreen extends StatelessWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final p = product;
    return Scaffold(
      appBar: AppBar(title: Text(p.brand), actions: const [CartButton()]),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Stack(children: [
            Container(
              decoration: BoxDecoration(border: Border.all(color: MC.line), borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.all(16),
              child: ProductImage(p: p, height: 220),
            ),
            Positioned(left: 10, top: 10, child: OffBadge(text: p.off)),
          ]),
          const SizedBox(height: 16),
          Text(p.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Row(children: [
            const Icon(Icons.star_rounded, color: MC.star, size: 18),
            Text(' ${p.rating}', style: const TextStyle(fontWeight: FontWeight.w600)),
            Text('  •  Sold by ${p.brand}', style: const TextStyle(color: MC.sub)),
          ]),
          const SizedBox(height: 10),
          Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(p.price, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
            const SizedBox(width: 8),
            Text(p.mrp, style: const TextStyle(color: MC.sub, decoration: TextDecoration.lineThrough)),
            const SizedBox(width: 8),
            Text(p.off, style: const TextStyle(color: MC.green, fontWeight: FontWeight.w700)),
          ]),
          const SizedBox(height: 16),
          const _Feature(icon: Icons.local_shipping_outlined, text: 'Free delivery in 3-5 days'),
          const _Feature(icon: Icons.replay_outlined, text: '7 days easy return'),
          const _Feature(icon: Icons.payments_outlined, text: 'Cash on Delivery available'),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Row(children: [
            Expanded(
              child: MOutlineButton(
                label: 'Add to Cart',
                icon: Icons.add_shopping_cart,
                onTap: () {
                  app.addToCart(p.id);
                  mSnack(context, 'Added to cart');
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: MPrimaryButton(
                label: 'Buy Now',
                color: MC.orange,
                onTap: () {
                  app.addToCart(p.id);
                  push(context, const CartScreen());
                },
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class _Feature extends StatelessWidget {
  final IconData icon;
  final String text;
  const _Feature({required this.icon, required this.text});
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(children: [
          Icon(icon, size: 20, color: MC.green),
          const SizedBox(width: 10),
          Text(text),
        ]),
      );
}
