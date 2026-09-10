import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme.dart';
import '../../data/vault_repository.dart';
import '../../models/vault_item.dart';
import '../../widgets/vault_card.dart';

class DashboardPage extends ConsumerWidget {
  final void Function(ItemType type) onCapture;
  const DashboardPage({super.key, required this.onCapture});
  @override Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(vaultRepositoryProvider).items.where((x)=>!x.archived).toList();
    return CustomScrollView(slivers: [
      SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.fromLTRB(28,28,28,22), child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
        const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Good afternoon.', style: TextStyle(fontSize:28,fontWeight:FontWeight.w700,letterSpacing:-.7)), SizedBox(height:6), Text('Your thinking, tools, and references — in one quiet place.', style: TextStyle(color:VaultColors.muted,fontSize:13))])),
        _Shortcut('⌘ K', 'Search'), const SizedBox(width:8), FilledButton.icon(onPressed:()=>onCapture(ItemType.thought), icon:const Icon(Icons.add_rounded,size:18), label:const Text('Capture')),
      ]))),
      SliverPadding(padding: const EdgeInsets.symmetric(horizontal:28), sliver: SliverToBoxAdapter(child: Row(children: [_Metric(label:'THOUGHTS',value:'12',delta:'+3 this week'),_Metric(label:'SAVED',value:'38',delta:'7 unread'),_Metric(label:'TOOLS',value:'16',delta:'4 favorites'),_Metric(label:'AI CHATS',value:'24',delta:'5 this week')]))),
      SliverToBoxAdapter(child: Padding(padding:const EdgeInsets.fromLTRB(28,28,28,14), child: Row(children:[const Text('Recent',style:TextStyle(fontSize:16,fontWeight:FontWeight.w600)),const Spacer(),Text('View all  →',style:TextStyle(color:VaultColors.muted,fontSize:12))]))),
      SliverPadding(padding:const EdgeInsets.fromLTRB(28,0,28,28), sliver: SliverGrid(delegate:SliverChildBuilderDelegate((c,i)=>VaultCard(item:items[i],onFavorite:()=>ref.read(vaultRepositoryProvider).toggleFavorite(items[i])),childCount:items.length > 6 ? 6 : items.length),gridDelegate:const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent:360,mainAxisExtent:210,crossAxisSpacing:12,mainAxisSpacing:12))),
    ]);
  }
}
class _Metric extends StatelessWidget { final String label,value,delta; const _Metric({required this.label,required this.value,required this.delta}); @override Widget build(BuildContext c)=>Expanded(child:Container(margin:const EdgeInsets.only(right:10),padding:const EdgeInsets.all(16),decoration:BoxDecoration(color:VaultColors.surface,border:Border.all(color:VaultColors.border),borderRadius:BorderRadius.circular(14)),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(label,style:const TextStyle(fontFamily:'Geist Mono',fontSize:9,color:VaultColors.muted,letterSpacing:1)),const SizedBox(height:8),Text(value,style:const TextStyle(fontSize:26,fontWeight:FontWeight.w700)),const SizedBox(height:4),Text(delta,style:const TextStyle(fontFamily:'Geist Mono',fontSize:9,color:VaultColors.green))]))); }
class _Shortcut extends StatelessWidget { final String keyText,label; const _Shortcut(this.keyText,this.label); @override Widget build(BuildContext c)=>Container(padding:const EdgeInsets.symmetric(horizontal:10,vertical:9),decoration:BoxDecoration(border:Border.all(color:VaultColors.border),borderRadius:BorderRadius.circular(9)),child:Row(children:[Text(keyText,style:const TextStyle(fontFamily:'Geist Mono',fontSize:10,color:VaultColors.muted)),const SizedBox(width:8),Text(label,style:const TextStyle(fontSize:12))])); }
