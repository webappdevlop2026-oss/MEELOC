import 'package:flutter/material.dart';
import '../theme.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});
  @override
  Widget build(BuildContext context) {
    const items = [
      (Icons.receipt_long_outlined, 'My Orders'),
      (Icons.local_offer_outlined, 'My Offers'),
      (Icons.favorite_border, 'Saved Offers'),
      (Icons.location_on_outlined, 'My Addresses'),
      (Icons.credit_card_outlined, 'Payment Methods'),
      (Icons.group_add_outlined, 'Refer & Earn'),
      (Icons.help_outline, 'Help & Support'),
      (Icons.logout, 'Logout'),
    ];
    return Container(
      color: MC.bg,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
        children: [
          Row(children: [
            const Text('My Account', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
            const Spacer(),
            IconButton(onPressed: () => mSnack(context, 'Settings'), icon: const Icon(Icons.settings)),
          ]),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: const Row(children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: Color(0xFF5B8DEF),
                child: Text('S', style: TextStyle(color: Colors.white, fontSize: 24)),
              ),
              SizedBox(width: 14),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Sangita Das', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                SizedBox(height: 2),
                Text('sangita@example.com', style: TextStyle(fontSize: 12, color: MC.sub)),
              ]),
            ]),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            clipBehavior: Clip.antiAlias,
            child: Column(children: [
              for (final it in items) MMenuTile(icon: it.$1, title: it.$2),
            ]),
          ),
        ],
      ),
    );
  }
}
