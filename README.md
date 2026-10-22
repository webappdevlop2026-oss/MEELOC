# Meeloc

Local + Online offers platform — 4 Flutter apps.

| Folder | App | Features |
|---|---|---|
| `customer_app/` | Customer App | Splash, OTP login, Home, location picker, search, notifications, Local Shopping (filter/sort/search), Offer Details (claim code, call, directions, share, save), Online Shopping (brands, categories, product list/detail), Cart & Checkout, My Orders (cancel), My Offers, Saved, Addresses, Payment, Refer & Earn, Help, Edit Profile, Logout |
| `business_app/` | Dukandar / Seller App | Register, OTP login, Dashboard (live stats, shop open/close), Add/Edit/Delete/Pause Offers, Business Profile, Analytics, Verify customer offer code, Customers |
| `delivery_partner_app/` | Delivery Partner App | Register, OTP login, Online/Offline, New orders (accept/reject), Pickup → Deliver with OTP, Completed, Earnings & Withdraw, Documents |
| `admin_panel/` | Web Admin Panel | Login, Dashboard, Businesses/Partners approve-block, Offers & Ads on/off, Users, Analytics, Settings (web sidebar + mobile) |

Demo OTP: **1234**. All data is in-memory demo data (backend can be connected later).

## Run on Windows

Double-click `setup.bat` once, then:

```bash
cd customer_app
flutter run                # phone connected via USB
flutter build apk --release
```

Admin: `cd admin_panel && flutter run -d chrome`

## Automatic APK build

Every push to `main` builds all APKs + admin web on GitHub Actions and publishes them under **Releases**.
