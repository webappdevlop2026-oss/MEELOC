import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme.dart';
import '../data.dart';
import '../state.dart';
import '../widgets.dart';

class OfferDetailsScreen extends StatelessWidget {
  final Shop shop;
  const OfferDetailsScreen({super.key, required this.shop});

  String get _pct => RegExp(r'(\d+%|₹\d+)').firstMatch(shop.offer)?.group(0) ?? shop.offer;

  Future<void> _open(BuildContext context, Uri uri) async {
    try {
      final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!ok && context.mounted) mSnack(context, 'Could not open');
    } catch (_) {
      if (context.mounted) mSnack(context, 'Could not open');
    }
  }

  void _claim(BuildContext context) {
    final c = app.claim(shop);
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (s) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.check_circle, color: MC.green, size: 56),
            const SizedBox(height: 8),
            const Text('Offer Claimed!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text('Show this code at ${shop.name}', style: const TextStyle(color: MC.sub)),
            const SizedBox(height: 16),
            InkWell(
              onTap: () {
                Clipboard.setData(ClipboardData(text: c.code));
                mSnack(context, 'Code copied');
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F6EE),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: MC.green),
                ),
                child: Column(children: [
                  Text(c.code,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, letterSpacing: 2, color: MC.green)),
                  const SizedBox(height: 4),
                  const Text('Tap to copy', style: TextStyle(fontSize: 12, color: MC.sub)),
                ]),
              ),
            ),
            const SizedBox(height: 16),
            MPrimaryButton(label: 'Done', onTap: () => Navigator.pop(s)),
          ]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isTasty = shop.name.startsWith('Tasty');
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Stack(children: [
            isTasty
                ? Image.asset('assets/images/food_header.png', height: 230, width: double.infinity, fit: BoxFit.cover)
                : ShopImage(shop: shop, width: double.infinity, height: 230, radius: 0),
            Positioned(
              top: MediaQuery.of(context).padding.top + 6,
              left: 8,
              right: 8,
              child: Row(children: [
                _round(Icons.chevron_left, () => Navigator.pop(context)),
                const Spacer(),
                _round(Icons.ios_share_rounded, () {
                  Clipboard.setData(ClipboardData(
                      text: '${shop.name}: ${shop.offer} ${shop.offerNote} – Meeloc app e dekhun! https://meeloc.vercel.app'));
                  mSnack(context, 'Offer link copied – share it anywhere');
                }),
              ]),
            ),
            Positioned(left: 14, bottom: 14, child: OffBadge(text: '$_pct OFF')),
          ]),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(child: Text(shop.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700))),
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
                _info(Icons.discount_outlined, '$_pct OFF', shop.offerNote),
                const SizedBox(width: 10),
                _info(Icons.event_note_outlined, 'Valid Till', shop.validTill),
                const SizedBox(width: 10),
                _info(shop.mode == 'Dine In' ? Icons.restaurant_outlined : Icons.store_outlined, shop.mode, 'Only'),
              ]),
              const SizedBox(height: 20),
              const Text('About This Offer', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Text(shop.about, style: const TextStyle(fontSize: 14, color: Color(0xFF4B5563), height: 1.5)),
              const SizedBox(height: 22),
              Row(children: [
                Expanded(
                  child: MOutlineButton(
                      label: 'Call', icon: Icons.call_outlined, onTap: () => _open(context, Uri.parse('tel:${shop.phone}'))),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: MOutlineButton(
                    label: 'Directions',
                    icon: Icons.directions_outlined,
                    onTap: () => _open(
                      context,
                      Uri.parse('https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent('${shop.name} ${app.location}')}'),
                    ),
                  ),
                ),
              ]),
              const SizedBox(height: 14),
              ListenableBuilder(
                listenable: app,
                builder: (_, __) {
                  final claimed = app.claimed.any((c) => c.shop.name == shop.name);
                  return MPrimaryButton(label: claimed ? 'View Offer Code' : 'Claim Offer', onTap: () => _claim(context));
                },
              ),
              const SizedBox(height: 12),
              ListenableBuilder(
                listenable: app,
                builder: (_, __) {
                  final on = app.saved.contains(shop.name);
                  return MOutlineButton(
                    label: on ? 'Saved' : 'Save Offer',
                    icon: on ? Icons.favorite : Icons.favorite_border,
                    onTap: () => app.toggleSaved(shop.name),
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
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          decoration:
              BoxDecoration(color: MC.bg, borderRadius: BorderRadius.circular(10), border: Border.all(color: MC.line)),
          child: Column(children: [
            Icon(icon, size: 26, color: MC.text),
            const SizedBox(height: 6),
            Text(a, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            Text(b,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 11, color: MC.sub)),
          ]),
        ),
      );
}
