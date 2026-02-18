import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weapon_provider.dart';

class RarityDropdown extends StatelessWidget {
  const RarityDropdown({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<WeaponProvider>();
    return DropdownButton<String>(
      value: prov.selectedRarity,
      items: prov.rarities.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
      onChanged: (v) => prov.setRarity(v ?? 'Blue'),
    );
  }
}
