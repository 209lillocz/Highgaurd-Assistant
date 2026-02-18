import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/weapon.dart';

class WeaponProvider extends ChangeNotifier {
  List<Weapon> weapons = [];
  Map<String, dynamic> rarityMultipliers = {};
  String lastUpdated = '';

  Weapon? selected;
  String selectedRarity = 'Blue';

  final List<String> rarities = ['Blue', 'Purple', 'Gold', 'Red'];

  Set<String> favorites = {};

  Future<void> loadFromAssets() async {
    final raw = await rootBundle.loadString('assets/data/weapons.json');
    final j = json.decode(raw) as Map<String, dynamic>;
    lastUpdated = j['lastUpdated'] ?? '';

    rarityMultipliers = j['rarityMultipliers'] ?? {};

    weapons = (j['weapons'] as List<dynamic>? ?? []).map((e) => Weapon.fromJson(e as Map<String, dynamic>)).toList();
    if (weapons.isNotEmpty) selected = weapons.first;
    await _loadFavorites();
    notifyListeners();
  }

  void selectWeapon(Weapon w) {
    selected = w;
    notifyListeners();
  }

  void setRarity(String r) {
    selectedRarity = r;
    notifyListeners();
  }

  Future<void> _loadFavorites() async {
    final sp = await SharedPreferences.getInstance();
    final list = sp.getStringList('favorites') ?? [];
    favorites = list.toSet();
  }

  Future<void> toggleFavorite(String weaponName) async {
    final sp = await SharedPreferences.getInstance();
    if (favorites.contains(weaponName)) favorites.remove(weaponName);
    else favorites.add(weaponName);
    await sp.setStringList('favorites', favorites.toList());
    notifyListeners();
  }
}
