import 'package:flutter/material.dart';

class Item {
  final String id;
  String name, sub, status; // status: Pending / Approved / Blocked / Active / Paused
  final String extra;
  Item(this.id, this.name, this.sub, this.status, [this.extra = '']);
}

class AdminState extends ChangeNotifier {
  bool loggedIn = false;
  String appName = 'Meeloc';
  String commission = '10';
  String serviceAreas = 'Dubrajpur, Suri, Bolpur, Rampurhat, Sainthia, Durgapur';
  String supportEmail = 'support@meeloc.in';
  bool newSignups = true;

  final businesses = <Item>[
    Item('b1', 'Fresh Mart Grocery', 'Grocery • Dubrajpur', 'Approved', 'Bapi Mondal'),
    Item('b2', 'Bapi Electronics', 'Electronics • Dubrajpur', 'Approved', 'Bapi Ghosh'),
    Item('b3', 'Tasty Bite Restaurant', 'Restaurant • Dubrajpur', 'Approved', 'Rana Sheikh'),
    Item('b4', 'Style Salon', 'Beauty • Dubrajpur', 'Approved', 'Mou Das'),
    Item('b5', 'Maa Tara Pharmacy', 'Pharmacy • Dubrajpur', 'Pending', 'Tapas Pal'),
    Item('b6', 'Trendz Fashion Hub', 'Fashion • Suri', 'Pending', 'Arif Khan'),
  ];
  final partners = <Item>[
    Item('p1', 'Rahul Mondal', 'Scooter • WB 54 A 1234', 'Approved'),
    Item('p2', 'Sourav Ghosh', 'Bike • WB 54 B 2211', 'Approved'),
    Item('p3', 'Amit Sheikh', 'Bicycle', 'Pending'),
    Item('p4', 'Bikash Roy', 'Scooter • WB 54 C 9087', 'Blocked'),
  ];
  final offers = <Item>[
    Item('o1', '20% OFF on All Grocery Items', 'Fresh Mart Grocery', 'Active'),
    Item('o2', '10% OFF on Mobile Accessories', 'Bapi Electronics', 'Active'),
    Item('o3', 'Flat 15% OFF on Dining', 'Tasty Bite Restaurant', 'Active'),
    Item('o4', '30% OFF on All Services', 'Style Salon', 'Paused'),
  ];
  final ads = <Item>[
    Item('a1', 'Local Deals – Home Banner', 'Customer app • Home', 'Active'),
    Item('a2', 'Big Billion – Online Banner', 'Customer app • Online Shopping', 'Active'),
  ];
  final users = <Item>[
    Item('u1', 'Sangita Das', 'sangita@example.com', 'Active'),
    Item('u2', 'Rahul Sen', '+91 98000 22222', 'Active'),
    Item('u3', 'Priya Sen', '+91 98000 33333', 'Active'),
    Item('u4', 'Amit Roy', '+91 98000 44444', 'Blocked'),
  ];

  // Base counts from design + live list changes.
  int get totalUsers => 1241 + users.length;
  int get totalBusinesses => 322 + businesses.length;
  int get totalPartners => 152 + partners.length;
  int get totalOffers => 888 + offers.length;
  int get pending =>
      businesses.where((b) => b.status == 'Pending').length + partners.where((p) => p.status == 'Pending').length;

  void login() {
    loggedIn = true;
    notifyListeners();
  }

  void logout() {
    loggedIn = false;
    notifyListeners();
  }

  void setStatus(Item i, String s) {
    i.status = s;
    notifyListeners();
  }

  void remove(List<Item> list, Item i) {
    list.remove(i);
    notifyListeners();
  }

  void add(List<Item> list, Item i) {
    list.insert(0, i);
    notifyListeners();
  }

  void saveSettings({required String name, required String comm, required String areas, required String email, required bool signups}) {
    appName = name;
    commission = comm;
    serviceAreas = areas;
    supportEmail = email;
    newSignups = signups;
    notifyListeners();
  }
}

final admin = AdminState();
