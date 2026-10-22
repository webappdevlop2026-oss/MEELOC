import 'package:flutter/material.dart';

class Shop {
  final String name, category, offer, offerNote, distance, about, validTill, mode, phone;
  final String? image;
  final IconData icon;
  final double rating;
  final int reviews;
  const Shop({
    required this.name,
    this.image,
    this.icon = Icons.storefront_rounded,
    this.phone = '9876543210',
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
  Shop(
    name: 'Maa Tara Pharmacy',
    icon: Icons.local_pharmacy_rounded,
    category: 'Pharmacy',
    rating: 4.6,
    reviews: 74,
    distance: '600 m',
    offer: '12% OFF',
    offerNote: 'On All Medicines',
    about: 'Get 12% off on all medicines with a valid prescription. Free home delivery within 2 km.',
  ),
  Shop(
    name: 'QuickFix Home Service',
    icon: Icons.home_repair_service_rounded,
    category: 'Home Service',
    rating: 4.4,
    reviews: 41,
    distance: '2.1 km',
    offer: '₹100 OFF',
    offerNote: 'On First Booking',
    about: 'Electrician, plumber and AC service at your doorstep. ₹100 off on your first booking.',
    mode: 'Home Visit',
  ),
  Shop(
    name: 'Trendz Fashion Hub',
    icon: Icons.checkroom_rounded,
    category: 'Fashion',
    rating: 4.3,
    reviews: 58,
    distance: '1.1 km',
    offer: '25% OFF',
    offerNote: 'On Ethnic Wear',
    about: 'Flat 25% off on sarees, kurtas and ethnic wear. Valid on in-store purchase.',
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

class Product {
  final String id, name, brand, category, price, mrp, off;
  final String? image;
  final IconData icon;
  final double rating;
  const Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.category,
    required this.price,
    required this.mrp,
    required this.off,
    this.image,
    this.icon = Icons.shopping_bag_outlined,
    this.rating = 4.3,
  });
  int get priceValue => int.parse(price.replaceAll(RegExp(r'[^0-9]'), ''));
}

const products = <Product>[
  Product(id: 'p1', name: 'Smartphone 5G (8GB/128GB)', brand: 'Amazon', category: 'Mobiles', price: '₹11,999', mrp: '₹19,999', off: '40% OFF', image: 'assets/images/deal_phone.png', rating: 4.4),
  Product(id: 'p2', name: 'Running Shoes', brand: 'Myntra', category: 'Footwear', price: '₹1,199', mrp: '₹2,999', off: '60% OFF', image: 'assets/images/deal_shoes.png', rating: 4.2),
  Product(id: 'p3', name: 'Smart Watch', brand: 'Flipkart', category: 'Electronics', price: '₹2,499', mrp: '₹4,999', off: '50% OFF', image: 'assets/images/deal_watch.png', rating: 4.1),
  Product(id: 'p4', name: 'Cotton Kurta', brand: 'Ajio', category: 'Fashion', price: '₹599', mrp: '₹1,499', off: '60% OFF', icon: Icons.checkroom_rounded),
  Product(id: 'p5', name: 'Mixer Grinder 750W', brand: 'Amazon', category: 'Home & Kitchen', price: '₹2,199', mrp: '₹3,999', off: '45% OFF', icon: Icons.blender_outlined),
  Product(id: 'p6', name: 'Face Wash Combo', brand: 'Nykaa', category: 'Beauty', price: '₹349', mrp: '₹699', off: '50% OFF', icon: Icons.face_retouching_natural),
  Product(id: 'p7', name: 'Washing Machine 7kg', brand: 'Flipkart', category: 'Appliances', price: '₹14,990', mrp: '₹21,990', off: '32% OFF', icon: Icons.local_laundry_service_rounded),
  Product(id: 'p8', name: 'Bluetooth Earbuds', brand: 'Amazon', category: 'Electronics', price: '₹999', mrp: '₹2,999', off: '67% OFF', icon: Icons.headphones_rounded),
  Product(id: 'p9', name: 'Sneakers Casual', brand: 'Ajio', category: 'Footwear', price: '₹899', mrp: '₹1,999', off: '55% OFF', image: 'assets/images/deal_shoes.png'),
  Product(id: 'p10', name: 'Lipstick Matte Set', brand: 'Nykaa', category: 'Beauty', price: '₹499', mrp: '₹999', off: '50% OFF', icon: Icons.brush_rounded),
  Product(id: 'p11', name: 'Saree Printed', brand: 'Myntra', category: 'Fashion', price: '₹799', mrp: '₹2,199', off: '64% OFF', icon: Icons.dry_cleaning_rounded),
  Product(id: 'p12', name: 'Power Bank 20000mAh', brand: 'Flipkart', category: 'Mobiles', price: '₹1,299', mrp: '₹2,499', off: '48% OFF', icon: Icons.battery_charging_full_rounded),
];

Product productById(String id) => products.firstWhere((p) => p.id == id);
