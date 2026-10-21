import 'package:flutter/material.dart';
import '../theme.dart';
import '../data.dart';
import 'add_offer_screen.dart';

class ManageOffersScreen extends StatelessWidget {
  const ManageOffersScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(centerTitle: false, title: const Text('Manage Offers')),
        floatingActionButton: FloatingActionButton(
          backgroundColor: MC.green,
          foregroundColor: Colors.white,
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddOfferScreen())),
          child: const Icon(Icons.add),
        ),
        body: ValueListenableBuilder<List<Offer>>(
          valueListenable: offers,
          builder: (_, list, __) => ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: list.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (_, i) {
              final o = list[i];
              return Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: MC.line)),
                child: Row(children: [
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(o.title, style: const TextStyle(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Text(o.description, style: const TextStyle(fontSize: 12, color: MC.sub)),
                      const SizedBox(height: 4),
                      Text('Valid till ${o.validTill}', style: const TextStyle(fontSize: 12, color: MC.red)),
                    ]),
                  ),
                  Switch(
                    value: o.active,
                    activeTrackColor: MC.green,
                    onChanged: (v) {
                      o.active = v;
                      offers.value = [...list];
                    },
                  ),
                ]),
              );
            },
          ),
        ),
      );
}
