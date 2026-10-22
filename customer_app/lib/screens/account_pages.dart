import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme.dart';
import '../state.dart';
import '../widgets.dart';

const paymentMethods = [
  (Icons.payments_outlined, 'Cash on Delivery'),
  (Icons.qr_code_2, 'UPI (GPay / PhonePe / Paytm)'),
  (Icons.credit_card, 'Debit / Credit Card'),
];

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});
  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: app,
        builder: (context, _) => Scaffold(
          appBar: AppBar(title: const Text('My Orders')),
          body: app.orders.isEmpty
              ? const MEmpty(icon: Icons.receipt_long_outlined, text: 'No orders yet.\nShop online deals to place an order.')
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    for (final o in app.orders)
                      Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(14),
                        decoration:
                            BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: MC.line)),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Row(children: [
                            Text('Order #${o.id}', style: const TextStyle(fontWeight: FontWeight.w700)),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: o.status == 'Cancelled' ? const Color(0xFFFDECEC) : const Color(0xFFE8F6EE),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(o.status,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: o.status == 'Cancelled' ? MC.red : MC.green)),
                            ),
                          ]),
                          const SizedBox(height: 6),
                          for (final it in o.items)
                            Text('• ${it.$1.name} × ${it.$2}', style: const TextStyle(fontSize: 13)),
                          const SizedBox(height: 6),
                          Text('${rupee(o.total)} • ${o.payment}', style: const TextStyle(fontWeight: FontWeight.w600)),
                          Text(o.address, style: const TextStyle(fontSize: 12, color: MC.sub)),
                          if (o.status == 'Placed')
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () async {
                                  if (await mConfirm(context, 'Cancel order', 'Cancel order #${o.id}?')) {
                                    app.cancelOrder(o);
                                  }
                                },
                                child: const Text('Cancel Order', style: TextStyle(color: MC.red)),
                              ),
                            ),
                        ]),
                      ),
                  ],
                ),
        ),
      );
}

class MyOffersScreen extends StatelessWidget {
  const MyOffersScreen({super.key});
  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: app,
        builder: (context, _) => Scaffold(
          appBar: AppBar(title: const Text('My Offers')),
          body: app.claimed.isEmpty
              ? const MEmpty(icon: Icons.local_offer_outlined, text: 'No claimed offers yet.\nClaim an offer from a local shop.')
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    for (final c in app.claimed)
                      Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration:
                            BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: MC.line)),
                        child: Row(children: [
                          ShopImage(shop: c.shop, width: 64, height: 56),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text(c.shop.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                              Text('${c.shop.offer} • ${c.shop.offerNote}',
                                  style: const TextStyle(fontSize: 12, color: MC.red)),
                              const SizedBox(height: 4),
                              Text(c.code,
                                  style: const TextStyle(fontWeight: FontWeight.w800, color: MC.green, letterSpacing: 1)),
                            ]),
                          ),
                          IconButton(
                            icon: const Icon(Icons.copy, size: 20),
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: c.code));
                              mSnack(context, 'Code copied');
                            },
                          ),
                        ]),
                      ),
                  ],
                ),
        ),
      );
}

class AddressesScreen extends StatelessWidget {
  const AddressesScreen({super.key});

  void _add(BuildContext context) {
    final house = TextEditingController();
    final area = TextEditingController();
    final pin = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (c) => Padding(
        padding: EdgeInsets.fromLTRB(16, 0, 16, MediaQuery.of(c).viewInsets.bottom + 16),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('Add New Address', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          MField(label: 'House / Flat / Street', controller: house),
          MField(label: 'Area / Town', controller: area, hint: 'Dubrajpur, Birbhum'),
          MField(label: 'PIN Code', controller: pin, keyboard: TextInputType.number),
          const SizedBox(height: 16),
          MPrimaryButton(
            label: 'Save Address',
            onTap: () {
              if (house.text.trim().isEmpty || area.text.trim().isEmpty) {
                mSnack(c, 'Please fill house and area');
                return;
              }
              app.addAddress('${house.text.trim()}, ${area.text.trim()} ${pin.text.trim()}'.trim());
              Navigator.pop(c);
            },
          ),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: app,
        builder: (context, _) => Scaffold(
          appBar: AppBar(title: const Text('My Addresses')),
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: MC.green,
            foregroundColor: Colors.white,
            onPressed: () => _add(context),
            icon: const Icon(Icons.add),
            label: const Text('Add Address'),
          ),
          body: app.addresses.isEmpty
              ? const MEmpty(icon: Icons.location_off_outlined, text: 'No saved address')
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    for (int i = 0; i < app.addresses.length; i++)
                      Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10), side: const BorderSide(color: MC.line)),
                        child: ListTile(
                          leading: const Icon(Icons.home_outlined, color: MC.green),
                          title: Text(i == 0 ? 'Home' : 'Address ${i + 1}'),
                          subtitle: Text(app.addresses[i]),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline, color: MC.red),
                            onPressed: () => app.removeAddress(i),
                          ),
                        ),
                      ),
                  ],
                ),
        ),
      );
}

