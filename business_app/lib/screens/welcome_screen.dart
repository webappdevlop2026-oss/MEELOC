import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme.dart';
import '../state.dart';
import 'dashboard_screen.dart';

const bizCategories = ['Grocery', 'Restaurant', 'Electronics', 'Fashion', 'Beauty', 'Pharmacy', 'Home Service', 'Other'];

void openDashboard(BuildContext c) => Navigator.pushAndRemoveUntil(
    c, MaterialPageRoute(builder: (_) => const BusinessDashboardScreen()), (_) => false);

class BusinessWelcomeScreen extends StatelessWidget {
  const BusinessWelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
            children: [
              const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                MLogo(icon: Icons.storefront, size: 32),
                SizedBox(width: 8),
                Text('Meeloc ', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: MC.green)),
                Text('Business', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: MC.text)),
              ]),
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: MC.bg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: MC.line),
                ),
                child: const Row(children: [
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Grow Your Business\nwith Meeloc',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, height: 1.25)),
                      SizedBox(height: 8),
                      Text('List your shop, create offers\nand reach more customers.',
                          style: TextStyle(fontSize: 13, color: MC.sub)),
                    ]),
                  ),
                  Icon(Icons.storefront_rounded, size: 64, color: MC.orange),
                ]),
              ),
              const SizedBox(height: 28),
              MPrimaryButton(
                label: 'Register Your Business',
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen())),
              ),
              const SizedBox(height: 12),
              MOutlineButton(
                label: 'Login to Business Panel',
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BizLoginScreen())),
              ),
              const SizedBox(height: 28),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Text('Already have an account? ', style: TextStyle(color: MC.sub, fontSize: 13)),
                GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BizLoginScreen())),
                  child: const Text('Login', style: TextStyle(color: MC.blue, fontSize: 13, fontWeight: FontWeight.w600)),
                ),
              ]),
            ],
          ),
        ),
      );
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final shop = TextEditingController();
  final owner = TextEditingController();
  final phone = TextEditingController();
  final address = TextEditingController();
  String cat = 'Grocery';

  void _submit() {
    if (shop.text.trim().isEmpty || owner.text.trim().isEmpty || phone.text.length != 10 || address.text.trim().isEmpty) {
      mSnack(context, 'Please fill all fields (10 digit phone)');
      return;
    }
    biz.register(
      shop: shop.text.trim(),
      ownerName: owner.text.trim(),
      ph: phone.text,
      cat: cat,
      addr: address.text.trim(),
    );
    openDashboard(context);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Register Your Business')),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          children: [
            MField(label: 'Shop / Business Name', controller: shop, hint: 'e.g. Fresh Mart Grocery'),
            MField(label: 'Owner Name', controller: owner),
            MField(label: 'Mobile Number', controller: phone, keyboard: TextInputType.phone, hint: '10 digit'),
            const Padding(
              padding: EdgeInsets.only(top: 14, bottom: 6),
              child: Text('Category', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            ),
            Wrap(spacing: 8, runSpacing: 8, children: [
              for (final c in bizCategories)
                ChoiceChip(
                  label: Text(c),
                  selected: cat == c,
                  selectedColor: const Color(0xFFD9F2E3),
                  onSelected: (_) => setState(() => cat = c),
                ),
            ]),
            MField(label: 'Shop Address', controller: address, maxLines: 2, hint: 'Street, Town, PIN'),
            const SizedBox(height: 24),
            MPrimaryButton(label: 'Register & Continue', onTap: _submit),
          ],
        ),
      );
}

class BizLoginScreen extends StatefulWidget {
  const BizLoginScreen({super.key});
  @override
  State<BizLoginScreen> createState() => _BizLoginScreenState();
}

class _BizLoginScreenState extends State<BizLoginScreen> {
  final phone = TextEditingController();
  final otp = TextEditingController();
  bool sent = false;

  void _go() {
    if (!sent) {
      if (phone.text.length != 10) {
        mSnack(context, 'Enter a valid 10 digit mobile number');
        return;
      }
      setState(() => sent = true);
      mSnack(context, 'OTP sent (Demo OTP: 1234)');
      return;
    }
    if (otp.text != '1234') {
      mSnack(context, 'Wrong OTP. Demo OTP: 1234');
      return;
    }
    biz.phone = phone.text;
    biz.login();
    openDashboard(context);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Business Login')),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextField(
              controller: phone,
              enabled: !sent,
              keyboardType: TextInputType.phone,
              maxLength: 10,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                prefixText: '+91  ',
                labelText: 'Mobile number',
                counterText: '',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            if (sent) ...[
              const SizedBox(height: 14),
              TextField(
                controller: otp,
                keyboardType: TextInputType.number,
                maxLength: 4,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  labelText: 'OTP',
                  helperText: 'Demo OTP: 1234',
                  counterText: '',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
            const SizedBox(height: 20),
            MPrimaryButton(label: sent ? 'Verify & Login' : 'Send OTP', onTap: _go),
          ],
        ),
      );
}
