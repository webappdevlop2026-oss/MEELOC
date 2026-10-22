import 'package:flutter/material.dart';
import '../theme.dart';
import '../state.dart';
import 'welcome_screen.dart';

class BusinessProfileScreen extends StatefulWidget {
  const BusinessProfileScreen({super.key});
  @override
  State<BusinessProfileScreen> createState() => _BusinessProfileScreenState();
}

class _BusinessProfileScreenState extends State<BusinessProfileScreen> {
  late final shop = TextEditingController(text: biz.shopName);
  late final owner = TextEditingController(text: biz.owner);
  late final phone = TextEditingController(text: biz.phone);
  late final address = TextEditingController(text: biz.address);
  late final about = TextEditingController(text: biz.about);
  late final hours = TextEditingController(text: biz.hours);
  late String cat = bizCategories.contains(biz.category) ? biz.category : 'Other';

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(centerTitle: false, title: const Text('Business Profile')),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          children: [
            const SizedBox(height: 10),
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset('assets/images/store_thumb.png', width: 140, height: 110, fit: BoxFit.cover),
              ),
            ),
            MField(label: 'Shop Name', controller: shop),
            MField(label: 'Owner Name', controller: owner),
            MField(label: 'Mobile Number', controller: phone, keyboard: TextInputType.phone),
            const Padding(
              padding: EdgeInsets.only(top: 14, bottom: 6),
              child: Text('Category', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            ),
            Wrap(spacing: 8, runSpacing: 8, children: [
              for (final c in bizCategories)
                ChoiceChip(
                  label: Text(c),
                  selected: cat == c,
                  selectedColor: const Color(0xFFD9F2E3),
                  onSelected: (_) => setState(() => cat = c),
                ),
            ]),
            MField(label: 'Address', controller: address, maxLines: 2),
            MField(label: 'Opening Hours', controller: hours),
            MField(label: 'About Shop', controller: about, maxLines: 3),
            const SizedBox(height: 24),
            MPrimaryButton(
              label: 'Save Profile',
              onTap: () {
                if (shop.text.trim().isEmpty) {
                  mSnack(context, 'Shop name cannot be empty');
                  return;
                }
                biz.updateProfile(
                  shop: shop.text.trim(),
                  ownerName: owner.text.trim(),
                  ph: phone.text.trim(),
                  cat: cat,
                  addr: address.text.trim(),
                  aboutText: about.text.trim(),
                  openHours: hours.text.trim(),
                );
                mSnack(context, 'Profile saved');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
}

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});
  static const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  Widget build(BuildContext context) {
    final maxV = biz.weekViews.reduce((a, b) => a > b ? a : b);
    final total = biz.weekViews.reduce((a, b) => a + b);
    return Scaffold(
      appBar: AppBar(centerTitle: false, title: const Text('Analytics')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(children: [
            _tile('This Week Views', '$total', MC.blue),
            const SizedBox(width: 10),
            _tile('Active Offers', '${biz.activeOffers}', MC.green),
            const SizedBox(width: 10),
            _tile('Redeemed', '${biz.redemptions.length}', MC.orange),
          ]),
          const SizedBox(height: 20),
          const Text('Profile views – last 7 days', style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 14),
          SizedBox(
            height: 190,
            child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
              for (int i = 0; i < 7; i++)
                Expanded(
                  child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                    Text('${biz.weekViews[i]}', style: const TextStyle(fontSize: 11, color: MC.sub)),
                    const SizedBox(height: 4),
                    Container(
                      height: 140 * biz.weekViews[i] / maxV,
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      decoration: BoxDecoration(
                        color: i == 6 ? MC.green : const Color(0xFFA7E3BF),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(days[i], style: const TextStyle(fontSize: 11)),
                  ]),
                ),
            ]),
          ),
          const SizedBox(height: 24),
          const Text('Offer performance', style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          for (final o in biz.offers)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(o.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: o.views == 0 ? 0 : (o.claims / o.views).clamp(0, 1).toDouble(),
                    minHeight: 8,
                    color: MC.green,
                    backgroundColor: MC.field,
                  ),
                ),
                const SizedBox(height: 4),
                Text('${o.views} views • ${o.claims} claims', style: const TextStyle(fontSize: 12, color: MC.sub)),
              ]),
            ),
        ],
      ),
    );
  }

  Widget _tile(String l, String v, Color c) => Expanded(
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: MC.line)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(v, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: c)),
            Text(l, style: const TextStyle(fontSize: 11, color: MC.sub)),
          ]),
        ),
      );
}

class VerifyCodeScreen extends StatefulWidget {
  const VerifyCodeScreen({super.key});
  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  final code = TextEditingController(text: 'MEELOC-');
  String? result;
  bool ok = false;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(centerTitle: false, title: const Text('Verify Offer Code')),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Icon(Icons.qr_code_2, size: 90, color: MC.green),
            const SizedBox(height: 10),
            const Text('Enter the code shown by the customer',
                textAlign: TextAlign.center, style: TextStyle(color: MC.sub)),
            const SizedBox(height: 20),
            TextField(
              controller: code,
              textCapitalization: TextCapitalization.characters,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, letterSpacing: 2),
              decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
            ),
            const SizedBox(height: 20),
            MPrimaryButton(
              label: 'Verify & Redeem',
              onTap: () {
                final err = biz.redeem(code.text);
                setState(() {
                  ok = err == null;
                  result = err ?? 'Code redeemed successfully! Give the discount to the customer.';
                });
              },
            ),
            if (result != null) ...[
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: ok ? const Color(0xFFE8F6EE) : const Color(0xFFFDECEC),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(children: [
                  Icon(ok ? Icons.check_circle : Icons.error_outline, color: ok ? MC.green : MC.red),
                  const SizedBox(width: 10),
                  Expanded(child: Text(result!)),
                ]),
              ),
            ],
          ],
        ),
      );
}

class CustomersScreen extends StatelessWidget {
  const CustomersScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(centerTitle: false, title: const Text('Customers')),
        body: biz.redemptions.isEmpty
            ? const MEmpty(icon: Icons.groups_outlined, text: 'No customers yet')
            : ListView(
                children: [
                  for (final r in biz.redemptions)
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: const Color(0xFFEDE9FE),
                        child: Text(r.customer[0], style: const TextStyle(color: Color(0xFF8B5CF6))),
                      ),
                      title: Text(r.customer),
                      subtitle: Text(r.offer, maxLines: 1, overflow: TextOverflow.ellipsis),
                      trailing: Text(timeAgo(r.time), style: const TextStyle(fontSize: 11, color: MC.sub)),
                    ),
                ],
              ),
      );
}
