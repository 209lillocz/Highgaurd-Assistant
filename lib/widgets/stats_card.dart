import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/weapon_provider.dart';
import '../services/calculation_service.dart';

class StatsCard extends StatelessWidget {
  const StatsCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<WeaponProvider>();
    final weapon = prov.selected;
    if (weapon == null) return const SizedBox.shrink();

    // Build DPS values across rarities for chart
    final multipliers = prov.rarityMultipliers;
    final List<double> dpsValues = [];
    final labels = prov.rarities;

    for (var r in labels) {
      final mult = r == 'Blue' ? {'damage': 1.0, 'clip': 1.0, 'reload': 1.0} : (multipliers[r] ?? {'damage': 1.0, 'clip': 1.0, 'reload': 1.0});
      final cs = CalculationService.applyRarity(weapon, mult);
      dpsValues.add(cs.dps);
    }

    final selectedMult = prov.selectedRarity == 'Blue' ? {'damage': 1.0, 'clip': 1.0, 'reload': 1.0} : (multipliers[prov.selectedRarity] ?? {'damage': 1.0, 'clip': 1.0, 'reload': 1.0});
    final selStats = CalculationService.applyRarity(weapon, selectedMult);

    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(weapon.name, style: Theme.of(context).textTheme.titleLarge)),
                Text(weapon.type, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(spacing: 12, runSpacing: 8, children: [
              StatChip(label: 'Body', value: selStats.bodyDamage.toStringAsFixed(1)),
              StatChip(label: 'Head', value: selStats.headDamage.toStringAsFixed(1)),
              StatChip(label: 'DPS', value: selStats.dps.toStringAsFixed(1)),
              StatChip(label: 'Clip', value: '${selStats.clipSize}'),
              StatChip(label: 'Reload', value: '${selStats.reloadTime.toStringAsFixed(2)}s'),
              StatChip(label: 'FireRate', value: '${selStats.fireRate.toStringAsFixed(2)}/s'),
              StatChip(label: 'Proj/Shot', value: '${selStats.projectilesPerShot}'),
            ]),
            const SizedBox(height: 12),
              SizedBox(height: 140, child: _buildSimpleBarChart(dpsValues, labels)),
            const SizedBox(height: 8),
            Text('Legendary perks: ${weapon.perksByRarity['Red']?.join(', ') ?? 'Higher rarities may include unique traits.'}', style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }

    Widget _buildSimpleBarChart(List<double> values, List<String> labels) {
      final maxVal = (values.isEmpty) ? 1.0 : values.reduce((a, b) => a > b ? a : b);
      return LayoutBuilder(builder: (context, constraints) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: values.asMap().entries.map((e) {
            final h = (e.value / (maxVal == 0 ? 1 : maxVal)) * constraints.maxHeight * 0.9;
            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Tooltip(message: '${labels[e.key]}: ${e.value.toStringAsFixed(1)}', child: Container(width: 28, height: h, color: Colors.indigo)),
                const SizedBox(height: 6),
                SizedBox(width: 48, child: Text(labels[e.key], textAlign: TextAlign.center, style: const TextStyle(fontSize: 12))),
              ],
            );
          }).toList(),
        );
      });
    }
}

class StatChip extends StatelessWidget {
  final String label;
  final String value;
  const StatChip({Key? key, required this.label, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Chip(label: Text('$label: $value'));
  }
}