class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key});
  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: app,
        builder: (context, _) => Scaffold(
          appBar: AppBar(title: const Text('Payment Methods')),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text('Default payment method', style: TextStyle(color: MC.sub)),
              const SizedBox(height: 8),
              for (final m in paymentMethods)
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: app.payment == m.$2 ? MC.green : MC.line),
                  ),
                  child: ListTile(
                    leading: Icon(m.$1, color: MC.green),
                    title: Text(m.$2),
                    trailing: app.payment == m.$2 ? const Icon(Icons.check_circle, color: MC.green) : null,
                    onTap: () => app.setPayment(m.$2),
                  ),
                ),
            ],
          ),
        ),
      );
}

class ReferScreen extends StatelessWidget {
  const ReferScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final code = 'MEELOC${app.initial}${app.phone.isEmpty ? '2026' : app.phone.substring(app.phone.length - 4)}';
    return Scaffold(
      appBar: AppBar(title: const Text('Refer & Earn')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Icon(Icons.card_giftcard, size: 90, color: MC.orange),
          const SizedBox(height: 12),
          const Text('Invite friends, earn ₹50',
              textAlign: TextAlign.center, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          const Text('Your friend gets ₹50 off on first order, you get ₹50 Meeloc cash.',
              textAlign: TextAlign.center, style: TextStyle(color: MC.sub)),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF5EC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: MC.orange),
            ),
            child: Row(children: [
              const Text('Your code: ', style: TextStyle(color: MC.sub)),
              Text(code, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.copy),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: code));
                  mSnack(context, 'Code copied');
                },
              ),
            ]),
          ),
          const SizedBox(height: 20),
          MPrimaryButton(
            label: 'Copy Invite Message',
            onTap: () {
              Clipboard.setData(ClipboardData(
                  text: 'Meeloc app e local & online deals! Amar code $code use korle ₹50 off. https://meeloc.vercel.app'));
              mSnack(context, 'Invite message copied – paste in WhatsApp');
            },
          ),
        ],
      ),
    );
  }
}

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});
  static const faqs = [
    ('How do I claim a local offer?', 'Open a shop offer and tap "Claim Offer". Show the code at the shop counter.'),
    ('Is the offer valid online?', 'Local shop offers are valid in-store only unless mentioned.'),
    ('How do I cancel an order?', 'Go to Account → My Orders and tap "Cancel Order" before it is shipped.'),
    ('Which payment methods are available?', 'Cash on Delivery, UPI and Debit/Credit cards.'),
    ('How can I list my shop?', 'Download the Meeloc Business app and register your shop for free.'),
  ];
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Help & Support')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            for (final f in faqs)
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), side: const BorderSide(color: MC.line)),
                child: ExpansionTile(
                  shape: const Border(),
                  title: Text(f.$1, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                  children: [Text(f.$2, style: const TextStyle(color: MC.sub))],
                ),
              ),
            const SizedBox(height: 16),
            const ListTile(
              leading: Icon(Icons.email_outlined, color: MC.green),
              title: Text('support@meeloc.in'),
              subtitle: Text('We reply within 24 hours'),
            ),
          ],
        ),
      );
}

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final name = TextEditingController(text: app.name);
  late final email = TextEditingController(text: app.email);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Edit Profile')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            MField(label: 'Full Name', controller: name),
            MField(label: 'Email', controller: email, keyboard: TextInputType.emailAddress),
            const SizedBox(height: 24),
            MPrimaryButton(
              label: 'Save',
              onTap: () {
                if (name.text.trim().isEmpty) {
                  mSnack(context, 'Name cannot be empty');
                  return;
                }
                app.updateProfile(name.text.trim(), email.text.trim());
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
}
