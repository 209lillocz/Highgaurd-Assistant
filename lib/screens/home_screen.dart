import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/weapon.dart';
import '../providers/weapon_provider.dart';
import '../widgets/rarity_dropdown.dart';
import '../widgets/stats_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<WeaponProvider>();
    return prov.weapons.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: DropdownButton<Weapon>(
                          value: prov.selected,
                          isExpanded: true,
                          items: prov.weapons.map((w) => DropdownMenuItem(value: w, child: Text(w.name))).toList(),
                          onChanged: (w) => prov.selectWeapon(w!),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const RarityDropdown(),
                    ],
                  ),
                ),
                const StatsCard(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                  child: Text('Data from launch + Episode 2 patches – check playhighguard.com or Discord for latest', style: Theme.of(context).textTheme.bodySmall),
                )
              ],
            ),
          );
  }
}
