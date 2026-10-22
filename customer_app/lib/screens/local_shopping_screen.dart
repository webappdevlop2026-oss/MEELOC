import 'package:flutter/material.dart';
import '../theme.dart';
import '../data.dart';
import '../state.dart';
import '../widgets.dart';
import 'home_screen.dart';

class LocalShoppingScreen extends StatefulWidget {
  final String initial;
  const LocalShoppingScreen({super.key, this.initial = 'All'});
  @override
  State<LocalShoppingScreen> createState() => _LocalShoppingScreenState();
}

class _LocalShoppingScreenState extends State<LocalShoppingScreen> {
  static const filters = [
    'All', 'Grocery', 'Restaurant', 'Electronics', 'Fashion', 'Beauty', 'Pharmacy', 'Home Service'
  ];
  late String sel = filters.contains(widget.initial) ? widget.initial : 'All';
  String q = '';
  String sort = 'Nearest';

  double _km(String d) {
    final v = double.tryParse(d.split(' ').first) ?? 0;
    return d.contains('km') ? v : v / 1000;
  }

  @override
  Widget build(BuildContext context) {
    var list = shops
        .where((s) => sel == 'All' || s.category == sel)
        .where((s) => q.isEmpty || '${s.name} ${s.category} ${s.offerNote}'.toLowerCase().contains(q))
        .toList();
    list.sort((a, b) => sort == 'Nearest' ? _km(a.distance).compareTo(_km(b.distance)) : b.rating.compareTo(a.rating));
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 64,
        title: ListenableBuilder(
          listenable: app,
          builder: (_, __) => Column(mainAxisSize: MainAxisSize.min, children: [
            const Text('Local Shopping'),
            InkWell(
              onTap: () => showLocationPicker(context),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.location_on, size: 13, color: MC.green),
                Text(' ${app.location}',
                    style: const TextStyle(fontSize: 12, color: MC.sub, fontWeight: FontWeight.w400)),
              ]),
            ),
          ]),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort),
            initialValue: sort,
            onSelected: (v) => setState(() => sort = v),
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'Nearest', child: Text('Nearest first')),
              PopupMenuItem(value: 'Top Rated', child: Text('Top rated')),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
        children: [
          MSearchBar(hint: 'Search local shops, offers...', onChanged: (v) => setState(() => q = v.toLowerCase())),
          const SizedBox(height: 12),
          SizedBox(
            height: 34,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                for (final f in filters)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => setState(() => sel = f),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: sel == f ? MC.green : Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: sel == f ? MC.green : MC.line),
                        ),
                        child: Text(f,
                            style: TextStyle(
                                fontSize: 13, color: sel == f ? Colors.white : MC.text, fontWeight: FontWeight.w500)),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          if (list.isEmpty) const MEmpty(icon: Icons.store_outlined, text: 'No shops found'),
          for (final s in list) ShopCard(shop: s),
        ],
      ),
    );
  }
}
