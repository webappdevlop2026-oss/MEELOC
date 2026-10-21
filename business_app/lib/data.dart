import 'package:flutter/foundation.dart';

class Offer {
  final String title, description, type, validTill;
  final double value;
  bool active;
  Offer({
    required this.title,
    required this.description,
    required this.type,
    required this.value,
    required this.validTill,
    this.active = true,
  });
}

final ValueNotifier<List<Offer>> offers = ValueNotifier<List<Offer>>([
  Offer(
    title: '20% OFF on All Grocery Items',
    description: 'Get 20% discount on all grocery items.',
    type: 'Percentage Discount',
    value: 20,
    validTill: '31-10-2026',
  ),
]);
