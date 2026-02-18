import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/weapon_provider.dart';

class WeaponsListScreen extends StatelessWidget {
  const WeaponsListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<WeaponProvider>();
    if (prov.weapons.isEmpty) return const Center(child: CircularProgressIndicator());

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: prov.weapons.length,
      itemBuilder: (context, i) {
        final w = prov.weapons[i];
        final isFav = prov.favorites.contains(w.name);
        return Card(
          child: ListTile(
            leading: const Icon(Icons.shield),
            title: Text(w.name),
            subtitle: Text(w.type),
            trailing: IconButton(
              icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: isFav ? Colors.red : null),
              onPressed: () => prov.toggleFavorite(w.name),
            ),
            onTap: () {
              prov.selectWeapon(w);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${w.name} selected')));
            },
          ),
        );
      },
    );
  }
}
