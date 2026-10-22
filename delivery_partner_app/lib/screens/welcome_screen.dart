import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme.dart';
import '../state.dart';
import 'dashboard_screen.dart';

void openDashboard(BuildContext c) => Navigator.pushAndRemoveUntil(
    c, MaterialPageRoute(builder: (_) => const PartnerDashboardScreen()), (_) => false);

class PartnerWelcomeScreen extends StatelessWidget {
  const PartnerWelcomeScreen({super.key});

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
                  child: Text('Deliver with Meeloc', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700))),
              const SizedBox(height: 4),
              const Center(child: Text('Earn on Your Schedule', style: TextStyle(fontSize: 15, color: MC.sub))),
              const SizedBox(height: 24),
              MPrimaryButton(
                label: 'Register as Delivery Partner',
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PartnerRegisterScreen())),
              ),
              const SizedBox(height: 12),
              MOutlineButton(
                label: 'Login',
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PartnerLoginScreen())),
              ),
            ],
          ),
        ),
      );
}

class PartnerRegisterScreen extends StatefulWidget {
  const PartnerRegisterScreen({super.key});
  @override
  State<PartnerRegisterScreen> createState() => _PartnerRegisterScreenState();
}

class _PartnerRegisterScreenState extends State<PartnerRegisterScreen> {
  final name = TextEditingController();
  final phone = TextEditingController();
  final vehicleNo = TextEditingController();
  String vehicle = 'Scooter';

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Partner Registration')),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          children: [
            MField(label: 'Full Name', controller: name),
            MField(label: 'Mobile Number', controller: phone, keyboard: TextInputType.phone),
            const Padding(
              padding: EdgeInsets.only(top: 14, bottom: 6),
              child: Text('Vehicle Type', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            ),
            Wrap(spacing: 8, children: [
              for (final v in ['Bicycle', 'Scooter', 'Bike', 'E-Rickshaw'])
                ChoiceChip(
                  label: Text(v),
                  selected: vehicle == v,
                  selectedColor: const Color(0xFFD9F2E3),
                  onSelected: (_) => setState(() => vehicle = v),
                ),
            ]),
            MField(label: 'Vehicle Number', controller: vehicleNo, hint: 'WB 54 A 1234'),
            const SizedBox(height: 24),
            MPrimaryButton(
              label: 'Register & Continue',
              onTap: () {
                if (name.text.trim().isEmpty || phone.text.length != 10) {
                  mSnack(context, 'Enter name and 10 digit mobile number');
                  return;
                }
                partner.register(name.text.trim(), phone.text,
                    vehicleNo.text.trim().isEmpty ? vehicle : '$vehicle • ${vehicleNo.text.trim().toUpperCase()}');
                openDashboard(context);
              },
            ),
          ],
        ),
      );
}

class PartnerLoginScreen extends StatefulWidget {
  const PartnerLoginScreen({super.key});
  @override
  State<PartnerLoginScreen> createState() => _PartnerLoginScreenState();
}

class _PartnerLoginScreenState extends State<PartnerLoginScreen> {
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
    partner.phone = phone.text;
    partner.login();
    openDashboard(context);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Partner Login')),
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
