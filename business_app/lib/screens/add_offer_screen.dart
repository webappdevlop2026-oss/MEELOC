import 'package:flutter/material.dart';
import '../theme.dart';
import '../data.dart';

class AddOfferScreen extends StatefulWidget {
  const AddOfferScreen({super.key});
  @override
  State<AddOfferScreen> createState() => _AddOfferScreenState();
}

class _AddOfferScreenState extends State<AddOfferScreen> {
  final title = TextEditingController(text: '20% OFF on All Grocery Items');
  final desc = TextEditingController(text: 'Get 20% discount on all grocery items.');
  final value = TextEditingController(text: '20');
  String type = 'Percentage Discount';
  DateTime valid = DateTime(2026, 10, 31);

  String get _date =>
      '${valid.day.toString().padLeft(2, '0')}-${valid.month.toString().padLeft(2, '0')}-${valid.year}';

  InputDecoration _dec({Widget? suffix}) => InputDecoration(
        isDense: true,
        suffixIcon: suffix,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: MC.line)),
        enabledBorder:
            OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: MC.line)),
      );

  Widget _label(String t) => Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 6),
        child: Text(t, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
      );

  void _publish() {
    if (title.text.trim().isEmpty) {
      mSnack(context, 'Offer title dite hobe');
      return;
    }
    offers.value = [
      Offer(
        title: title.text.trim(),
        description: desc.text.trim(),
        type: type,
        value: double.tryParse(value.text) ?? 0,
        validTill: _date,
      ),
      ...offers.value,
    ];
    mSnack(context, 'Offer published!');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(centerTitle: false, title: const Text('Add New Offer', style: TextStyle(fontSize: 16))),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          children: [
            _label('Offer Title'),
            TextField(controller: title, decoration: _dec()),
            _label('Description'),
            TextField(controller: desc, maxLines: 2, decoration: _dec()),
            _label('Discount Type'),
            DropdownButtonFormField<String>(
              value: type,
              decoration: _dec(),
              items: const [
                DropdownMenuItem(value: 'Percentage Discount', child: Text('Percentage Discount')),
                DropdownMenuItem(value: 'Flat Discount', child: Text('Flat Discount (₹)')),
                DropdownMenuItem(value: 'Buy 1 Get 1', child: Text('Buy 1 Get 1')),
              ],
              onChanged: (v) => setState(() => type = v!),
            ),
            _label('Discount Value'),
            TextField(
              controller: value,
              keyboardType: TextInputType.number,
              decoration: _dec(
                suffix: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Text(type == 'Flat Discount' ? '₹' : '%', style: const TextStyle(color: MC.sub)),
                ),
              ),
            ),
            _label('Valid Till'),
            TextField(
              readOnly: true,
              controller: TextEditingController(text: _date),
              decoration: _dec(suffix: const Icon(Icons.calendar_month_outlined)),
              onTap: () async {
                final d = await showDatePicker(
                  context: context,
                  initialDate: valid,
                  firstDate: DateTime(2025),
                  lastDate: DateTime(2030),
                );
                if (d != null) setState(() => valid = d);
              },
            ),
            const SizedBox(height: 28),
            MPrimaryButton(label: 'Publish Offer', onTap: _publish),
          ],
        ),
      );
}
