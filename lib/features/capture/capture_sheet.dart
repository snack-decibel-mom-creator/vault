import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../core/theme.dart';
import '../../data/vault_repository.dart';
import '../../models/vault_item.dart';

Future<void> showCaptureSheet(BuildContext context, VaultRepository repo, {ItemType initial = ItemType.thought}) async {
  await showModalBottomSheet(context: context, isScrollControlled:true, backgroundColor:Colors.transparent, builder:(context)=>_CaptureSheet(repo:repo, initial:initial));
}
class _CaptureSheet extends StatefulWidget { final VaultRepository repo; final ItemType initial; const _CaptureSheet({required this.repo,required this.initial}); @override State<_CaptureSheet> createState()=>_CaptureSheetState(); }
class _CaptureSheetState extends State<_CaptureSheet> {
  late ItemType type;
  final title=TextEditingController(); final body=TextEditingController(); final url=TextEditingController();
  @override void initState() { super.initState(); type = widget.initial; }
  @override void dispose() { title.dispose(); body.dispose(); url.dispose(); super.dispose(); }
  @override Widget build(BuildContext context)=>SafeArea(child:Container(padding:EdgeInsets.only(left:22,right:22,top:20,bottom:20+MediaQuery.of(context).viewInsets.bottom),decoration:const BoxDecoration(color:VaultColors.surface,borderRadius:BorderRadius.vertical(top:Radius.circular(22))),child:SingleChildScrollView(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
    Row(children:[const Text('Quick capture',style:TextStyle(fontSize:20,fontWeight:FontWeight.w700)),const Spacer(),IconButton(onPressed:()=>Navigator.pop(context),icon:const Icon(Icons.close))]),const SizedBox(height:16),
    SegmentedButton<ItemType>(segments:const [ButtonSegment(value:ItemType.thought,label:Text('Thought'),icon:Icon(Icons.bolt_rounded)),ButtonSegment(value:ItemType.content,label:Text('URL'),icon:Icon(Icons.link_rounded)),ButtonSegment(value:ItemType.tool,label:Text('Tool'),icon:Icon(Icons.build_outlined)),ButtonSegment(value:ItemType.conversation,label:Text('AI chat'),icon:Icon(Icons.forum_outlined))],selected:{type},onSelectionChanged:(x)=>setState(()=>type=x.first)),const SizedBox(height:16),
    TextField(controller:title,autofocus:true,decoration:const InputDecoration(labelText:'Title',hintText:'What are you saving?')),const SizedBox(height:10),
    if(type==ItemType.content || type==ItemType.tool) ...[TextField(controller:url,decoration:const InputDecoration(labelText:'URL',hintText:'https://...')),const SizedBox(height:10)],
    TextField(controller:body,maxLines:5,decoration:InputDecoration(labelText:type==ItemType.thought?'Thought': 'Notes',hintText:type==ItemType.conversation?'Paste conversation or a useful excerpt...':'Add context, summary, or notes...')),const SizedBox(height:16),
    SizedBox(width:double.infinity,height:48,child:FilledButton.icon(onPressed:save,icon:const Icon(Icons.check_rounded),label:const Text('Save to Vault'))),
  ]))));
  Future<void> save() async { if(title.text.trim().isEmpty) return; await widget.repo.add(VaultItem(id:const Uuid().v4(),type:type,title:title.text.trim(),body:body.text.trim(),url:url.text.trim(),source:type==ItemType.conversation?'Manual':type.name,createdAt:DateTime.now(),tags:const ['demo'])); if(mounted) { Navigator.pop(context); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('Saved to Vault'))); } }
}
