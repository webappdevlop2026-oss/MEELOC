import 'package:flutter/material.dart';
import '../theme.dart';
import '../data.dart';
import '../state.dart';
import '../widgets.dart';
import 'account_pages.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});
  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: app,
        builder: (context, _) {
          final items = app.cart.entries.toList();
          return Scaffold(
            appBar: AppBar(title: const Text('My Cart')),
            body: items.isEmpty
                ? const MEmpty(icon: Icons.shopping_bag_outlined, text: 'Your cart is empty')
                : ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      for (final e in items) _CartRow(p: productById(e.key), qty: e.value),
                      const SizedBox(height: 12),
                      _row('Items (${app.cartCount})', rupee(app.cartTotal)),
                      _row('Delivery', 'FREE', color: MC.green),
                      const Divider(),
                      _row('Total', rupee(app.cartTotal), bold: true),
                    ],
                  ),
            bottomNavigationBar: items.isEmpty
                ? null
                : SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                      child: MPrimaryButton(
                        label: 'Checkout • ${rupee(app.cartTotal)}',
                        onTap: () => push(context, const CheckoutScreen()),
                      ),
                    ),
                  ),
          );
        },
      );
}

Widget _row(String a, String b, {bool bold = false, Color? color}) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(children: [
        Text(a, style: TextStyle(fontWeight: bold ? FontWeight.w700 : FontWeight.w400, fontSize: bold ? 16 : 14)),
        const Spacer(),
        Text(b,
            style: TextStyle(
                fontWeight: bold ? FontWeight.w700 : FontWeight.w500, fontSize: bold ? 16 : 14, color: color)),
      ]),
    );

class _CartRow extends StatelessWidget {
  final Product p;
  final int qty;
  const _CartRow({required this.p, required this.qty});
  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: MC.line)),
        child: Row(children: [
          SizedBox(width: 64, child: ProductImage(p: p, height: 64)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(p.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(p.price, style: const TextStyle(fontWeight: FontWeight.w700)),
            ]),
          ),
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: MC.line)),
            child: Row(children: [
              InkWell(
                onTap: () => app.setQty(p.id, qty - 1),
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Icon(qty == 1 ? Icons.delete_outline : Icons.remove, size: 18),
                ),
              ),
              Text('$qty', style: const TextStyle(fontWeight: FontWeight.w700)),
              InkWell(
                onTap: () => app.setQty(p.id, qty + 1),
                child: const Padding(padding: EdgeInsets.all(6), child: Icon(Icons.add, size: 18)),
              ),
            ]),
          ),
        ]),
      );
}

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});
  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int addr = 0;

  void _place() {
    if (app.addresses.isEmpty) {
      mSnack(context, 'Please add a delivery address');
      return;
    }
    final o = app.placeOrder(app.addresses[addr < app.addresses.length ? addr : 0]);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => OrderSuccessScreen(orderId: o.id, total: o.total)),
      (r) => r.isFirst,
    );
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: app,
        builder: (context, _) => Scaffold(
          appBar: AppBar(title: const Text('Checkout')),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(children: [
                const Text('Delivery Address', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                const Spacer(),
                TextButton.icon(
                  onPressed: () => push(context, const AddressesScreen()),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add'),
                ),
              ]),
              if (app.addresses.isEmpty) const Text('No address added', style: TextStyle(color: MC.sub)),
              for (int i = 0; i < app.addresses.length; i++)
                _Choice(
                  selected: addr == i,
                  title: app.name,
                  subtitle: app.addresses[i],
                  onTap: () => setState(() => addr = i),
                ),
              const Divider(height: 28),
              const Text('Payment Method', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              for (final m in paymentMethods)
                _Choice(
                  selected: app.payment == m.$2,
                  icon: m.$1,
                  title: m.$2,
                  onTap: () => app.setPayment(m.$2),
                ),
              const Divider(height: 28),
              _row('Items (${app.cartCount})', rupee(app.cartTotal)),
              _row('Delivery', 'FREE', color: MC.green),
              _row('Total', rupee(app.cartTotal), bold: true),
            ],
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: MPrimaryButton(label: 'Place Order', onTap: _place),
            ),
          ),
        ),
      );
}

class OrderSuccessScreen extends StatelessWidget {
  final String orderId;
  final int total;
  const OrderSuccessScreen({super.key, required this.orderId, required this.total});
  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Icon(Icons.check_circle, color: MC.green, size: 90),
              const SizedBox(height: 16),
              const Text('Order Placed!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
              const SizedBox(height: 6),
              Text('Order #$orderId • ${rupee(total)}', style: const TextStyle(color: MC.sub)),
              const SizedBox(height: 30),
              MPrimaryButton(
                label: 'View My Orders',
                onTap: () => Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => const OrdersScreen())),
              ),
              const SizedBox(height: 12),
              MOutlineButton(label: 'Continue Shopping', onTap: () => Navigator.pop(context)),
            ]),
          ),
        ),
      );
}

class _Choice extends StatelessWidget {
  final bool selected;
  final String title;
  final String? subtitle;
  final IconData? icon;
  final VoidCallback onTap;
  const _Choice({required this.selected, required this.title, required this.onTap, this.subtitle, this.icon});
  @override
  Widget build(BuildContext context) => ListTile(
        contentPadding: EdgeInsets.zero,
        onTap: onTap,
        leading: Icon(selected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
            color: selected ? MC.green : MC.sub),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: subtitle == null ? null : Text(subtitle!),
        trailing: icon == null ? null : Icon(icon),
      );
}
