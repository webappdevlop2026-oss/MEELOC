import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme.dart';
import '../state.dart';

class OrdersListScreen extends StatelessWidget {
  final String kind; // new | ongoing | completed
  const OrdersListScreen({super.key, required this.kind});

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: partner,
        builder: (context, _) {
          final list = switch (kind) {
            'new' => partner.newOrders,
            'ongoing' => partner.ongoing,
            _ => partner.completed,
          };
          final title = switch (kind) { 'new' => 'New Orders', 'ongoing' => 'Ongoing Orders', _ => 'Completed Orders' };
          return Scaffold(
            appBar: AppBar(title: Text(title)),
            body: list.isEmpty
                ? MEmpty(
                    icon: Icons.inbox_outlined,
                    text: kind == 'new' && !partner.online ? 'Go online to get new orders' : 'No orders here')
                : ListView(
                    padding: const EdgeInsets.all(16),
                    children: [for (final o in list) _OrderCard(o: o)],
                  ),
          );
        },
      );
}

class _OrderCard extends StatelessWidget {
  final DOrder o;
  const _OrderCard({required this.o});
  @override
  Widget build(BuildContext context) => InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => OrderDetailScreen(o: o))),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: MC.line)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Text('#${o.id}', style: const TextStyle(fontWeight: FontWeight.w700)),
              const Spacer(),
              Text('₹${o.earning}', style: const TextStyle(fontWeight: FontWeight.w800, color: MC.green, fontSize: 16)),
            ]),
            const SizedBox(height: 8),
            _line(Icons.storefront_outlined, o.shop, o.shopAddress),
            const SizedBox(height: 6),
            _line(Icons.location_on_outlined, o.customer, o.customerAddress),
            const SizedBox(height: 8),
            Row(children: [
              Text('${o.km} km • ₹${o.amount} • ${o.statusText}', style: const TextStyle(fontSize: 12, color: MC.sub)),
            ]),
            if (o.status == OStatus.newOrder) ...[
              const SizedBox(height: 10),
              Row(children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => partner.setStatus(o, OStatus.rejected),
                    style: OutlinedButton.styleFrom(foregroundColor: MC.red, side: const BorderSide(color: MC.red)),
                    child: const Text('Reject'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      partner.setStatus(o, OStatus.accepted);
                      mSnack(context, 'Order accepted – go to ${o.shop}');
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: MC.green, foregroundColor: Colors.white),
                    child: const Text('Accept'),
                  ),
                ),
              ]),
            ],
          ]),
        ),
      );

  Widget _line(IconData i, String a, String b) => Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(i, size: 18, color: MC.sub),
        const SizedBox(width: 8),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(a, style: const TextStyle(fontWeight: FontWeight.w600)),
            Text(b, style: const TextStyle(fontSize: 12, color: MC.sub)),
          ]),
        ),
      ]);
}

class OrderDetailScreen extends StatelessWidget {
  final DOrder o;
  const OrderDetailScreen({super.key, required this.o});

  Future<void> _open(BuildContext c, String url) async {
    try {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } catch (_) {
      if (c.mounted) mSnack(c, 'Could not open');
    }
  }

  void _deliver(BuildContext context) {
    final otp = TextEditingController();
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Customer OTP'),
        content: TextField(
          controller: otp,
          keyboardType: TextInputType.number,
          maxLength: 4,
          decoration: const InputDecoration(hintText: '4 digit OTP', helperText: 'Demo OTP: 1234'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              if (otp.text != '1234') {
                mSnack(context, 'Wrong OTP');
                return;
              }
              partner.setStatus(o, OStatus.delivered);
              Navigator.pop(c);
              mSnack(context, 'Delivered! ₹${o.earning} added to earnings');
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: partner,
        builder: (context, _) {
          const steps = ['Accepted', 'Picked up', 'Delivered'];
          final step = switch (o.status) {
            OStatus.accepted => 0,
            OStatus.pickedUp => 1,
            OStatus.delivered => 2,
            _ => -1,
          };
          return Scaffold(
            appBar: AppBar(title: Text('Order #${o.id}')),
            body: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (step >= 0)
                  Row(children: [
                    for (int i = 0; i < steps.length; i++) ...[
                      Column(children: [
                        CircleAvatar(
                          radius: 14,
                          backgroundColor: i <= step ? MC.green : MC.line,
                          child: const Icon(Icons.check, size: 16, color: Colors.white),
                        ),
                        const SizedBox(height: 4),
                        Text(steps[i], style: const TextStyle(fontSize: 11)),
                      ]),
                      if (i < steps.length - 1)
                        Expanded(child: Container(height: 2, color: i < step ? MC.green : MC.line)),
                    ],
                  ]),
                const SizedBox(height: 16),
                _card('Pickup from', o.shop, o.shopAddress, Icons.storefront, () => _open(context,
                    'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent('${o.shop} ${o.shopAddress}')}')),
                _card('Deliver to', o.customer, o.customerAddress, Icons.location_on, () => _open(context,
                    'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(o.customerAddress)}')),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: MC.line)),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('Items', style: TextStyle(color: MC.sub, fontSize: 12)),
                    Text(o.items, style: const TextStyle(fontWeight: FontWeight.w600)),
                    const Divider(height: 20),
                    Row(children: [
                      const Text('Collect (COD)'),
                      const Spacer(),
                      Text('₹${o.amount}', style: const TextStyle(fontWeight: FontWeight.w700)),
                    ]),
                    const SizedBox(height: 4),
                    Row(children: [
                      const Text('Your earning'),
                      const Spacer(),
                      Text('₹${o.earning}', style: const TextStyle(fontWeight: FontWeight.w700, color: MC.green)),
                    ]),
                  ]),
                ),
                const SizedBox(height: 12),
                if (o.status != OStatus.delivered && o.status != OStatus.rejected)
                  MOutlineButton(
                      label: 'Call Customer', icon: Icons.call_outlined, onTap: () => _open(context, 'tel:${o.phone}')),
              ],
            ),
            bottomNavigationBar: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: switch (o.status) {
                  OStatus.newOrder => MPrimaryButton(label: 'Accept Order', onTap: () => partner.setStatus(o, OStatus.accepted)),
                  OStatus.accepted =>
                    MPrimaryButton(label: 'Picked Up from Shop', color: MC.blue, onTap: () => partner.setStatus(o, OStatus.pickedUp)),
                  OStatus.pickedUp => MPrimaryButton(label: 'Mark as Delivered', onTap: () => _deliver(context)),
                  OStatus.delivered => const Text('Delivered ✓',
                      textAlign: TextAlign.center, style: TextStyle(color: MC.green, fontWeight: FontWeight.w700, fontSize: 16)),
                  OStatus.rejected => const Text('Rejected',
                      textAlign: TextAlign.center, style: TextStyle(color: MC.red, fontWeight: FontWeight.w700, fontSize: 16)),
                },
              ),
            ),
          );
        },
      );

  Widget _card(String label, String a, String b, IconData icon, VoidCallback nav) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: MC.line)),
        child: Row(children: [
          Icon(icon, color: MC.green),
          const SizedBox(width: 10),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(label, style: const TextStyle(fontSize: 12, color: MC.sub)),
              Text(a, style: const TextStyle(fontWeight: FontWeight.w700)),
              Text(b, style: const TextStyle(fontSize: 12)),
            ]),
          ),
          IconButton(onPressed: nav, icon: const Icon(Icons.directions, color: MC.blue)),
        ]),
      );
}
