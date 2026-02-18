import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../models/weapon.dart';
import '../providers/weapon_provider.dart';
import '../services/calculation_service.dart';

class WeaponDetailScreen extends StatefulWidget {
  final Weapon weapon;
  const WeaponDetailScreen({Key? key, required this.weapon}) : super(key: key);

  @override
  State<WeaponDetailScreen> createState() => _WeaponDetailScreenState();
}

class _WeaponDetailScreenState extends State<WeaponDetailScreen> with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _glowController;

  Color _rarityColor(String r) {
    switch (r) {
      case 'Purple':
        return const Color(0xFF9C27B0);
      case 'Gold':
        return const Color(0xFFFFC107);
      case 'Red':
        return const Color(0xFFD32F2F);
      default:
        return const Color(0xFF2196F3);
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _glowController = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<WeaponProvider>();
    final rarity = prov.selectedRarity;
    final mult = prov.getRarityMultiplier(rarity);
    final stats = CalculationService.applyRarity(widget.weapon, mult);

    final glowColor = _rarityColor(rarity);

    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: (_) => true,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              expandedHeight: 360,
              pinned: true,
              backgroundColor: Colors.transparent,
              flexibleSpace: LayoutBuilder(builder: (context, constraints) {
                final top = constraints.biggest.height;
                final parallax = (top - kToolbarHeight) / (360 - kToolbarHeight);
                return FlexibleSpaceBar(
                  title: Text(widget.weapon.name),
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Transform.translate(
                        offset: Offset(0, -40 * (1 - parallax)),
                        child: Hero(
                          tag: 'weapon-${widget.weapon.name}',
                          child: (widget.weapon.imageUrl != null && widget.weapon.imageUrl!.startsWith('assets/'))
                              ? SvgPicture.asset(widget.weapon.imageUrl!, fit: BoxFit.cover)
                              : CachedNetworkImage(
                                  imageUrl: (widget.weapon.imageUrl != null && widget.weapon.imageUrl!.isNotEmpty) ? widget.weapon.imageUrl! : 'https://picsum.photos/800/450',
                                  fit: BoxFit.cover,
                                  placeholder: (c, u) => Shimmer.fromColors(baseColor: Colors.grey.shade800, highlightColor: Colors.grey.shade600, child: Container(color: Colors.grey.shade800)),
                                  errorWidget: (c, u, e) => Container(color: Colors.grey.shade800),
                                ),
                        ),
                      ),
                      Container(decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.black.withOpacity(0.6), Colors.transparent], begin: Alignment.bottomCenter, end: Alignment.topCenter))),
                      Positioned.fill(
                        child: AnimatedBuilder(
                          animation: _glowController,
                          builder: (context, child) {
                            final t = _glowController.value;
                            return IgnorePointer(
                              child: Container(
                                decoration: BoxDecoration(border: Border.all(color: glowColor.withOpacity(0.08 + 0.12 * t), width: 6 * (0.8 + 0.2 * t)), borderRadius: BorderRadius.circular(0)),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }),
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Chip(label: Text(rarity, style: TextStyle(color: _rarityColor(rarity).computeLuminance() > 0.5 ? Colors.black : Colors.white)), backgroundColor: _rarityColor(rarity)),
                )
              ],
            ),
            SliverPadding(
              padding: const EdgeInsets.all(12),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('Stats', style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 8),
                        Wrap(spacing: 8, runSpacing: 8, children: [
                          _statTile(Icons.security, 'Body', stats.bodyDamage.toStringAsFixed(1), _rarityColor(rarity)),
                          _statTile(Icons.person, 'Head', stats.headDamage.toStringAsFixed(1), _rarityColor(rarity)),
                          _statTile(Icons.bolt, 'DPS', stats.dps.toStringAsFixed(1), _rarityColor(rarity)),
                          _statTile(Icons.format_list_numbered, 'Clip', '${stats.clipSize}', _rarityColor(rarity)),
                          _statTile(Icons.autorenew, 'Reload', '${stats.reloadTime.toStringAsFixed(2)}s', _rarityColor(rarity)),
                          _statTile(Icons.speed, 'FireRate', '${stats.fireRate.toStringAsFixed(2)}/s', _rarityColor(rarity)),
                        ])
                      ]),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Perks & Traits', style: Theme.of(context).textTheme.titleMedium), IconButton(icon: const Icon(Icons.info_outline), onPressed: () {})]),
                        const SizedBox(height: 8),
                        Wrap(spacing: 8, children: (widget.weapon.perksByRarity[rarity] ?? ['Higher rarities may include unique traits.']).map((p) => Chip(label: Text(p))).toList()),
                      ]),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text('Data last updated: ${prov.lastUpdated}', style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 8),
                  Text('Check official patch notes on playhighguard.com or @PlayHighguard for latest balances', style: Theme.of(context).textTheme.bodySmall?.copyWith(decoration: TextDecoration.underline)),
                  const SizedBox(height: 40),
                ]),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Change Rarity'),
        icon: const Icon(Icons.change_circle),
        onPressed: () => _showRaritySheet(context, prov),
      ),
    );
  }

  Widget _statTile(IconData icon, String label, String value, Color accent) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.black12),
      child: Row(children: [
        CircleAvatar(backgroundColor: accent, child: Icon(icon, color: Colors.white, size: 18)),
        const SizedBox(width: 8),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: const TextStyle(fontSize: 12, color: Colors.white70)), Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))])
      ]),
    );
  }

  void _showRaritySheet(BuildContext context, WeaponProvider prov) {
    showModalBottomSheet(
      context: context,
      builder: (c) {
        return ListView(
          children: prov.rarities.map((r) {
            return ListTile(
              leading: CircleAvatar(backgroundColor: _rarityColor(r)),
              title: Text(r),
              onTap: () {
                prov.setRarity(r);
                Navigator.of(context).pop();
              },
            );
          }).toList(),
        );
      },
    );
  }
}
