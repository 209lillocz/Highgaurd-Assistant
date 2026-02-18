import 'dart:math';
import '../models/weapon.dart';

class CalculatedStats {
  final int clipSize;
  final int projectilesPerShot;
  final double bodyDamage;
  final double headDamage;
  final double reloadTime;
  final double fireRate;
  final double dps; // using headshot dps (fireRate * headDamage * projectiles)

  CalculatedStats({required this.clipSize, required this.projectilesPerShot, required this.bodyDamage, required this.headDamage, required this.reloadTime, required this.fireRate, required this.dps});
}

class CalculationService {
  // Apply multipliers and compute derived stats
  static CalculatedStats applyRarity(Weapon weapon, Map<String, dynamic> rarityMultiplier) {
    final base = weapon.base;
    final dmgMul = (rarityMultiplier['damage'] ?? 1.0).toDouble();
    final clipMul = (rarityMultiplier['clip'] ?? 1.0).toDouble();
    final reloadMul = (rarityMultiplier['reload'] ?? 1.0).toDouble();

    final clip = max(1, (base.clipSize * clipMul).ceil());
    final proj = base.projectilesPerShot;
    final body = base.bodyDamage * dmgMul;
    final head = base.headDamage * dmgMul;
    final reload = (base.reloadTime * reloadMul);
    final rate = base.fireRate; // keep base fire rate unless special trait

    final dps = rate * head * proj;

    return CalculatedStats(
      clipSize: clip,
      projectilesPerShot: proj,
      bodyDamage: body,
      headDamage: head,
      reloadTime: reload,
      fireRate: rate,
      dps: dps,
    );
  }
}
