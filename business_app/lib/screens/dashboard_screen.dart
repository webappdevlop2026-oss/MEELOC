import 'package:flutter/material.dart';
import '../theme.dart';
import 'add_offer_screen.dart';
import 'manage_offers_screen.dart';

class BusinessDashboardScreen extends StatelessWidget {
  const BusinessDashboardScreen({super.key});

  void _go(BuildContext c, Widget w) => Navigator.push(c, MaterialPageRoute(builder: (_) => w));

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(centerTitle: false, title: const Text('Business Dashboard')),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 6, 16, 20),
          children: [
            Row(children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset('assets/images/store_thumb.png', width: 90, height: 72, fit: BoxFit.cover),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Fresh Mart Grocery', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Row(children: [
                    const Icon(Icons.star_rounded, color: MC.star, size: 16),
                    const Text(' 4.5', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: MC.green, borderRadius: BorderRadius.circular(5)),
                      child: const Text('Active', style: TextStyle(color: Colors.white, fontSize: 11)),
                    ),
                  ]),
                  const SizedBox(height: 4),
                  const Row(children: [
                    Text('4.5 (120)', style: TextStyle(fontSize: 12, color: MC.sub)),
                    Spacer(),
                    Icon(Icons.location_on_outlined, size: 13, color: MC.sub),
                    Text('Dubrajpur', style: TextStyle(fontSize: 12, color: MC.sub)),
                  ]),
                ]),
              ),
            ]),
            const SizedBox(height: 18),
            const Row(children: [
              _Stat(icon: Icons.visibility, color: MC.blue, value: '125', label: 'Profile Views'),
              SizedBox(width: 10),
              _Stat(icon: Icons.local_offer, color: MC.orange, value: '48', label: 'Offer Views'),
              SizedBox(width: 10),
              _Stat(icon: Icons.people, color: Color(0xFF8B5CF6), value: '32', label: 'Customers'),
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
                onTap: () => mSnack(context, 'Business Profile'),
              ),
              const SizedBox(width: 10),
              _Action(
                icon: Icons.insights,
                label: 'See Analytics',
                iconColor: MC.green,
                onTap: () => mSnack(context, 'Analytics'),
              ),
            ]),
          ],
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
              Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: color)),
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
                Text(label,
                    style: TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600, color: filled ? Colors.white : MC.text)),
              ]),
            ),
          ),
        ),
      );
}
