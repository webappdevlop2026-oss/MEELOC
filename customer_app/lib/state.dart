import 'package:flutter/material.dart';
import 'data.dart';

class Order {
  final String id;
  final List<(Product, int)> items;
  final int total;
  final String address, payment;
  final DateTime time;
  String status;
  Order({
    required this.id,
    required this.items,
    required this.total,
    required this.address,
    required this.payment,
    required this.time,
    this.status = 'Placed',
  });
}

class ClaimedOffer {
  final Shop shop;
  final String code;
  final DateTime time;
  ClaimedOffer(this.shop, this.code, this.time);
}

class AppNotification {
  final String title, body;
  final IconData icon;
  final DateTime time;
  bool read;
  AppNotification(this.title, this.body, this.icon, this.time, {this.read = false});
}

/// Whole customer app state (in-memory demo; replace with backend later).
class AppState extends ChangeNotifier {
  String name = 'Sangita Das';
  String email = 'sangita@example.com';
  String phone = '';
  bool loggedIn = false;
  String location = 'Dubrajpur 731123';
  String payment = 'Cash on Delivery';

  final Set<String> saved = {};
  final Map<String, int> cart = {};
  final List<Order> orders = [];
  final List<ClaimedOffer> claimed = [];
  final List<String> addresses = ['Ward 5, Near Bus Stand, Dubrajpur, Birbhum 731123'];
  final List<AppNotification> notifications = [
    AppNotification('Welcome to Meeloc!', 'Local & online deals in one place. Start saving today!',
        Icons.celebration_outlined, DateTime.now().subtract(const Duration(hours: 2))),
    AppNotification('Fresh Mart Grocery', '20% OFF on all grocery items – starts today.', Icons.local_offer_outlined,
        DateTime.now().subtract(const Duration(hours: 5))),
    AppNotification('Big Billion Sale', 'Up to 80% OFF online deals live now.', Icons.shopping_cart_outlined,
        DateTime.now().subtract(const Duration(days: 1))),
  ];

  String get initial => name.isEmpty ? 'U' : name[0].toUpperCase();
  int get unread => notifications.where((n) => !n.read).length;
  int get cartCount => cart.values.fold(0, (a, b) => a + b);
  int get cartTotal => cart.entries.fold(0, (a, e) => a + productById(e.key).priceValue * e.value);

  void login(String ph) {
    phone = ph;
    loggedIn = true;
    notifyListeners();
  }

  void logout() {
    loggedIn = false;
    notifyListeners();
  }

  void updateProfile(String n, String e) {
    name = n;
    email = e;
    notifyListeners();
  }

  void setLocation(String l) {
    location = l;
    notifyListeners();
  }

  void setPayment(String p) {
    payment = p;
    notifyListeners();
  }

  void toggleSaved(String shopName) {
    if (!saved.remove(shopName)) saved.add(shopName);
    notifyListeners();
  }

  void addToCart(String id, [int q = 1]) {
    cart[id] = (cart[id] ?? 0) + q;
    notifyListeners();
  }

  void setQty(String id, int q) {
    if (q <= 0) {
      cart.remove(id);
    } else {
      cart[id] = q;
    }
    notifyListeners();
  }

  Order placeOrder(String address) {
    final o = Order(
      id: 'MLC${1000 + orders.length + 21}',
      items: [for (final e in cart.entries) (productById(e.key), e.value)],
      total: cartTotal,
      address: address,
      payment: payment,
      time: DateTime.now(),
    );
    orders.insert(0, o);
    cart.clear();
    notifications.insert(0, AppNotification('Order placed', 'Order #${o.id} – ₹${o.total}', Icons.check_circle_outline, DateTime.now()));
    notifyListeners();
    return o;
  }

  void cancelOrder(Order o) {
    o.status = 'Cancelled';
    notifyListeners();
  }

  ClaimedOffer claim(Shop s) {
    final existing = claimed.where((c) => c.shop.name == s.name);
    if (existing.isNotEmpty) return existing.first;
    final c = ClaimedOffer(s, 'MEELOC-${(s.name.hashCode.abs() + DateTime.now().second) % 90000 + 10000}', DateTime.now());
    claimed.insert(0, c);
    notifications.insert(0, AppNotification('Offer claimed', '${s.offer} at ${s.name}. Code: ${c.code}', Icons.local_offer, DateTime.now()));
    notifyListeners();
    return c;
  }

  void addAddress(String a) {
    addresses.add(a);
    notifyListeners();
  }

  void removeAddress(int i) {
    addresses.removeAt(i);
    notifyListeners();
  }

  void markRead(AppNotification n) {
    n.read = true;
    notifyListeners();
  }

  void markAllRead() {
    for (final n in notifications) {
      n.read = true;
    }
    notifyListeners();
  }
}

final app = AppState();

String rupee(int v) {
  final s = v.toString();
  if (s.length <= 3) return '₹$s';
  final last3 = s.substring(s.length - 3);
  var rest = s.substring(0, s.length - 3);
  final parts = <String>[];
  while (rest.length > 2) {
    parts.insert(0, rest.substring(rest.length - 2));
    rest = rest.substring(0, rest.length - 2);
  }
  if (rest.isNotEmpty) parts.insert(0, rest);
  return '₹${parts.join(',')},$last3';
}

String timeAgo(DateTime t) {
  final d = DateTime.now().difference(t);
  if (d.inMinutes < 1) return 'Just now';
  if (d.inHours < 1) return '${d.inMinutes} min ago';
  if (d.inDays < 1) return '${d.inHours} hr ago';
  return '${d.inDays} day ago';
}
