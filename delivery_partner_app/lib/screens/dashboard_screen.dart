import 'package:flutter/material.dart';
import '../theme.dart';

class PartnerDashboardScreen extends StatefulWidget {
  const PartnerDashboardScreen({super.key});
  @override
  State<PartnerDashboardScreen> createState() => _PartnerDashboardScreenState();
}

class _PartnerDashboardScreenState extends State<PartnerDashboardScreen> {
  bool online = true;

  void _orders(String title, List<String> items) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: Text(title)),
            body: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                for (final o in items)
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), side: const BorderSide(color: MC.line)),
                    child: ListTile(
                      leading: const Icon(Icons.delivery_dining, color: MC.green),
                      title: Text(o),
                      subtitle: const Text('Dubrajpur · 1.2 km'),
                      trailing: const Icon(Icons.chevron_right),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: const Text('Partner Dashboard'),
          actions: [
            Text(online ? 'Online' : 'Offline',
                style: TextStyle(fontSize: 13, color: online ? MC.text : MC.sub, fontWeight: FontWeight.w500)),
            Switch(value: online, activeTrackColor: MC.green, onChanged: (v) => setState(() => online = v)),
            const SizedBox(width: 6),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 6, 16, 20),
          children: [
            const Row(children: [
              _Tile(icon: Icons.inventory_2, color: MC.blue, value: '5', label: "Today's Orders"),
              SizedBox(width: 10),
              _Tile(icon: Icons.currency_rupee, color: MC.blue, value: '₹320', label: "Today's Earnings", noIcon: true),
            ]),
            const SizedBox(height: 10),
            const Row(children: [
              _Tile(icon: Icons.verified, color: MC.green, value: '12', label: 'Total Deliveries'),
              SizedBox(width: 10),
              _Tile(icon: Icons.local_fire_department, color: MC.orange, value: '4.8', label: 'Rating'),
            ]),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: MC.line)),
              clipBehavior: Clip.antiAlias,
              child: Column(children: [
                MMenuTile(
                  icon: Icons.receipt_outlined,
                  title: 'New Orders',
                  badge: 2,
                  onTap: () => _orders('New Orders', ['Order #MLC1021', 'Order #MLC1022']),
                ),
                MMenuTile(
                  icon: Icons.local_shipping_outlined,
                  title: 'Ongoing Orders',
                  badge: 1,
                  onTap: () => _orders('Ongoing Orders', ['Order #MLC1019']),
                ),
                MMenuTile(
                  icon: Icons.check,
                  title: 'Completed Orders',
                  onTap: () => _orders('Completed Orders', [for (int i = 1; i <= 12; i++) 'Order #MLC10${i.toString().padLeft(2, '0')}']),
                ),
                const MMenuTile(icon: Icons.account_balance_wallet_outlined, title: 'Earnings'),
                const MMenuTile(icon: Icons.person_outline, title: 'Profile & Documents'),
              ]),
            ),
          ],
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
