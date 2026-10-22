import 'package:flutter/material.dart';

class Offer {
  String title, description, type, validTill;
  double value;
  bool active;
  int views, claims;
  Offer({
    required this.title,
    required this.description,
    required this.type,
    required this.value,
    required this.validTill,
    this.active = true,
    this.views = 0,
    this.claims = 0,
  });
  String get label => type == 'Percentage Discount'
      ? '${value.toStringAsFixed(0)}% OFF'
      : type == 'Flat Discount'
          ? '₹${value.toStringAsFixed(0)} OFF'
          : 'Buy 1 Get 1';
}

class Redemption {
  final String code, customer, offer;
  final DateTime time;
  Redemption(this.code, this.customer, this.offer, this.time);
}

/// Business (seller) app state – in-memory demo.
class BizState extends ChangeNotifier {
  bool loggedIn = false;
  String shopName = 'Fresh Mart Grocery';
  String owner = 'Bapi Mondal';
  String phone = '9876543210';
  String category = 'Grocery';
  String address = 'Main Road, Dubrajpur, Birbhum 731123';
  String about = 'Daily grocery, fruits, vegetables and household items at the best price.';
  String hours = '8:00 AM – 9:30 PM';
  bool shopOpen = true;
  int profileViews = 125;

  final List<Offer> offers = [
    Offer(
      title: '20% OFF on All Grocery Items',
      description: 'Get 20% discount on all grocery items.',
      type: 'Percentage Discount',
      value: 20,
      validTill: '31-10-2026',
      views: 48,
      claims: 32,
    ),
  ];

  final List<Redemption> redemptions = [
    Redemption('MEELOC-48213', 'Sangita Das', '20% OFF on All Grocery Items', DateTime.now().subtract(const Duration(hours: 3))),
    Redemption('MEELOC-19072', 'Rahul Sen', '20% OFF on All Grocery Items', DateTime.now().subtract(const Duration(days: 1))),
  ];

  /// Views for the last 7 days (for analytics chart).
  final List<int> weekViews = [12, 18, 9, 22, 17, 25, 22];

  int get offerViews => offers.fold(0, (a, o) => a + o.views);
  int get customers => offers.fold(0, (a, o) => a + o.claims);
  int get activeOffers => offers.where((o) => o.active).length;

  void login() {
    loggedIn = true;
    notifyListeners();
  }

  void logout() {
    loggedIn = false;
    notifyListeners();
  }

  void register({required String shop, required String ownerName, required String ph, required String cat, required String addr}) {
    shopName = shop;
    owner = ownerName;
    phone = ph;
    category = cat;
    address = addr;
    loggedIn = true;
    notifyListeners();
  }

  void updateProfile({
    required String shop,
    required String ownerName,
    required String ph,
    required String cat,
    required String addr,
    required String aboutText,
    required String openHours,
  }) {
    shopName = shop;
    owner = ownerName;
    phone = ph;
    category = cat;
    address = addr;
    about = aboutText;
    hours = openHours;
    notifyListeners();
  }

  void toggleShop(bool v) {
    shopOpen = v;
    notifyListeners();
  }

  void addOffer(Offer o) {
    offers.insert(0, o);
    notifyListeners();
  }

  void updated() => notifyListeners();

  void deleteOffer(Offer o) {
    offers.remove(o);
    notifyListeners();
  }

  /// Returns null on success, or an error message.
  String? redeem(String code) {
    final c = code.trim().toUpperCase();
    if (!RegExp(r'^MEELOC-\d{5}$').hasMatch(c)) return 'Invalid code format (e.g. MEELOC-12345)';
    if (redemptions.any((r) => r.code == c)) return 'This code is already redeemed';
    final active = offers.where((o) => o.active).toList();
    if (active.isEmpty) return 'No active offer to redeem';
    active.first.claims++;
    redemptions.insert(0, Redemption(c, 'Walk-in Customer', active.first.title, DateTime.now()));
    notifyListeners();
    return null;
  }
}

final biz = BizState();

String timeAgo(DateTime t) {
  final d = DateTime.now().difference(t);
  if (d.inMinutes < 1) return 'Just now';
  if (d.inHours < 1) return '${d.inMinutes} min ago';
  if (d.inDays < 1) return '${d.inHours} hr ago';
  return '${d.inDays} day ago';
}
