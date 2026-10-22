import 'package:flutter/material.dart';
import 'theme.dart';
import 'state.dart';
import 'main.dart' show menu;

String _fmt(int n) {
  final s = n.toString();
  return s.length > 3 ? '${s.substring(0, s.length - 3)},${s.substring(s.length - 3)}' : s;
}

class Dashboard extends StatelessWidget {
  final ValueChanged<int?> onOpen;
  final bool wide;
  const Dashboard({super.key, required this.onOpen, required this.wide});

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: admin,
        builder: (context, _) {
          final stats = [
            (Icons.person, const Color(0xFF7C5CFC), const Color(0xFFF1EDFF), 'Total Users', admin.totalUsers, 6),
            (Icons.storefront, const Color(0xFF22B07D), const Color(0xFFE6F7F0), 'Businesses', admin.totalBusinesses, 0),
            (Icons.delivery_dining, const Color(0xFFE5488A), const Color(0xFFFDEBF3), 'Delivery Partners', admin.totalPartners, 2),
            (Icons.local_offer, const Color(0xFFF26A3D), const Color(0xFFFEEEE8), 'Total Offers', admin.totalOffers, 1),
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
                    InkWell(
                      onTap: () => onOpen(s.$6),
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
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
                                Text(s.$4,
                                    style: const TextStyle(fontSize: 12, color: MC.text),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis),
                                Text(_fmt(s.$5), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                              ],
                            ),
                          ),
                        ]),
                      ),
                    ),
                ],
              ),
              if (admin.pending > 0) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: const Color(0xFFFFF4E5), borderRadius: BorderRadius.circular(10)),
                  child: Row(children: [
                    const Icon(Icons.pending_actions, color: MC.orange),
                    const SizedBox(width: 10),
                    Expanded(child: Text('${admin.pending} approvals pending')),
                    TextButton(onPressed: () => onOpen(0), child: const Text('Review')),
                  ]),
                ),
              ],
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: MC.line)),
                clipBehavior: Clip.antiAlias,
                child: Column(children: [
                  for (int i = 0; i < 6; i++) MMenuTile(icon: menu[i].$1, title: menu[i].$2, onTap: () => onOpen(i)),
                ]),
              ),
            ],
          );
        },
      );
}

Widget sectionView(int i) => switch (i) {
      0 => ItemSection(key: const ValueKey(0), title: 'Manage Businesses', list: () => admin.businesses, kind: 'approve', addLabel: 'Business'),
      1 => ItemSection(key: const ValueKey(1), title: 'Manage Offers', list: () => admin.offers, kind: 'toggle'),
      2 => ItemSection(key: const ValueKey(2), title: 'Manage Delivery Partners', list: () => admin.partners, kind: 'approve', addLabel: 'Partner'),
      3 => ItemSection(key: const ValueKey(3), title: 'Advertisements', list: () => admin.ads, kind: 'toggle', addLabel: 'Advertisement'),
      4 => const AnalyticsSection(),
      5 => const SettingsSection(),
      _ => ItemSection(key: const ValueKey(6), title: 'Users', list: () => admin.users, kind: 'block'),
    };

Color statusColor(String s) => switch (s) {
      'Approved' || 'Active' => MC.green,
      'Pending' || 'Paused' => MC.orange,
      _ => MC.red,
    };

/// Generic searchable list with status filter and actions.
class ItemSection extends StatefulWidget {
  final String title;
  final List<Item> Function() list;
  final String kind; // approve | toggle | block
  final String? addLabel;
  const ItemSection({super.key, required this.title, required this.list, required this.kind, this.addLabel});
  @override
  State<ItemSection> createState() => _ItemSectionState();
}

class _ItemSectionState extends State<ItemSection> {
  String q = '';
  String filter = 'All';

