import 'package:flutter/material.dart';
import 'theme.dart';

void main() => runApp(const MeelocAdminApp());

class MeelocAdminApp extends StatelessWidget {
  const MeelocAdminApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Meeloc Admin',
        debugShowCheckedModeBanner: false,
        theme: meelocTheme(),
        home: const AdminHome(),
      );
}

const _menu = [
  (Icons.store_outlined, 'Manage Businesses'),
  (Icons.verified_outlined, 'Manage Offers'),
  (Icons.groups_outlined, 'Manage Delivery Partners'),
  (Icons.campaign_outlined, 'Advertisements'),
  (Icons.bar_chart_outlined, 'Analytics & Reports'),
  (Icons.settings_outlined, 'Settings'),
];

/// Web + mobile responsive admin panel.
class AdminHome extends StatefulWidget {
  const AdminHome({super.key});
  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  int? section; // null = dashboard

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.of(context).size.width >= 900;
    final body = section == null ? _Dashboard(onOpen: (i) => setState(() => section = i), wide: wide) : _Section(index: section!);
    final header = Container(
      color: MC.adminNavy,
      padding: EdgeInsets.fromLTRB(16, MediaQuery.of(context).padding.top + 14, 16, 14),
      child: Row(children: [
        if (section != null && !wide)
          IconButton(
            onPressed: () => setState(() => section = null),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
        const MLogo(icon: Icons.storefront, size: 30),
        const SizedBox(width: 10),
        const Text('Meeloc Admin', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
        const Spacer(),
        const CircleAvatar(radius: 16, backgroundColor: Colors.white24, child: Icon(Icons.person, color: Colors.white, size: 18)),
      ]),
    );

    if (!wide) {
      return Scaffold(body: Column(children: [header, Expanded(child: body)]));
    }
    return Scaffold(
      body: Column(children: [
        header,
        Expanded(
          child: Row(children: [
            Container(
              width: 250,
              decoration: const BoxDecoration(border: Border(right: BorderSide(color: MC.line))),
              child: ListView(children: [
                ListTile(
                  selected: section == null,
                  selectedColor: MC.green,
                  leading: const Icon(Icons.dashboard_outlined),
                  title: const Text('Dashboard'),
                  onTap: () => setState(() => section = null),
                ),
                for (int i = 0; i < _menu.length; i++)
                  ListTile(
                    selected: section == i,
                    selectedColor: MC.green,
                    leading: Icon(_menu[i].$1),
                    title: Text(_menu[i].$2),
                    onTap: () => setState(() => section = i),
                  ),
              ]),
            ),
            Expanded(child: body),
          ]),
        ),
      ]),
    );
  }
}

class _Dashboard extends StatelessWidget {
  final ValueChanged<int> onOpen;
  final bool wide;
  const _Dashboard({required this.onOpen, required this.wide});

  @override
  Widget build(BuildContext context) {
    const stats = [
      (Icons.person, Color(0xFF7C5CFC), Color(0xFFF1EDFF), 'Total Users', '1,245'),
      (Icons.storefront, Color(0xFF22B07D), Color(0xFFE6F7F0), 'Businesses', '328'),
      (Icons.delivery_dining, Color(0xFFE5488A), Color(0xFFFDEBF3), 'Delivery Partners', '156'),
      (Icons.local_offer, Color(0xFFF26A3D), Color(0xFFFEEEE8), 'Total Offers', '892'),
    ];
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        GridView.count(
          crossAxisCount: wide ? 4 : 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: wide ? 2.6 : 2.0,
          children: [
            for (final s in stats)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: s.$3, borderRadius: BorderRadius.circular(10)),
                child: Row(children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(color: s.$2, borderRadius: BorderRadius.circular(8)),
                    child: Icon(s.$1, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(s.$4, style: const TextStyle(fontSize: 12, color: MC.text), maxLines: 1, overflow: TextOverflow.ellipsis),
                        Text(s.$5, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                ]),
              ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: MC.line)),
          clipBehavior: Clip.antiAlias,
          child: Column(children: [
            for (int i = 0; i < _menu.length; i++)
              MMenuTile(icon: _menu[i].$1, title: _menu[i].$2, onTap: () => onOpen(i)),
          ]),
        ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  final int index;
  const _Section({required this.index});

  @override
  Widget build(BuildContext context) {
    final title = _menu[index].$2;
    final rows = switch (index) {
      0 => ['Fresh Mart Grocery', 'Bapi Electronics', 'Tasty Bite Restaurant', 'Style Salon'],
      1 => ['20% OFF – Fresh Mart', '10% OFF – Bapi Electronics', 'Flat 15% OFF – Tasty Bite', '30% OFF – Style Salon'],
      2 => ['Rahul Mondal', 'Sourav Ghosh', 'Amit Sheikh', 'Bikash Roy'],
      3 => ['Home Banner – Local Deals', 'Online – Big Billion'],
      4 => ['Daily Report', 'Weekly Report', 'Monthly Report'],
      _ => ['App Name', 'Service Area', 'Commission %', 'Notifications'],
    };
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        for (final r in rows)
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: const BorderSide(color: MC.line)),
            child: ListTile(
              title: Text(r),
              trailing: index <= 2
                  ? Row(mainAxisSize: MainAxisSize.min, children: [
                      TextButton(onPressed: () => mSnack(context, '$r approved'), child: const Text('Approve')),
                      TextButton(
                        onPressed: () => mSnack(context, '$r blocked'),
                        child: const Text('Block', style: TextStyle(color: MC.red)),
                      ),
                    ])
                  : const Icon(Icons.chevron_right),
            ),
          ),
      ],
    );
  }
}
