import 'package:flutter/material.dart';
import '../theme.dart';
import '../state.dart';
import 'order_screens.dart';
import 'more_screens.dart';
import 'welcome_screen.dart';

class PartnerDashboardScreen extends StatelessWidget {
  const PartnerDashboardScreen({super.key});

  void _go(BuildContext c, Widget w) => Navigator.push(c, MaterialPageRoute(builder: (_) => w));

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: partner,
        builder: (context, _) => Scaffold(
          appBar: AppBar(
            centerTitle: false,
            title: const Text('Partner Dashboard'),
            actions: [
              Text(partner.online ? 'Online' : 'Offline',
                  style: TextStyle(
                      fontSize: 13, color: partner.online ? MC.green : MC.sub, fontWeight: FontWeight.w600)),
              Switch(value: partner.online, activeTrackColor: MC.green, onChanged: partner.setOnline),
              const SizedBox(width: 6),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 6, 16, 20),
            children: [
              if (!partner.online)
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: const Color(0xFFFFF4E5), borderRadius: BorderRadius.circular(10)),
                  child: const Row(children: [
                    Icon(Icons.info_outline, color: MC.orange),
                    SizedBox(width: 8),
                    Expanded(child: Text('You are offline. Go online to receive new orders.')),
                  ]),
                ),
              Row(children: [
                _Tile(
                    icon: Icons.inventory_2,
                    color: MC.blue,
                    value: '${partner.todayDone.length + partner.ongoing.length}',
                    label: "Today's Orders"),
                const SizedBox(width: 10),
                _Tile(
                    icon: Icons.currency_rupee,
                    color: MC.blue,
                    value: '₹${partner.todayEarnings}',
                    label: "Today's Earnings",
                    noIcon: true),
              ]),
              const SizedBox(height: 10),
              Row(children: [
                _Tile(icon: Icons.verified, color: MC.green, value: '${partner.completed.length}', label: 'Total Deliveries'),
                const SizedBox(width: 10),
                _Tile(icon: Icons.local_fire_department, color: MC.orange, value: '${partner.rating}', label: 'Rating'),
              ]),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: MC.line)),
                clipBehavior: Clip.antiAlias,
                child: Column(children: [
                  MMenuTile(
                    icon: Icons.receipt_outlined,
                    title: 'New Orders',
                    badge: partner.newOrders.isEmpty ? null : partner.newOrders.length,
                    onTap: () => _go(context, const OrdersListScreen(kind: 'new')),
                  ),
                  MMenuTile(
                    icon: Icons.local_shipping_outlined,
                    title: 'Ongoing Orders',
                    badge: partner.ongoing.isEmpty ? null : partner.ongoing.length,
                    onTap: () => _go(context, const OrdersListScreen(kind: 'ongoing')),
                  ),
                  MMenuTile(
                    icon: Icons.check,
                    title: 'Completed Orders',
                    onTap: () => _go(context, const OrdersListScreen(kind: 'completed')),
                  ),
                  MMenuTile(
                    icon: Icons.account_balance_wallet_outlined,
                    title: 'Earnings',
                    onTap: () => _go(context, const EarningsScreen()),
                  ),
                  MMenuTile(
                    icon: Icons.person_outline,
                    title: 'Profile & Documents',
                    onTap: () => _go(context, const ProfileScreen()),
                  ),
                  MMenuTile(
                    icon: Icons.logout,
                    title: 'Logout',
                    onTap: () async {
                      if (await mConfirm(context, 'Logout', 'Logout from partner app?', ok: 'Logout')) {
                        partner.logout();
                        if (context.mounted) {
                          Navigator.pushAndRemoveUntil(
                              context, MaterialPageRoute(builder: (_) => const PartnerWelcomeScreen()), (_) => false);
                        }
                      }
                    },
                  ),
                ]),
              ),
            ],
          ),
        ),
      );
}

class _Tile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String value, label;
  final bool noIcon;
  const _Tile({required this.icon, required this.color, required this.value, required this.label, this.noIcon = false});
  @override
  Widget build(BuildContext context) => Expanded(
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: MC.bg,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: MC.line),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              if (!noIcon) ...[Icon(icon, size: 18, color: color), const SizedBox(width: 6)],
              Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: color)),
            ]),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(fontSize: 12, color: MC.sub)),
          ]),
        ),
      );
}
