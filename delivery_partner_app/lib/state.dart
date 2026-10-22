import 'package:flutter/material.dart';

enum OStatus { newOrder, accepted, pickedUp, delivered, rejected }

class DOrder {
  final String id, shop, shopAddress, customer, customerAddress, phone, items;
  final int amount, earning;
  final double km;
  OStatus status;
  DateTime? doneAt;
  DOrder({
    required this.id,
    required this.shop,
    required this.shopAddress,
    required this.customer,
    required this.customerAddress,
    required this.phone,
    required this.items,
    required this.amount,
    required this.earning,
    required this.km,
    this.status = OStatus.newOrder,
    this.doneAt,
  });
  String get statusText => switch (status) {
        OStatus.newOrder => 'New',
        OStatus.accepted => 'Going to shop',
        OStatus.pickedUp => 'Out for delivery',
        OStatus.delivered => 'Delivered',
        OStatus.rejected => 'Rejected',
      };
}

class Doc {
  final String name;
  bool uploaded;
  Doc(this.name, this.uploaded);
}

class PartnerState extends ChangeNotifier {
  bool loggedIn = false;
  bool online = true;
  String name = 'Rahul Mondal';
  String phone = '9876500000';
  String vehicle = 'Scooter • WB 54 A 1234';
  double rating = 4.8;
  int withdrawn = 0;

  final List<Doc> docs = [
    Doc('Aadhaar Card', true),
    Doc('Driving Licence', true),
    Doc('Vehicle RC', false),
    Doc('Bank Passbook', false),
  ];

  final List<DOrder> orders = [
    DOrder(
      id: 'MLC1021',
      shop: 'Fresh Mart Grocery',
      shopAddress: 'Main Road, Dubrajpur',
      customer: 'Sangita Das',
      customerAddress: 'Ward 5, Near Bus Stand, Dubrajpur',
      phone: '9800011111',
      items: 'Rice 5kg, Dal 1kg, Oil 1L',
      amount: 640,
      earning: 40,
      km: 1.8,
    ),
    DOrder(
      id: 'MLC1022',
      shop: 'Tasty Bite Restaurant',
      shopAddress: 'Station Road, Dubrajpur',
      customer: 'Amit Roy',
      customerAddress: 'College Para, Dubrajpur',
      phone: '9800022222',
      items: 'Chicken Biryani × 2',
      amount: 360,
      earning: 35,
      km: 2.4,
    ),
    DOrder(
      id: 'MLC1019',
      shop: 'Bapi Electronics',
      shopAddress: 'Bazar, Dubrajpur',
      customer: 'Priya Sen',
      customerAddress: 'Hospital More, Dubrajpur',
      phone: '9800033333',
      items: 'Mobile charger, Earphone',
      amount: 850,
      earning: 45,
      km: 1.2,
      status: OStatus.accepted,
    ),
    for (int i = 1; i <= 12; i++)
      DOrder(
        id: 'MLC10${i.toString().padLeft(2, '0')}',
        shop: i.isEven ? 'Fresh Mart Grocery' : 'Tasty Bite Restaurant',
        shopAddress: 'Dubrajpur',
        customer: 'Customer $i',
        customerAddress: 'Dubrajpur',
        phone: '9800000000',
        items: 'Order items',
        amount: 200 + i * 15,
        earning: i < 6 ? 30 : 25,
        km: 1.5,
        status: OStatus.delivered,
        doneAt: DateTime.now().subtract(Duration(hours: i < 6 ? i : 24 + i)),
      ),
  ];

  List<DOrder> by(OStatus s) => orders.where((o) => o.status == s).toList();
  List<DOrder> get newOrders => online ? by(OStatus.newOrder) : [];
  List<DOrder> get ongoing => orders.where((o) => o.status == OStatus.accepted || o.status == OStatus.pickedUp).toList();
  List<DOrder> get completed => by(OStatus.delivered);

  bool _today(DateTime? t) {
    if (t == null) return false;
    final n = DateTime.now();
    return t.year == n.year && t.month == n.month && t.day == n.day;
  }

  List<DOrder> get todayDone => completed.where((o) => _today(o.doneAt)).toList();
  int get todayEarnings => todayDone.fold(0, (a, o) => a + o.earning);
  int get totalEarnings => completed.fold(0, (a, o) => a + o.earning);
  int get balance => totalEarnings - withdrawn;

  void login() {
    loggedIn = true;
    notifyListeners();
  }

  void logout() {
    loggedIn = false;
    notifyListeners();
  }

  void register(String n, String ph, String v) {
    name = n;
    phone = ph;
    vehicle = v;
    loggedIn = true;
    notifyListeners();
  }

  void setOnline(bool v) {
    online = v;
    notifyListeners();
  }

  void setStatus(DOrder o, OStatus s) {
    o.status = s;
    if (s == OStatus.delivered) o.doneAt = DateTime.now();
    notifyListeners();
  }

  void uploadDoc(Doc d) {
    d.uploaded = true;
    notifyListeners();
  }

  /// Returns error text or null.
  String? withdraw(int amt) {
    if (amt <= 0) return 'Enter a valid amount';
    if (amt > balance) return 'Amount is more than balance';
    withdrawn += amt;
    notifyListeners();
    return null;
  }
}

final partner = PartnerState();
