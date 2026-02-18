import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/weapon_provider.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<WeaponProvider>();
    final favs = prov.weapons.where((w) => prov.favorites.contains(w.name)).toList();

    if (favs.isEmpty) return const Center(child: Text('No favorites yet'));

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: favs.length,
      itemBuilder: (context, i) {
        final w = favs[i];
        return Card(
          child: ListTile(
            leading: const Icon(Icons.favorite, color: Colors.red),
            title: Text(w.name),
            subtitle: Text(w.type),
            onTap: () {
              prov.selectWeapon(w);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Selected ${w.name}')));
            },
          ),
        );
      },
    );
  }
}
