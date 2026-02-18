import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/services.dart';

import '../models/weapon.dart';

class WeaponCard extends StatefulWidget {
  final Weapon weapon;
  final VoidCallback onTap;
  final bool isFav;
  final VoidCallback onFavToggle;

  const WeaponCard({Key? key, required this.weapon, required this.onTap, required this.isFav, required this.onFavToggle}) : super(key: key);

  @override
  State<WeaponCard> createState() => _WeaponCardState();
}

class _WeaponCardState extends State<WeaponCard> {
  String _sourceLabel = '';

  @override
  void initState() {
    super.initState();
    _sourceLabel = (widget.weapon.imageUrl != null && widget.weapon.imageUrl!.startsWith('assets/')) ? 'ASSET' : 'NETWORK';
  }

  @override
  Widget build(BuildContext context) {
    final gradient = LinearGradient(colors: [Colors.indigo.shade900, Colors.deepPurple.shade800], begin: Alignment.topLeft, end: Alignment.bottomRight);
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        widget.onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), gradient: gradient, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 6))]),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(widget.weapon.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white))),
                IconButton(icon: Icon(widget.isFav ? Icons.favorite : Icons.favorite_border, color: widget.isFav ? Colors.redAccent : Colors.white), onPressed: widget.onFavToggle),
              ],
            ),
            const SizedBox(height: 6),
            Expanded(
              child: Stack(children: [
                Hero(
                  tag: 'weapon-${widget.weapon.name}',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: (widget.weapon.imageUrl != null && widget.weapon.imageUrl!.startsWith('assets/'))
                        ? SvgPicture.asset(widget.weapon.imageUrl!, fit: BoxFit.cover, width: double.infinity)
                        : CachedNetworkImage(
                            imageUrl: (widget.weapon.imageUrl != null && widget.weapon.imageUrl!.isNotEmpty) ? widget.weapon.imageUrl! : 'https://picsum.photos/800/450',
                            fit: BoxFit.cover,
                            width: double.infinity,
                            placeholder: (c, u) => Shimmer.fromColors(
                              baseColor: Colors.grey.shade800,
                              highlightColor: Colors.grey.shade600,
                              child: Container(color: Colors.grey.shade800),
                            ),
                            imageBuilder: (context, imageProvider) {
                              // mark success
                              if (mounted) setState(() => _sourceLabel = 'NETWORK');
                              return Container(decoration: BoxDecoration(image: DecorationImage(image: imageProvider, fit: BoxFit.cover)));
                            },
                            errorWidget: (c, u, e) {
                              if (mounted) setState(() => _sourceLabel = 'ERROR');
                              return Container(color: Colors.grey.shade800, child: const Center(child: Icon(Icons.broken_image, color: Colors.white)));
                            },
                          ),
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(8)),
                    child: Row(children: [
                      Container(width: 8, height: 8, decoration: BoxDecoration(color: _sourceLabel == 'ASSET' ? Colors.green : (_sourceLabel == 'NETWORK' ? Colors.blue : Colors.red), shape: BoxShape.circle)),
                      const SizedBox(width: 6),
                      Text(_sourceLabel, style: const TextStyle(color: Colors.white, fontSize: 12)),
                    ]),
                  ),
                )
              ]),
            ),
            const SizedBox(height: 8),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Chip(label: Text(widget.weapon.type, style: const TextStyle(color: Colors.white)), backgroundColor: Colors.black26),
              Text('${widget.weapon.base.clipSize} • ${widget.weapon.base.projectilesPerShot}p', style: const TextStyle(color: Colors.white70)),
            ])
          ],
        ),
      ).animate().scale(duration: 250.ms, curve: Curves.easeOut),
    );
  }
}
