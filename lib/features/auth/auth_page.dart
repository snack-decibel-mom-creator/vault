import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/supabase_client.dart';
import '../../core/theme.dart';

class AuthPage extends StatefulWidget { const AuthPage({super.key}); @override State<AuthPage> createState()=>_AuthPageState(); }
class _AuthPageState extends State<AuthPage> {
  bool signup=false, loading=false;
  final email=TextEditingController(); final password=TextEditingController();
  @override void dispose(){email.dispose();password.dispose();super.dispose();}
  Future<void> submit() async {
    if(!supabaseConfigured){ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('Configure Supabase keys to sign in.')));return;}
    setState(()=>loading=true);
    try {
      final result=signup ? await supabase.auth.signUp(email:email.text.trim(),password:password.text) : await supabase.auth.signInWithPassword(email:email.text.trim(),password:password.text);
      if(!mounted)return;
      if(result.session!=null) Navigator.of(context).pop(true); else if(signup) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('Check your email to confirm your account.')));
    } on AuthException catch(e){if(mounted)ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text(e.message)));}
    finally{if(mounted)setState(()=>loading=false);}
  }
  @override Widget build(BuildContext context)=>Scaffold(body:Center(child:ConstrainedBox(constraints:const BoxConstraints(maxWidth:420),child:Padding(padding:const EdgeInsets.all(24),child:Column(mainAxisAlignment:MainAxisAlignment.center,crossAxisAlignment:CrossAxisAlignment.start,children:[
    Row(children:[Container(width:34,height:34,decoration:BoxDecoration(color:VaultColors.red,borderRadius:BorderRadius.circular(10)),child:const Icon(Icons.all_inclusive_rounded,color:Colors.white,size:19)),const SizedBox(width:10),const Text('Vault',style:TextStyle(fontSize:22,fontWeight:FontWeight.w700))]),const SizedBox(height:42),Text(signup?'Create your Vault':'Welcome back',style:const TextStyle(fontSize:30,fontWeight:FontWeight.w700)),const SizedBox(height:8),const Text('Your personal knowledge system, beautifully organized.',style:TextStyle(color:VaultColors.muted)),const SizedBox(height:24),TextField(controller:email,keyboardType:TextInputType.emailAddress,decoration:const InputDecoration(labelText:'Email')),const SizedBox(height:12),TextField(controller:password,obscureText:true,decoration:const InputDecoration(labelText:'Password')),const SizedBox(height:18),SizedBox(width:double.infinity,height:48,child:FilledButton(onPressed:loading?null:submit,child:Text(loading?'Please wait…':signup?'Create account':'Sign in'))),const SizedBox(height:12),Center(child:TextButton(onPressed:loading?null:()=>setState(()=>signup=!signup),child:Text(signup?'Already have an account? Sign in':'New here? Create an account')))
  ]))));
}