  void _add() {
    final name = TextEditingController();
    final sub = TextEditingController();
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: Text('Add ${widget.addLabel}'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: name, decoration: const InputDecoration(labelText: 'Name / Title')),
          TextField(controller: sub, decoration: const InputDecoration(labelText: 'Details')),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              if (name.text.trim().isEmpty) return;
              admin.add(
                widget.list(),
                Item(DateTime.now().millisecondsSinceEpoch.toString(), name.text.trim(), sub.text.trim(),
                    widget.kind == 'approve' ? 'Approved' : 'Active'),
              );
              Navigator.pop(c);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  List<Widget> _actions(Item it) {
    Widget btn(String label, Color c, VoidCallback f) =>
        TextButton(onPressed: f, child: Text(label, style: TextStyle(color: c)));
    final del = IconButton(
      tooltip: 'Delete',
      icon: const Icon(Icons.delete_outline, color: MC.red),
      onPressed: () async {
        if (await mConfirm(context, 'Delete', 'Delete "${it.name}"?', ok: 'Delete')) {
          admin.remove(widget.list(), it);
        }
      },
    );
    switch (widget.kind) {
      case 'approve':
        return [
          if (it.status != 'Approved') btn('Approve', MC.green, () => admin.setStatus(it, 'Approved')),
          if (it.status != 'Blocked') btn('Block', MC.red, () => admin.setStatus(it, 'Blocked')),
          del,
        ];
      case 'toggle':
        return [
          Switch(
            value: it.status == 'Active',
            activeTrackColor: MC.green,
            onChanged: (v) => admin.setStatus(it, v ? 'Active' : 'Paused'),
          ),
          del,
        ];
      default:
        return [
          it.status == 'Blocked'
              ? btn('Unblock', MC.green, () => admin.setStatus(it, 'Active'))
              : btn('Block', MC.red, () => admin.setStatus(it, 'Blocked')),
        ];
    }
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: admin,
        builder: (context, _) {
          final all = widget.list();
          final statuses = {'All', ...all.map((e) => e.status)}.toList();
          final items = all
              .where((e) => filter == 'All' || e.status == filter)
              .where((e) => q.isEmpty || '${e.name} ${e.sub} ${e.extra}'.toLowerCase().contains(q))
              .toList();
          return Scaffold(
            floatingActionButton: widget.addLabel == null
                ? null
                : FloatingActionButton.extended(
                    backgroundColor: MC.green,
                    foregroundColor: Colors.white,
                    onPressed: _add,
                    icon: const Icon(Icons.add),
                    label: Text('Add ${widget.addLabel}'),
                  ),
            body: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
              children: [
                Text('${widget.title} (${all.length})', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                MSearchBar(hint: 'Search...', onChanged: (v) => setState(() => q = v.toLowerCase())),
                const SizedBox(height: 10),
                Wrap(spacing: 8, children: [
                  for (final s in statuses)
                    ChoiceChip(
                      label: Text(s),
                      selected: filter == s,
                      selectedColor: const Color(0xFFD9F2E3),
                      onSelected: (_) => setState(() => filter = s),
                    ),
                ]),
                const SizedBox(height: 10),
                if (items.isEmpty) const MEmpty(icon: Icons.search_off, text: 'Nothing found'),
                for (final it in items)
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), side: const BorderSide(color: MC.line)),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(14, 8, 6, 8),
                      child: Row(children: [
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(it.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                            Text([it.sub, it.extra].where((e) => e.isNotEmpty).join(' • '),
                                style: const TextStyle(fontSize: 12, color: MC.sub)),
                            const SizedBox(height: 4),
                            Text(it.status,
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w600, color: statusColor(it.status))),
                          ]),
                        ),
                        ..._actions(it),
                      ]),
                    ),
                  ),
              ],
            ),
          );
        },
      );
}

class AnalyticsSection extends StatelessWidget {
  const AnalyticsSection({super.key});
  static const months = ['May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct'];
  static const signups = [120, 180, 210, 260, 230, 245];
  static const claims = [340, 420, 510, 640, 700, 892];

  Widget _bars(String title, List<int> data, Color c) {
    final mx = data.reduce((a, b) => a > b ? a : b);
    return Container(
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: MC.line)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        SizedBox(
          height: 170,
          child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
            for (int i = 0; i < data.length; i++)
              Expanded(
                child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                  Text('${data[i]}', style: const TextStyle(fontSize: 11, color: MC.sub)),
                  const SizedBox(height: 4),
                  Container(
                    height: 120 * data[i] / mx,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: i == data.length - 1 ? c : c.withValues(alpha: .35),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(months[i], style: const TextStyle(fontSize: 11)),
                ]),
              ),
          ]),
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Analytics & Reports', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          _bars('New users per month', signups, const Color(0xFF7C5CFC)),
          _bars('Offer claims per month', claims, MC.green),
          OutlinedButton.icon(
            onPressed: () => mSnack(context, 'Report export will be available after backend setup'),
            icon: const Icon(Icons.download),
            label: const Text('Export report (CSV)'),
          ),
        ],
      );
}

class SettingsSection extends StatefulWidget {
  const SettingsSection({super.key});
  @override
  State<SettingsSection> createState() => _SettingsSectionState();
}

class _SettingsSectionState extends State<SettingsSection> {
  late final name = TextEditingController(text: admin.appName);
  late final comm = TextEditingController(text: admin.commission);
  late final areas = TextEditingController(text: admin.serviceAreas);
  late final email = TextEditingController(text: admin.supportEmail);
  late bool signups = admin.newSignups;

  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Settings', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
          MField(label: 'App Name', controller: name),
          MField(label: 'Commission (%)', controller: comm, keyboard: TextInputType.number),
          MField(label: 'Service Areas (comma separated)', controller: areas, maxLines: 2),
          MField(label: 'Support Email', controller: email),
          const SizedBox(height: 8),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: signups,
            activeTrackColor: MC.green,
            title: const Text('Allow new business & partner signups'),
            onChanged: (v) => setState(() => signups = v),
          ),
          const SizedBox(height: 16),
          MPrimaryButton(
            label: 'Save Settings',
            onTap: () {
              admin.saveSettings(
                name: name.text.trim().isEmpty ? 'Meeloc' : name.text.trim(),
                comm: comm.text.trim(),
                areas: areas.text.trim(),
                email: email.text.trim(),
                signups: signups,
              );
              mSnack(context, 'Settings saved');
            },
          ),
        ],
      );
}
