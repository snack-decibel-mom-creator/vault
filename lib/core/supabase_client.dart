import 'package:supabase_flutter/supabase_flutter.dart';

const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
const supabasePublishableKey = String.fromEnvironment('SUPABASE_PUBLISHABLE_KEY');

Future<void> initializeSupabase() async {
  if (!supabaseConfigured) return;
  await Supabase.initialize(url: supabaseUrl, publishableKey: supabasePublishableKey);
}

bool get supabaseConfigured => supabaseUrl.isNotEmpty && supabasePublishableKey.isNotEmpty;
SupabaseClient get supabase => Supabase.instance.client;
