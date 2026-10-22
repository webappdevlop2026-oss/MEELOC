import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme.dart';
import '../state.dart';
import '../main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1600), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => app.loggedIn ? const CustomerShell() : const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) => const Scaffold(
        backgroundColor: MC.green,
        body: Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            CircleAvatar(
              radius: 44,
              backgroundColor: Colors.white,
              child: Icon(Icons.location_on_rounded, color: MC.green, size: 54),
            ),
            SizedBox(height: 16),
            Text('Meeloc', style: TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.w800)),
            SizedBox(height: 4),
            Text('Local Deals • Online Offers', style: TextStyle(color: Colors.white70, fontSize: 14)),
            SizedBox(height: 40),
            SizedBox(width: 26, height: 26, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5)),
          ]),
        ),
      );
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final phone = TextEditingController();

  void _next() {
    if (phone.text.length != 10) {
      mSnack(context, 'Enter a valid 10 digit mobile number');
      return;
    }
    Navigator.push(context, MaterialPageRoute(builder: (_) => OtpScreen(phone: phone.text)));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
            children: [
              const Row(children: [
                Icon(Icons.location_on_rounded, color: MC.green, size: 40),
                Text('Meeloc', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800)),
              ]),
              const SizedBox(height: 30),
              const Text('Login / Sign up', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              const Text('Enter your mobile number to receive an OTP', style: TextStyle(color: MC.sub)),
              const SizedBox(height: 24),
              TextField(
                controller: phone,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  prefixText: '+91  ',
                  hintText: 'Mobile number',
                  counterText: '',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onSubmitted: (_) => _next(),
              ),
              const SizedBox(height: 20),
              MPrimaryButton(label: 'Send OTP', onTap: _next),
              const SizedBox(height: 16),
              const Text('By continuing you agree to our Terms & Privacy Policy.',
                  textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: MC.sub)),
            ],
          ),
        ),
      );
}

class OtpScreen extends StatefulWidget {
  final String phone;
  const OtpScreen({super.key, required this.phone});
  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final otp = TextEditingController();

  void _verify() {
    if (otp.text != '1234') {
      mSnack(context, 'Wrong OTP. Demo OTP: 1234');
      return;
    }
    app.login(widget.phone);
    Navigator.pushAndRemoveUntil(
        context, MaterialPageRoute(builder: (_) => const CustomerShell()), (_) => false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(),
        body: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const Text('OTP Verify', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text('OTP sent to +91 ${widget.phone}', style: const TextStyle(color: MC.sub)),
            const SizedBox(height: 24),
            TextField(
              controller: otp,
              keyboardType: TextInputType.number,
              maxLength: 4,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 26, letterSpacing: 18, fontWeight: FontWeight.w700),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                counterText: '',
                hintText: '••••',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onChanged: (v) {
                if (v.length == 4) _verify();
              },
            ),
            const SizedBox(height: 8),
            const Text('Demo OTP: 1234', textAlign: TextAlign.center, style: TextStyle(color: MC.green)),
            const SizedBox(height: 20),
            MPrimaryButton(label: 'Verify & Continue', onTap: _verify),
            TextButton(onPressed: () => mSnack(context, 'OTP resent'), child: const Text('Resend OTP')),
          ],
        ),
      );
}
