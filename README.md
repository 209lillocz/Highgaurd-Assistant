# Highguard Assistant

Mobile-first Flutter app: Highguard weapon stats calculator. Offline-first, data-driven via `assets/data/weapons.json`.

Quick start

1. Install Flutter and Android SDK.
2. From workspace root run:

```bash
flutter pub get
flutter run -d emulator-5554
```

Web (quick preview)

You can run the app in Chrome (if Flutter web is installed):

```bash
flutter pub get
flutter run -d chrome
```

Or build static web files and serve locally:

```bash
flutter build web
cd build/web
python3 -m http.server 8000
# then open http://localhost:8000
```

Notes for maintainers
- To add a new weapon: append an object to the `weapons` array in `assets/data/weapons.json` and hot-restart the app.
- For remote updates later: replace the JSON load in `lib/providers/weapon_provider.dart` with an `http.get` to a raw GitHub URL and fallback to the bundled asset.

Files of interest
- `lib/models/weapon.dart` - data model and `fromJson`.
- `lib/services/calculation_service.dart` - applies rarity multipliers and computes DPS.
- `lib/providers/weapon_provider.dart` - loads `weapons.json`, exposes weapons and favorites.
- `assets/data/weapons.json` - all weapon data and rarity multipliers.

Design goals
- All gameplay data lives in JSON for easy updates without changing Dart code.
- Provider is used for simple state management; can be swapped for Riverpod later.
- Favorites saved locally with `shared_preferences`.

License: see LICENSE
# Highgaurd-Assistant