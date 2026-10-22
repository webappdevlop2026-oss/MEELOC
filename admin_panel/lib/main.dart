import 'package:flutter/material.dart';
import 'theme.dart';
import 'state.dart';
import 'sections.dart';

void main() => runApp(const MeelocAdminApp());

class MeelocAdminApp extends StatelessWidget {
  const MeelocAdminApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Meeloc Admin',
        debugShowCheckedModeBanner: false,
        theme: meelocTheme(),
        home: ListenableBuilder(
          listenable: admin,
          builder: (_, __) => admin.loggedIn ? const AdminHome() : const AdminLogin(),
        ),
      );
}

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});
  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  final email = TextEditingController(text: 'admin@meeloc.in');
  final pass = TextEditingController();
  bool hide = true;

  void _login() {
    // Demo only: replace with real authentication (Firebase Auth / backend) before going live.
    if (email.text.trim().isEmpty || pass.text.length < 4) {
      mSnack(context, 'Enter email and password (demo: any 4+ characters)');
      return;
    }
    admin.login();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: MC.adminNavy,
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      MLogo(size: 34),
                      SizedBox(width: 10),
                      Text('Meeloc Admin', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                    ]),
                    const SizedBox(height: 24),
                    TextField(
                      controller: email,
                      decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: pass,
                      obscureText: hide,
                      onSubmitted: (_) => _login(),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(hide ? Icons.visibility_off : Icons.visibility),
                          onPressed: () => setState(() => hide = !hide),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    MPrimaryButton(label: 'Login', onTap: _login),
                  ]),
                ),
              ),
            ),
          ),
        ),
      );
}

const menu = [
  (Icons.store_outlined, 'Manage Businesses'),
  (Icons.verified_outlined, 'Manage Offers'),
  (Icons.groups_outlined, 'Manage Delivery Partners'),
  (Icons.campaign_outlined, 'Advertisements'),
  (Icons.bar_chart_outlined, 'Analytics & Reports'),
  (Icons.settings_outlined, 'Settings'),
  (Icons.person_outline, 'Users'),
];

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});
  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  int? section; // null = dashboard

  void _open(int? i) => setState(() => section = i);

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.of(context).size.width >= 900;
    final body = section == null ? Dashboard(onOpen: _open, wide: wide) : sectionView(section!);
    final header = Container(
      color: MC.adminNavy,
      padding: EdgeInsets.fromLTRB(16, MediaQuery.of(context).padding.top + 14, 8, 14),
      child: Row(children: [
        if (section != null && !wide)
          IconButton(onPressed: () => _open(null), icon: const Icon(Icons.arrow_back, color: Colors.white)),
        const MLogo(icon: Icons.storefront, size: 30),
        const SizedBox(width: 10),
        ListenableBuilder(
          listenable: admin,
          builder: (_, __) => Text('${admin.appName} Admin',
              style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
        ),
        const Spacer(),
        PopupMenuButton<String>(
          icon: const CircleAvatar(
              radius: 16, backgroundColor: Colors.white24, child: Icon(Icons.person, color: Colors.white, size: 18)),
          onSelected: (v) => v == 'logout' ? admin.logout() : _open(5),
          itemBuilder: (_) => const [
            PopupMenuItem(value: 'settings', child: Text('Settings')),
            PopupMenuItem(value: 'logout', child: Text('Logout')),
          ],
        ),
      ]),
    );

    final page = PopScope(
      canPop: section == null,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _open(null);
      },
      child: body,
    );

    if (!wide) return Scaffold(body: Column(children: [header, Expanded(child: page)]));
    return Scaffold(
      body: Column(children: [
        header,
        Expanded(
          child: Row(children: [
            Container(
              width: 250,
              decoration: const BoxDecoration(border: Border(right: BorderSide(color: MC.line))),
              child: ListView(children: [
                ListTile(
                  selected: section == null,
                  selectedColor: MC.green,
                  leading: const Icon(Icons.dashboard_outlined),
                  title: const Text('Dashboard'),
                  onTap: () => _open(null),
                ),
                for (int i = 0; i < menu.length; i++)
                  ListTile(
                    selected: section == i,
                    selectedColor: MC.green,
                    leading: Icon(menu[i].$1),
                    title: Text(menu[i].$2),
                    onTap: () => _open(i),
                  ),
              ]),
            ),
            Expanded(child: page),
          ]),
        ),
      ]),
    );
  }
}
