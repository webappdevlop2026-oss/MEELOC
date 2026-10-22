import 'package:flutter/material.dart';
import 'theme.dart';
import 'state.dart';
import 'screens/auth_screens.dart';
import 'screens/home_screen.dart';
import 'screens/offers_screen.dart';
import 'screens/categories_screen.dart';
import 'screens/saved_screen.dart';
import 'screens/account_screen.dart';

void main() => runApp(const MeelocCustomerApp());

class MeelocCustomerApp extends StatelessWidget {
  const MeelocCustomerApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Meeloc',
        debugShowCheckedModeBanner: false,
        theme: meelocTheme(),
        home: const SplashScreen(),
      );
}

class CustomerShell extends StatefulWidget {
  const CustomerShell({super.key});
  @override
  State<CustomerShell> createState() => CustomerShellState();
}

class CustomerShellState extends State<CustomerShell> {
  int index = 0;

  static const _items = [
    (Icons.home_outlined, Icons.home_rounded, 'Home'),
    (Icons.local_offer_outlined, Icons.local_offer, 'Offers'),
    (Icons.grid_view_outlined, Icons.grid_view_rounded, 'Categories'),
    (Icons.favorite_border, Icons.favorite, 'Saved'),
    (Icons.person_outline, Icons.person, 'Account'),
  ];

  void go(int i) => setState(() => index = i);

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(onTab: go),
      const OffersScreen(),
      const CategoriesScreen(),
      const SavedScreen(),
      AccountScreen(onTab: go),
    ];
    // Home tab is highlighted green, other tabs navy (as in the design).
    final active = index == 0 ? MC.green : MC.navy;
    return PopScope(
      canPop: index == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) go(0);
      },
      child: Scaffold(
        body: SafeArea(child: IndexedStack(index: index, children: pages)),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: MC.line))),
          child: SafeArea(
            top: false,
            child: SizedBox(
              height: 60,
              child: ListenableBuilder(
                listenable: app,
                builder: (_, __) => Row(
                  children: List.generate(_items.length, (i) {
                    final sel = i == index;
                    final it = _items[i];
                    final showDot = i == 3 && app.saved.isNotEmpty;
                    return Expanded(
                      child: InkWell(
                        onTap: () => go(i),
                        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Badge(
                            isLabelVisible: showDot,
                            label: Text('${app.saved.length}'),
                            child: Icon(sel ? it.$2 : it.$1, size: 24, color: sel ? active : MC.sub),
                          ),
                          const SizedBox(height: 3),
                          Text(it.$3,
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: sel ? FontWeight.w600 : FontWeight.w400,
                                  color: sel ? active : MC.sub)),
                        ]),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
