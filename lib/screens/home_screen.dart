import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../providers/weapon_provider.dart';
import '../widgets/weapon_card.dart';
import 'weapon_detail.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String query = '';

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<WeaponProvider>();
    final weapons = prov.weapons.where((w) => w.name.toLowerCase().contains(query.toLowerCase())).toList();

    if (prov.weapons.isEmpty) return const Center(child: CircularProgressIndicator());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Highguard Assistant'),
        actions: [
          IconButton(icon: const Icon(Icons.brightness_6), onPressed: () => prov.toggleTheme()),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xFF071025), Color(0xFF0B1020)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search weapons', border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12)))),
              onChanged: (v) => setState(() => query = v),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.78, mainAxisSpacing: 12, crossAxisSpacing: 12),
              itemCount: weapons.length,
              itemBuilder: (context, i) {
                final w = weapons[i];
                final isFav = prov.favorites.contains(w.name);
                return WeaponCard(
                  weapon: w,
                  isFav: isFav,
                  onFavToggle: () => prov.toggleFavorite(w.name),
                  onTap: () {
                    prov.selectWeapon(w);
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => WeaponDetailScreen(weapon: w)));
                  },
                ).animate().fadeIn(delay: (i * 30).ms);
              },
            ),
          )
        ]),
      ),
    );
  }
}
