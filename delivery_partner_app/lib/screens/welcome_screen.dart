import 'package:flutter/material.dart';
import '../theme.dart';
import 'dashboard_screen.dart';

class PartnerWelcomeScreen extends StatelessWidget {
  const PartnerWelcomeScreen({super.key});

  void _open(BuildContext c) =>
      Navigator.pushReplacement(c, MaterialPageRoute(builder: (_) => const PartnerDashboardScreen()));

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
            children: [
              const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                MLogo(icon: Icons.inventory_2_outlined, color: Color(0xFF2F6FB3), size: 32),
                SizedBox(width: 8),
                Text('Meeloc Partner', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
              ]),
              const SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset('assets/images/delivery_partner.png', height: 210, fit: BoxFit.cover),
              ),
              const SizedBox(height: 22),
              const Center(
                child: Text('Deliver with Meeloc', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
              ),
              const SizedBox(height: 4),
              const Center(child: Text('Earn on Your Schedule', style: TextStyle(fontSize: 15, color: MC.sub))),
              const SizedBox(height: 24),
              MPrimaryButton(label: 'Register as Delivery Partner', onTap: () => _open(context)),
              const SizedBox(height: 12),
              MOutlineButton(label: 'Login', onTap: () => _open(context)),
            ],
          ),
        ),
      );
}
