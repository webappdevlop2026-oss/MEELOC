import 'package:flutter/material.dart';
import '../theme.dart';
import 'dashboard_screen.dart';

class BusinessWelcomeScreen extends StatelessWidget {
  const BusinessWelcomeScreen({super.key});

  void _open(BuildContext c) =>
      Navigator.pushReplacement(c, MaterialPageRoute(builder: (_) => const BusinessDashboardScreen()));

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
              MPrimaryButton(label: 'Register Your Business', onTap: () => _open(context)),
              const SizedBox(height: 12),
              MOutlineButton(label: 'Login to Business Panel', onTap: () => _open(context)),
              const SizedBox(height: 28),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Text('Already have an account? ', style: TextStyle(color: MC.sub, fontSize: 13)),
                GestureDetector(
                  onTap: () => _open(context),
                  child: const Text('Login',
                      style: TextStyle(color: MC.blue, fontSize: 13, fontWeight: FontWeight.w600)),
                ),
              ]),
            ],
          ),
        ),
      );
}
