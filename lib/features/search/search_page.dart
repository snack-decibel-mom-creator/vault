import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme.dart';
import '../../data/vault_repository.dart';
import '../../widgets/vault_card.dart';

class SearchPage extends ConsumerStatefulWidget { const SearchPage({super.key}); @override ConsumerState<SearchPage> createState()=>_SearchPageState(); }
class _SearchPageState extends ConsumerState<SearchPage> { final q=TextEditingController(); @override Widget build(BuildContext context){ final all=ref.watch(vaultRepositoryProvider).items; final query=q.text.toLowerCase(); final items=all.where((x)=>query.isEmpty||'${x.title} ${x.description} ${x.body} ${x.tags.join(' ')}'.toLowerCase().contains(query)).toList(); return Padding(padding:const EdgeInsets.fromLTRB(28,28,28,0),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[const Text('Search',style:TextStyle(fontSize:26,fontWeight:FontWeight.w700)),const SizedBox(height:6),const Text('Search across thoughts, content, tools, and AI conversations.',style:TextStyle(color:VaultColors.muted,fontSize:13)),const SizedBox(height:20),TextField(controller:q,onChanged:(_)=>setState((){}),decoration:const InputDecoration(prefixIcon:Icon(Icons.search_rounded),hintText:'Search everything...',suffixText:'⌘ K')),const SizedBox(height:16),Expanded(child:GridView.builder(gridDelegate:const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent:360,mainAxisExtent:210,crossAxisSpacing:12,mainAxisSpacing:12),itemCount:items.length,itemBuilder:(c,i)=>VaultCard(item:items[i])))])); } }
