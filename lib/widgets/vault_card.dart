import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../models/vault_item.dart';

class VaultCard extends StatefulWidget {
  final VaultItem item;
  final VoidCallback? onTap;
  final VoidCallback? onFavorite;
  const VaultCard({super.key, required this.item, this.onTap, this.onFavorite});
  @override State<VaultCard> createState() => _VaultCardState();
}

class _VaultCardState extends State<VaultCard> {
  bool hover = false;
  @override
  Widget build(BuildContext context) {
    final i = widget.item;
    return MouseRegion(
      onEnter: (_) => setState(() => hover = true), onExit: (_) => setState(() => hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        transform: Matrix4.identity()..translate(0.0, hover ? -2.0 : 0.0),
        child: InkWell(onTap: widget.onTap, borderRadius: BorderRadius.circular(14), child: Card(
          child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              _TypeIcon(type: i.type), const SizedBox(width: 10),
              Expanded(child: Text(i.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w650, fontSize: 15))),
              IconButton(visualDensity: VisualDensity.compact, tooltip: 'Favorite', onPressed: widget.onFavorite, icon: Icon(i.favorite ? Icons.star_rounded : Icons.star_border_rounded, color: i.favorite ? VaultColors.yellow : VaultColors.muted, size: 19)),
            ]),
            if (i.description.isNotEmpty) ...[const SizedBox(height: 9), Text(i.description, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: VaultColors.muted, height: 1.45, fontSize: 13))],
            const Spacer(),
            Wrap(spacing: 6, runSpacing: 6, children: i.tags.take(3).map((t) => _Tag(t)).toList()),
            const SizedBox(height: 11),
            Row(children: [Text(_typeLabel(i), style: const TextStyle(fontFamily: 'Geist Mono', color: VaultColors.muted, fontSize: 10)), const Spacer(), Text(_relative(i.createdAt), style: const TextStyle(fontFamily: 'Geist Mono', color: VaultColors.muted, fontSize: 10))]),
          ])),),
      ),
    );
  }
  String _typeLabel(VaultItem i) => switch (i.type) { ItemType.thought => 'THOUGHT', ItemType.content => (i.contentSource?.name ?? 'URL').toUpperCase(), ItemType.tool => 'TOOL', ItemType.conversation => (i.provider?.name ?? 'AI').toUpperCase() };
  String _relative(DateTime d) { final x = DateTime.now().difference(d); if (x.inMinutes < 60) return '${x.inMinutes}m'; if (x.inHours < 24) return '${x.inHours}h'; return '${x.inDays}d'; }
}
class _Tag extends StatelessWidget { final String text; const _Tag(this.text); @override Widget build(BuildContext c) => Container(padding: const EdgeInsets.symmetric(horizontal:7, vertical:4), decoration: BoxDecoration(color: VaultColors.surface2, borderRadius: BorderRadius.circular(6), border: Border.all(color: VaultColors.border)), child: Text('#$text', style: const TextStyle(fontFamily:'Geist Mono', fontSize:10, color:VaultColors.muted))); }
class _TypeIcon extends StatelessWidget { final ItemType type; const _TypeIcon({required this.type}); @override Widget build(BuildContext c) { final icon = switch(type){ItemType.thought=>Icons.bolt_rounded,ItemType.content=>Icons.bookmark_border_rounded,ItemType.tool=>Icons.build_outlined,ItemType.conversation=>Icons.forum_outlined}; return Container(width:30,height:30,decoration:BoxDecoration(color:VaultColors.redSoft,borderRadius:BorderRadius.circular(8)),child:Icon(icon,size:16,color:VaultColors.red)); }}
