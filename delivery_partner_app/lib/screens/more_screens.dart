import 'package:flutter/material.dart';
import '../theme.dart';
import '../state.dart';

class EarningsScreen extends StatelessWidget {
  const EarningsScreen({super.key});

  void _withdraw(BuildContext context) {
    final amt = TextEditingController(text: '${partner.balance}');
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Withdraw to bank'),
        content: TextField(
          controller: amt,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(prefixText: '₹ '),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              final err = partner.withdraw(int.tryParse(amt.text) ?? 0);
              if (err != null) {
                mSnack(context, err);
                return;
              }
              Navigator.pop(c);
              mSnack(context, 'Withdrawal requested – credited in 24 hours');
            },
            child: const Text('Withdraw'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: partner,
        builder: (context, _) => Scaffold(
          appBar: AppBar(title: const Text('Earnings')),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  gradient: const LinearGradient(colors: [Color(0xFF138A3E), Color(0xFF2DB04F)]),
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Available Balance', style: TextStyle(color: Colors.white70)),
                  Text('₹${partner.balance}',
                      style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 10),
                  Row(children: [
                    Text("Today ₹${partner.todayEarnings}", style: const TextStyle(color: Colors.white)),
                    const SizedBox(width: 16),
                    Text('Total ₹${partner.totalEarnings}', style: const TextStyle(color: Colors.white)),
                  ]),
                ]),
              ),
              const SizedBox(height: 14),
              MPrimaryButton(label: 'Withdraw to Bank', onTap: () => _withdraw(context)),
              const SizedBox(height: 20),
              const Text('History', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              for (final o in partner.completed)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const CircleAvatar(
                      backgroundColor: Color(0xFFE8F6EE), child: Icon(Icons.delivery_dining, color: MC.green)),
                  title: Text('#${o.id} • ${o.shop}'),
                  subtitle: Text(o.doneAt == null ? '' : _date(o.doneAt!)),
                  trailing: Text('+₹${o.earning}',
                      style: const TextStyle(color: MC.green, fontWeight: FontWeight.w700)),
                ),
            ],
          ),
        ),
      );

  String _date(DateTime d) =>
      '${d.day}/${d.month}/${d.year} ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: partner,
        builder: (context, _) => Scaffold(
          appBar: AppBar(title: const Text('Profile & Documents')),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: MC.green,
                  child: Text(partner.name[0], style: const TextStyle(color: Colors.white, fontSize: 26)),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(partner.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                    Text('+91 ${partner.phone}', style: const TextStyle(color: MC.sub)),
                    Text(partner.vehicle, style: const TextStyle(color: MC.sub, fontSize: 12)),
                  ]),
                ),
              ]),
              const SizedBox(height: 20),
              const Text('Documents', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              for (final d in partner.docs)
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), side: const BorderSide(color: MC.line)),
                  child: ListTile(
                    leading: Icon(Icons.description_outlined, color: d.uploaded ? MC.green : MC.orange),
                    title: Text(d.name),
                    subtitle: Text(d.uploaded ? 'Verified' : 'Pending upload',
                        style: TextStyle(color: d.uploaded ? MC.green : MC.orange)),
                    trailing: d.uploaded
                        ? const Icon(Icons.verified, color: MC.green)
                        : TextButton(
                            onPressed: () {
                              partner.uploadDoc(d);
                              mSnack(context, '${d.name} uploaded – under review');
                            },
                            child: const Text('Upload'),
                          ),
                  ),
                ),
            ],
          ),
        ),
      );
}
