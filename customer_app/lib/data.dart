import 'package:flutter/material.dart';

class Shop {
  final String name, image, category, offer, offerNote, distance, about, validTill, mode;
  final double rating;
  final int reviews;
  const Shop({
    required this.name,
    required this.image,
    required this.category,
    required this.rating,
    required this.reviews,
    required this.distance,
    required this.offer,
    required this.offerNote,
    required this.about,
    this.validTill = '31 Oct 2026',
    this.mode = 'In Store',
  });
}

const shops = <Shop>[
  Shop(
    name: 'Fresh Mart Grocery',
    image: 'assets/images/fresh_mart.png',
    category: 'Grocery',
    rating: 4.5,
    reviews: 120,
    distance: '900 m',
    offer: '20% OFF',
    offerNote: 'All Grocery Items',
    about: 'Get 20% discount on all grocery items. Valid on in-store purchase only.',
  ),
  Shop(
    name: 'Bapi Electronics',
    image: 'assets/images/bapi_electronics.png',
    category: 'Electronics',
    rating: 4.2,
    reviews: 86,
    distance: '1.2 km',
    offer: '10% OFF',
    offerNote: 'On Mobile Accessories',
    about: 'Flat 10% off on all mobile accessories – chargers, cables, covers and more.',
  ),
  Shop(
    name: 'Tasty Bite Restaurant',
    image: 'assets/images/tasty_bite.png',
    category: 'Restaurant',
    rating: 4.3,
    reviews: 95,
    distance: '800 m',
    offer: 'Flat 15% OFF',
    offerNote: 'On Dining',
    about: 'Get flat 15% discount on total bill. Valid for dine-in only. Enjoy delicious food with your family and friends.',
    mode: 'Dine In',
  ),
  Shop(
    name: 'Style Salon',
    image: 'assets/images/style_salon.png',
    category: 'Beauty',
    rating: 4.5,
    reviews: 60,
    distance: '1.5 km',
    offer: '30% OFF',
    offerNote: 'On All Services',
    about: 'Get 30% off on all salon services. Prior booking recommended.',
  ),
];

class Cat {
  final String name;
  final IconData icon;
  final Color color;
  const Cat(this.name, this.icon, this.color);
}

const homeCats = <Cat>[
  Cat('Grocery', Icons.shopping_basket_rounded, Color(0xFFF97316)),
  Cat('Electronics', Icons.desktop_windows_rounded, Color(0xFF2563EB)),
  Cat('Fashion', Icons.checkroom_rounded, Color(0xFFEC4899)),
  Cat('Restaurant', Icons.storefront_rounded, Color(0xFFDC2626)),
  Cat('Beauty', Icons.spa_rounded, Color(0xFFEF4444)),
  Cat('Pharmacy', Icons.medical_services_rounded, Color(0xFFDC2626)),
  Cat('Home Service', Icons.home_rounded, Color(0xFFF59E0B)),
  Cat('More', Icons.more_horiz_rounded, Color(0xFF111827)),
];

const onlineCats = <Cat>[
  Cat('Mobiles', Icons.smartphone_rounded, Color(0xFF2563EB)),
  Cat('Fashion', Icons.checkroom_rounded, Color(0xFFDC2626)),
  Cat('Electronics', Icons.desktop_windows_rounded, Color(0xFF2563EB)),
  Cat('Home & Kitchen', Icons.kitchen_rounded, Color(0xFFF97316)),
  Cat('Beauty', Icons.face_retouching_natural, Color(0xFFDC2626)),
  Cat('Appliances', Icons.local_laundry_service_rounded, Color(0xFF374151)),
  Cat('Footwear', Icons.directions_walk_rounded, Color(0xFF1D4ED8)),
  Cat('More', Icons.more_horiz_rounded, Color(0xFF111827)),
];

class Brand {
  final String name, letter;
  final Color bg, fg;
  const Brand(this.name, this.letter, this.bg, this.fg);
}

const brands = <Brand>[
  Brand('Amazon', 'a', Colors.white, Colors.black),
  Brand('Flipkart', 'f', Color(0xFF2874F0), Color(0xFFFFE11B)),
  Brand('Myntra', 'M', Colors.white, Color(0xFFE91E63)),
  Brand('Ajio', 'A', Color(0xFF2C4152), Colors.white),
  Brand('Nykaa', 'N', Color(0xFFFC2779), Colors.white),
];

class Deal {
  final String image, off, name, price;
  const Deal(this.image, this.off, this.name, this.price);
}

const deals = <Deal>[
  Deal('assets/images/deal_phone.png', '40% OFF', 'Smartphone 5G', '₹11,999'),
  Deal('assets/images/deal_shoes.png', '60% OFF', 'Running Shoes', '₹1,199'),
  Deal('assets/images/deal_watch.png', '50% OFF', 'Smart Watch', '₹2,499'),
];

/// Saved offers (in-memory).
final ValueNotifier<Set<String>> savedShops = ValueNotifier<Set<String>>({});

void toggleSaved(String name) {
  final s = {...savedShops.value};
  s.contains(name) ? s.remove(name) : s.add(name);
  savedShops.value = s;
}
