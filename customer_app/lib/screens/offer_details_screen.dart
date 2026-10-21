import 'package:flutter/material.dart';
import '../theme.dart';
import '../data.dart';
import 'home_screen.dart';

class OfferDetailsScreen extends StatelessWidget {
  final Shop shop;
  const OfferDetailsScreen({super.key, required this.shop});

  String get _pct => RegExp(r'\d+%').firstMatch(shop.offer)?.group(0) ?? shop.offer;

  @override
  Widget build(BuildContext context) {
    final isTasty = shop.name.startsWith('Tasty');
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Stack(children: [
            Image.asset(isTasty ? 'assets/images/food_header.png' : shop.image,
                height: 230, width: double.infinity, fit: BoxFit.cover),
            Positioned(
              top: MediaQuery.of(context).padding.top + 6,
              left: 8,
              right: 8,
              child: Row(children: [
                _round(Icons.chevron_left, () => Navigator.pop(context)),
                const Spacer(),
                _round(Icons.ios_share_rounded, () => mSnack(context, 'Share link copied')),
              ]),
            ),
            Positioned(left: 14, bottom: 14, child: OffBadge(text: '$_pct OFF')),
          ]),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(
                  child: Text(shop.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                ),
                const Icon(Icons.location_on_outlined, size: 14, color: MC.sub),
                Text(shop.distance, style: const TextStyle(fontSize: 12, color: MC.sub)),
              ]),
              const SizedBox(height: 4),
              Row(children: [
                const Icon(Icons.star_rounded, color: MC.star, size: 18),
                Text(' ${shop.rating}', style: const TextStyle(fontWeight: FontWeight.w600)),
                Text(' (${shop.reviews} reviews)', style: const TextStyle(color: MC.sub, fontSize: 13)),
              ]),
              const SizedBox(height: 16),
              Row(children: [
                _info(Icons.discount_outlined, '$_pct OFF', 'On Total Bill'),
                const SizedBox(width: 10),
                _info(Icons.event_note_outlined, 'Valid Till', shop.validTill),
                const SizedBox(width: 10),
                _info(Icons.restaurant_outlined, shop.mode, 'Only'),
              ]),
              const SizedBox(height: 20),
              const Text('About This Offer', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Text(shop.about, style: const TextStyle(fontSize: 14, color: Color(0xFF4B5563), height: 1.5)),
              const SizedBox(height: 22),
              Row(children: [
                Expanded(
                  child: MOutlineButton(
                      label: 'Call', icon: Icons.call_outlined, onTap: () => mSnack(context, 'Calling ${shop.name}...')),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: MOutlineButton(
                      label: 'Directions',
                      icon: Icons.directions_outlined,
                      onTap: () => mSnack(context, 'Opening maps...')),
                ),
              ]),
              const SizedBox(height: 14),
              MPrimaryButton(
                label: 'Claim Offer',
                onTap: () => showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Offer Claimed!'),
                    content: Text('Show this code at ${shop.name}:\n\nMEELOC-${shop.name.hashCode.abs() % 100000}'),
                    actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              ValueListenableBuilder<Set<String>>(
                valueListenable: savedShops,
                builder: (_, saved, __) {
                  final on = saved.contains(shop.name);
                  return MOutlineButton(
                    label: on ? 'Saved' : 'Save Offer',
                    icon: on ? Icons.favorite : Icons.favorite_border,
                    onTap: () => toggleSaved(shop.name),
                  );
                },
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _round(IconData i, VoidCallback onTap) => Material(
        color: Colors.black26,
        shape: const CircleBorder(),
        child: IconButton(onPressed: onTap, icon: Icon(i, color: Colors.white)),
      );

  Widget _info(IconData icon, String a, String b) => Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(color: MC.bg, borderRadius: BorderRadius.circular(10), border: Border.all(color: MC.line)),
          child: Column(children: [
            Icon(icon, size: 26, color: MC.text),
            const SizedBox(height: 6),
            Text(a, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            Text(b, style: const TextStyle(fontSize: 11, color: MC.sub)),
          ]),
        ),
      );
}
