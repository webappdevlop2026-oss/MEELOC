import 'package:flutter/material.dart';
import '../theme.dart';
import '../state.dart';
import 'add_offer_screen.dart';

class ManageOffersScreen extends StatelessWidget {
  const ManageOffersScreen({super.key});

  void _go(BuildContext c, Widget w) => Navigator.push(c, MaterialPageRoute(builder: (_) => w));

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: biz,
        builder: (context, _) => Scaffold(
          appBar: AppBar(centerTitle: false, title: Text('Manage Offers (${biz.offers.length})')),
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: MC.green,
            foregroundColor: Colors.white,
            onPressed: () => _go(context, const AddOfferScreen()),
            icon: const Icon(Icons.add),
            label: const Text('New Offer'),
          ),
          body: biz.offers.isEmpty
              ? const MEmpty(icon: Icons.local_offer_outlined, text: 'No offers yet.\nTap "New Offer" to create one.')
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
                  itemCount: biz.offers.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, i) {
                    final o = biz.offers[i];
                    return Container(
                      padding: const EdgeInsets.all(14),
                      decoration:
                          BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: MC.line)),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(color: MC.red, borderRadius: BorderRadius.circular(5)),
                            child: Text(o.label,
                                style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
                          ),
                          const Spacer(),
                          Text(o.active ? 'Live' : 'Paused',
                              style: TextStyle(fontSize: 12, color: o.active ? MC.green : MC.sub)),
                          Switch(
                            value: o.active,
                            activeTrackColor: MC.green,
                            onChanged: (v) {
                              o.active = v;
                              biz.updated();
                            },
                          ),
                        ]),
                        Text(o.title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                        if (o.description.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(o.description, style: const TextStyle(fontSize: 12, color: MC.sub)),
                        ],
                        const SizedBox(height: 8),
                        Row(children: [
                          const Icon(Icons.visibility_outlined, size: 15, color: MC.sub),
                          Text(' ${o.views}  ', style: const TextStyle(fontSize: 12)),
                          const Icon(Icons.people_outline, size: 15, color: MC.sub),
                          Text(' ${o.claims}  ', style: const TextStyle(fontSize: 12)),
                          const Spacer(),
                          Text('Till ${o.validTill}', style: const TextStyle(fontSize: 12, color: MC.red)),
                        ]),
                        const Divider(height: 20),
                        Row(children: [
                          TextButton.icon(
                            onPressed: () => _go(context, AddOfferScreen(editing: o)),
                            icon: const Icon(Icons.edit_outlined, size: 18),
                            label: const Text('Edit'),
                          ),
                          const Spacer(),
                          TextButton.icon(
                            onPressed: () async {
                              if (await mConfirm(context, 'Delete offer', 'Delete "${o.title}"?', ok: 'Delete')) {
                                biz.deleteOffer(o);
                              }
                            },
                            icon: const Icon(Icons.delete_outline, size: 18, color: MC.red),
                            label: const Text('Delete', style: TextStyle(color: MC.red)),
                          ),
                        ]),
                      ]),
                    );
                  },
                ),
        ),
      );
}
