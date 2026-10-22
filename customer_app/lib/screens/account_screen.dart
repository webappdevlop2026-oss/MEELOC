import 'package:flutter/material.dart';
import '../theme.dart';
import '../state.dart';
import '../widgets.dart';
import 'auth_screens.dart';
import 'account_pages.dart';

class AccountScreen extends StatelessWidget {
  final ValueChanged<int> onTab;
  const AccountScreen({super.key, required this.onTab});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: app,
      builder: (context, _) => Container(
        color: MC.bg,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
          children: [
            Row(children: [
              const Text('My Account', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
              const Spacer(),
              IconButton(onPressed: () => push(context, const EditProfileScreen()), icon: const Icon(Icons.settings)),
            ]),
            const SizedBox(height: 8),
            InkWell(
              onTap: () => push(context, const EditProfileScreen()),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                child: Row(children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: const Color(0xFF5B8DEF),
                    child: Text(app.initial, style: const TextStyle(color: Colors.white, fontSize: 24)),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(app.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 2),
                      Text(app.email, style: const TextStyle(fontSize: 12, color: MC.sub)),
                      if (app.phone.isNotEmpty)
                        Text('+91 ${app.phone}', style: const TextStyle(fontSize: 12, color: MC.sub)),
                    ]),
                  ),
                  const Icon(Icons.edit_outlined, size: 18, color: MC.sub),
                ]),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
              clipBehavior: Clip.antiAlias,
              child: Column(children: [
                MMenuTile(
                    icon: Icons.receipt_long_outlined,
                    title: 'My Orders',
                    onTap: () => push(context, const OrdersScreen())),
                MMenuTile(
                    icon: Icons.local_offer_outlined,
                    title: 'My Offers',
                    onTap: () => push(context, const MyOffersScreen())),
                MMenuTile(icon: Icons.favorite_border, title: 'Saved Offers', onTap: () => onTab(3)),
                MMenuTile(
                    icon: Icons.location_on_outlined,
                    title: 'My Addresses',
                    onTap: () => push(context, const AddressesScreen())),
                MMenuTile(
                    icon: Icons.credit_card_outlined,
                    title: 'Payment Methods',
                    onTap: () => push(context, const PaymentMethodsScreen())),
                MMenuTile(
                    icon: Icons.group_add_outlined,
                    title: 'Refer & Earn',
                    onTap: () => push(context, const ReferScreen())),
                MMenuTile(
                    icon: Icons.help_outline, title: 'Help & Support', onTap: () => push(context, const HelpScreen())),
                MMenuTile(
                  icon: Icons.logout,
                  title: 'Logout',
                  onTap: () async {
                    if (await mConfirm(context, 'Logout', 'Are you sure you want to logout?', ok: 'Logout')) {
                      app.logout();
                      if (context.mounted) {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (_) => const LoginScreen()), (_) => false);
                      }
                    }
                  },
                ),
              ]),
            ),
            const SizedBox(height: 16),
            const Center(child: Text('Meeloc v1.1.0', style: TextStyle(fontSize: 12, color: MC.sub))),
          ],
        ),
      ),
    );
  }
}
