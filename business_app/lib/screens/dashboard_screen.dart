import 'package:flutter/material.dart';
import '../theme.dart';
import '../state.dart';
import 'add_offer_screen.dart';
import 'manage_offers_screen.dart';
import 'more_screens.dart';
import 'welcome_screen.dart';

class BusinessDashboardScreen extends StatelessWidget {
  const BusinessDashboardScreen({super.key});

  void _go(BuildContext c, Widget w) => Navigator.push(c, MaterialPageRoute(builder: (_) => w));

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: biz,
        builder: (context, _) => Scaffold(
          appBar: AppBar(
            centerTitle: false,
            title: const Text('Business Dashboard'),
            actions: [
              PopupMenuButton<String>(
                onSelected: (v) async {
                  if (v == 'profile') _go(context, const BusinessProfileScreen());
                  if (v == 'logout' &&
                      await mConfirm(context, 'Logout', 'Logout from business panel?', ok: 'Logout')) {
                    biz.logout();
                    if (context.mounted) {
                      Navigator.pushAndRemoveUntil(
                          context, MaterialPageRoute(builder: (_) => const BusinessWelcomeScreen()), (_) => false);
                    }
                  }
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'profile', child: Text('Business Profile')),
                  PopupMenuItem(value: 'logout', child: Text('Logout')),
                ],
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 6, 16, 20),
            children: [
              InkWell(
                onTap: () => _go(context, const BusinessProfileScreen()),
                child: Row(children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset('assets/images/store_thumb.png', width: 90, height: 72, fit: BoxFit.cover),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(biz.shopName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Row(children: [
                        const Icon(Icons.star_rounded, color: MC.star, size: 16),
                        const Text(' 4.5', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                              color: biz.shopOpen ? MC.green : MC.sub, borderRadius: BorderRadius.circular(5)),
                          child: Text(biz.shopOpen ? 'Active' : 'Closed',
                              style: const TextStyle(color: Colors.white, fontSize: 11)),
                        ),
                      ]),
                      const SizedBox(height: 4),
                      Row(children: [
                        const Text('4.5 (120)', style: TextStyle(fontSize: 12, color: MC.sub)),
                        const Spacer(),
                        const Icon(Icons.location_on_outlined, size: 13, color: MC.sub),
                        Flexible(
                          child: Text(biz.address.split(',').length > 1 ? biz.address.split(',')[1].trim() : biz.address,
                              overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, color: MC.sub)),
                        ),
                      ]),
                    ]),
                  ),
                ]),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: MC.line)),
                child: SwitchListTile(
                  dense: true,
                  value: biz.shopOpen,
                  activeTrackColor: MC.green,
                  title: Text(biz.shopOpen ? 'Shop is Open – visible to customers' : 'Shop is Closed',
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  onChanged: biz.toggleShop,
                ),
              ),
              const SizedBox(height: 14),
              Row(children: [
                _Stat(icon: Icons.visibility, color: MC.blue, value: '${biz.profileViews}', label: 'Profile Views'),
                const SizedBox(width: 10),
                _Stat(icon: Icons.local_offer, color: MC.orange, value: '${biz.offerViews}', label: 'Offer Views'),
                const SizedBox(width: 10),
                _Stat(icon: Icons.people, color: const Color(0xFF8B5CF6), value: '${biz.customers}', label: 'Customers'),
              ]),
              const SizedBox(height: 18),
              Row(children: [
                _Action(
                  icon: Icons.add_box,
                  label: 'Add New Offer',
                  filled: true,
                  onTap: () => _go(context, const AddOfferScreen()),
                ),
                const SizedBox(width: 10),
                _Action(
                  icon: Icons.list_alt,
                  label: 'Manage Offers',
                  onTap: () => _go(context, const ManageOffersScreen()),
                ),
              ]),
              const SizedBox(height: 10),
              Row(children: [
                _Action(
                  icon: Icons.store,
                  label: 'Business Profile',
                  iconColor: MC.orange,
                  onTap: () => _go(context, const BusinessProfileScreen()),
                ),
                const SizedBox(width: 10),
                _Action(
                  icon: Icons.insights,
                  label: 'See Analytics',
                  iconColor: MC.green,
                  onTap: () => _go(context, const AnalyticsScreen()),
                ),
              ]),
              const SizedBox(height: 10),
              Row(children: [
                _Action(
                  icon: Icons.qr_code_scanner,
                  label: 'Verify Offer Code',
                  iconColor: MC.blue,
                  onTap: () => _go(context, const VerifyCodeScreen()),
                ),
                const SizedBox(width: 10),
                _Action(
                  icon: Icons.groups_outlined,
                  label: 'Customers',
                  iconColor: const Color(0xFF8B5CF6),
                  onTap: () => _go(context, const CustomersScreen()),
                ),
              ]),
              const SizedBox(height: 20),
              const Text('Recent Redemptions', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              if (biz.redemptions.isEmpty) const MEmpty(icon: Icons.history, text: 'No redemptions yet'),
              for (final r in biz.redemptions.take(5))
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const CircleAvatar(
                      backgroundColor: Color(0xFFE8F6EE), child: Icon(Icons.check, color: MC.green)),
                  title: Text(r.customer, style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text('${r.code} • ${r.offer}', maxLines: 1, overflow: TextOverflow.ellipsis),
                  trailing: Text(timeAgo(r.time), style: const TextStyle(fontSize: 11, color: MC.sub)),
                ),
            ],
          ),
        ),
      );
}

class _Stat extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String value, label;
  const _Stat({required this.icon, required this.color, required this.value, required this.label});
  @override
  Widget build(BuildContext context) => Expanded(
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: MC.line),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 4),
              Flexible(
                child: Text(value,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: color)),
              ),
            ]),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(fontSize: 11, color: MC.sub)),
          ]),
        ),
      );
}

class _Action extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool filled;
  final Color? iconColor;
  final VoidCallback onTap;
  const _Action({required this.icon, required this.label, required this.onTap, this.filled = false, this.iconColor});
  @override
  Widget build(BuildContext context) => Expanded(
        child: Material(
          color: filled ? MC.blue : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: filled ? MC.blue : MC.line),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: onTap,
            child: SizedBox(
              height: 46,
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(icon, size: 18, color: filled ? Colors.white : (iconColor ?? MC.text)),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(label,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w600, color: filled ? Colors.white : MC.text)),
                ),
              ]),
            ),
          ),
        ),
      );
}
