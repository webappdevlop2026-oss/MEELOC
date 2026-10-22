import 'package:flutter/material.dart';
import 'theme.dart';
import 'data.dart';
import 'state.dart';
import 'screens/offer_details_screen.dart';
import 'screens/product_screens.dart';
import 'screens/cart_screens.dart';

void push(BuildContext c, Widget w) => Navigator.push(c, MaterialPageRoute(builder: (_) => w));

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
              maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11, color: MC.text)),
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

/// Shop photo, or a coloured icon box when the shop has no photo.
class ShopImage extends StatelessWidget {
  final Shop shop;
  final double width, height, radius;
  const ShopImage({super.key, required this.shop, required this.width, required this.height, this.radius = 10});
  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: shop.image != null
            ? Image.asset(shop.image!, width: width, height: height, fit: BoxFit.cover)
            : Container(
                width: width,
                height: height,
                color: const Color(0xFFE8F6EE),
                child: Icon(shop.icon, color: MC.green, size: height * .45),
              ),
      );
}

class ProductImage extends StatelessWidget {
  final Product p;
  final double height;
  const ProductImage({super.key, required this.p, required this.height});
  @override
  Widget build(BuildContext context) => SizedBox(
        height: height,
        width: double.infinity,
        child: p.image != null
            ? Image.asset(p.image!, fit: BoxFit.contain)
            : Container(
                color: const Color(0xFFF3F6FB),
                child: Icon(p.icon, size: height * .5, color: MC.blue),
              ),
      );
}

class ShopCard extends StatelessWidget {
  final Shop shop;
  const ShopCard({super.key, required this.shop});
  @override
  Widget build(BuildContext context) => InkWell(
        onTap: () => push(context, OfferDetailsScreen(shop: shop)),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: MC.line))),
          child: Row(children: [
            ShopImage(shop: shop, width: 96, height: 78),
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
                        overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11, color: MC.red)),
                  ),
                ]),
              ]),
            ),
            ListenableBuilder(
              listenable: app,
              builder: (_, __) => IconButton(
                onPressed: () => app.toggleSaved(shop.name),
                icon: Icon(app.saved.contains(shop.name) ? Icons.favorite : Icons.favorite_border,
                    color: app.saved.contains(shop.name) ? MC.red : MC.sub, size: 22),
              ),
            ),
          ]),
        ),
      );
}

class ProductCard extends StatelessWidget {
  final Product p;
  const ProductCard({super.key, required this.p});
  @override
  Widget build(BuildContext context) => InkWell(
        onTap: () => push(context, ProductDetailScreen(product: p)),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: MC.line)),
          clipBehavior: Clip.antiAlias,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Stack(children: [
              Padding(padding: const EdgeInsets.only(top: 14), child: ProductImage(p: p, height: 86)),
              Positioned(left: 0, top: 0, child: OffBadge(text: p.off, small: true)),
            ]),
            Padding(
              padding: const EdgeInsets.all(6),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(p.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11)),
                Row(children: [
                  Text(p.price, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(p.mrp,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 10, color: MC.sub, decoration: TextDecoration.lineThrough)),
                  ),
                ]),
              ]),
            ),
          ]),
        ),
      );
}

/// Cart icon with item count.
class CartButton extends StatelessWidget {
  const CartButton({super.key});
  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: app,
        builder: (_, __) => IconButton(
          onPressed: () => push(context, const CartScreen()),
          icon: Badge(
            isLabelVisible: app.cartCount > 0,
            label: Text('${app.cartCount}'),
            child: const Icon(Icons.shopping_bag_outlined),
          ),
        ),
      );
}

/// Section title with "See All".
class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAll;
  const SectionHeader({super.key, required this.title, this.onSeeAll});
  @override
  Widget build(BuildContext context) => Row(children: [
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        const Spacer(),
        if (onSeeAll != null)
          GestureDetector(
            onTap: onSeeAll,
            child: const Text('See All', style: TextStyle(color: MC.green, fontWeight: FontWeight.w600)),
          ),
      ]);
}
