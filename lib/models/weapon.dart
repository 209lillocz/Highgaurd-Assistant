class Weapon {
  final String name;
  final String type;
  final BaseStats base;
  final Map<String, List<String>> perksByRarity;
  final String? imageUrl;
  final String? description;

  Weapon({required this.name, required this.type, required this.base, required this.perksByRarity, this.imageUrl, this.description});

  factory Weapon.fromJson(Map<String, dynamic> j) {
    return Weapon(
      name: j['name'] ?? '',
      type: j['type'] ?? '',
      base: BaseStats.fromJson(j['base'] ?? {}),
      perksByRarity: (j['perksByRarity'] as Map<String, dynamic>?)?.map((k, v) => MapEntry(k, List<String>.from(v ?? []))) ?? {},
      imageUrl: j['imageUrl'] as String?,
      description: j['description'] as String?,
    );
  }
}

class BaseStats {
  final int clipSize;
  final int projectilesPerShot;
  final double bodyDamage;
  final double headDamage;
  final double reloadTime;
  final double fireRate;

  BaseStats({required this.clipSize, required this.projectilesPerShot, required this.bodyDamage, required this.headDamage, required this.reloadTime, required this.fireRate});

  factory BaseStats.fromJson(Map<String, dynamic> j) {
    return BaseStats(
      clipSize: (j['clipSize'] ?? 1).toInt(),
      projectilesPerShot: (j['projectilesPerShot'] ?? 1).toInt(),
      bodyDamage: (j['bodyDamage'] ?? 0).toDouble(),
      headDamage: (j['headDamage'] ?? 0).toDouble(),
      reloadTime: (j['reloadTime'] ?? 0).toDouble(),
      fireRate: (j['fireRate'] ?? 1).toDouble(),
    );
  }
}
