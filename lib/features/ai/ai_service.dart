import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/supabase_client.dart';

class AiService {
  const AiService();

  Future<String> ask({
    required String prompt,
    String context = '',
    String task = 'answer',
    String model = 'gpt-5.6-luna',
  }) async {
    if (!supabaseConfigured) {
      throw const AuthException('Supabase is not configured.');
    }
    if (supabase.auth.currentSession == null) {
      throw const AuthException('Sign in to use Vault AI.');
    }

    final response = await supabase.functions.invoke(
      'vault-ai',
      body: {
        'task': task,
        'prompt': prompt,
        'context': context,
        'model': model,
      },
    );

    final data = response.data;
    if (data is Map && data['text'] is String) return data['text'] as String;
    if (data is Map && data['error'] is String) throw Exception(data['error']);
    throw Exception('Vault AI returned an invalid response.');
  }
}
