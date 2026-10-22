import 'package:flutter/material.dart';
import '../theme.dart';
import '../state.dart';

/// Add a new offer, or edit [editing] when given.
class AddOfferScreen extends StatefulWidget {
  final Offer? editing;
  const AddOfferScreen({super.key, this.editing});
  @override
  State<AddOfferScreen> createState() => _AddOfferScreenState();
}

class _AddOfferScreenState extends State<AddOfferScreen> {
  late final e = widget.editing;
  late final title = TextEditingController(text: e?.title ?? '');
  late final desc = TextEditingController(text: e?.description ?? '');
  late final value = TextEditingController(text: e == null ? '' : e!.value.toStringAsFixed(0));
  late String type = e?.type ?? 'Percentage Discount';
  late DateTime valid = _parse(e?.validTill) ?? DateTime.now().add(const Duration(days: 10));
  late final dateCtrl = TextEditingController(text: _fmt(valid));

  static DateTime? _parse(String? s) {
    if (s == null) return null;
    final p = s.split('-');
    if (p.length != 3) return null;
    return DateTime(int.parse(p[2]), int.parse(p[1]), int.parse(p[0]));
  }

  static String _fmt(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}-${d.month.toString().padLeft(2, '0')}-${d.year}';

  void _publish() {
    final v = double.tryParse(value.text);
    if (title.text.trim().isEmpty) {
      mSnack(context, 'Please enter offer title');
      return;
    }
    if (type != 'Buy 1 Get 1' && (v == null || v <= 0 || (type == 'Percentage Discount' && v > 100))) {
      mSnack(context, 'Please enter a valid discount value');
      return;
    }
    if (e != null) {
      e!
        ..title = title.text.trim()
        ..description = desc.text.trim()
        ..type = type
        ..value = v ?? 0
        ..validTill = _fmt(valid);
      biz.updated();
      mSnack(context, 'Offer updated');
    } else {
      biz.addOffer(Offer(
        title: title.text.trim(),
        description: desc.text.trim(),
        type: type,
        value: v ?? 0,
        validTill: _fmt(valid),
      ));
      mSnack(context, 'Offer published!');
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
            centerTitle: false, title: Text(e == null ? 'Add New Offer' : 'Edit Offer', style: const TextStyle(fontSize: 16))),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          children: [
            MField(label: 'Offer Title', controller: title, hint: '20% OFF on All Grocery Items'),
            MField(label: 'Description', controller: desc, maxLines: 2, hint: 'Get 20% discount on all grocery items.'),
            const Padding(
              padding: EdgeInsets.only(top: 14, bottom: 6),
              child: Text('Discount Type', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            ),
            DropdownButtonFormField<String>(
              // ignore: deprecated_member_use
              value: type,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: MC.line)),
              ),
              items: const [
                DropdownMenuItem(value: 'Percentage Discount', child: Text('Percentage Discount')),
                DropdownMenuItem(value: 'Flat Discount', child: Text('Flat Discount (₹)')),
                DropdownMenuItem(value: 'Buy 1 Get 1', child: Text('Buy 1 Get 1')),
              ],
              onChanged: (v) => setState(() => type = v!),
            ),
            if (type != 'Buy 1 Get 1')
              MField(
                label: 'Discount Value',
                controller: value,
                keyboard: TextInputType.number,
                hint: '20',
                suffix: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Text(type == 'Flat Discount' ? '₹' : '%', style: const TextStyle(color: MC.sub)),
                ),
              ),
            MField(
              label: 'Valid Till',
              controller: dateCtrl,
              readOnly: true,
              suffix: const Icon(Icons.calendar_month_outlined),
              onTap: () async {
                final d = await showDatePicker(
                  context: context,
                  initialDate: valid,
                  firstDate: DateTime.now().subtract(const Duration(days: 1)),
                  lastDate: DateTime(2035),
                );
                if (d != null) {
                  setState(() {
                    valid = d;
                    dateCtrl.text = _fmt(d);
                  });
                }
              },
            ),
            const SizedBox(height: 28),
            MPrimaryButton(label: e == null ? 'Publish Offer' : 'Save Changes', onTap: _publish),
          ],
        ),
      );
}
