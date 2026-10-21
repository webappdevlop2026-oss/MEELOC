# Meeloc

Local + Online offers platform — 4 Flutter apps (UI same as Meeloc design).

| Folder | App |
|---|---|
| `customer_app/` | Customer App — Home, Local Shopping, Online Shopping, Offer Details, Account, Offers, Categories, Saved |
| `business_app/` | Dukandar / Seller App — Welcome, Business Dashboard, Add Offer, Manage Offers |
| `delivery_partner_app/` | Delivery Partner App — Welcome, Partner Dashboard (Online toggle, orders) |
| `admin_panel/` | Web Admin Panel (responsive: web sidebar + mobile) |

## Run

```bash
cd customer_app            # or business_app / delivery_partner_app
flutter create . --platforms android,ios
flutter pub get
flutter run

cd admin_panel
flutter create . --platforms web
flutter run -d chrome      # build: flutter build web
```

Demo data in-memory; Firebase/backend can be connected later.
