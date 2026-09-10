import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/supabase_client.dart';
import '../models/vault_item.dart';
import 'demo_data.dart';

final vaultRepositoryProvider = Provider<VaultRepository>((ref) => VaultRepository());

class VaultRepository {
  final List<VaultItem> _items = List.of(demoItems);
  List<VaultItem> get items => List.unmodifiable(_items);

  Future<void> load() async {
    if (!supabaseConfigured || Supabase.instance.client.auth.currentUser == null) return;
    final rows = await supabase.from('items').select().order('created_at', ascending: false);
    _items..clear()..addAll(rows.map(_fromRow));
  }

  Future<void> add(VaultItem item) async {
    final user = supabaseConfigured ? supabase.auth.currentUser : null;
    if (user == null) { _items.insert(0, item); return; }
    await supabase.from('items').insert(_toRow(item, user.id));
    _items.insert(0, item);
  }

  Future<void> update(VaultItem item) async {
    final i = _items.indexWhere((x) => x.id == item.id);
    if (i >= 0) _items[i] = item;
    final user = supabaseConfigured ? supabase.auth.currentUser : null;
    if (user != null) {
      final row = _toRow(item, user.id)..remove('user_id')..remove('id');
      await supabase.from('items').update(row).eq('id', item.id).eq('user_id', user.id);
    }
  }

  Future<void> archive(VaultItem item) => update(item.copyWith(archived: true));
  Future<void> toggleFavorite(VaultItem item) => update(item.copyWith(favorite: !item.favorite));

  Map<String, dynamic> _toRow(VaultItem item, String userId) => {
    'id': item.id, 'user_id': userId, 'type': item.type.name, 'title': item.title,
    'body': item.body, 'url': item.url.isEmpty ? null : item.url,
    'source': _source(item.source), 'ai_provider': item.type == ItemType.conversation ? _provider(item.source) : null,
    'summary': item.body, 'thumbnail_url': item.thumbnail, 'pinned': item.pinned,
    'favorite': item.favorite, 'archived': item.archived,
    'created_at': item.createdAt.toIso8601String(), 'updated_at': DateTime.now().toIso8601String(),
  };

  VaultItem _fromRow(Map<String, dynamic> row) => VaultItem(
    id: row['id'] as String, type: ItemType.values.byName(row['type'] as String), title: row['title'] as String,
    body: (row['body'] as String?) ?? '', url: (row['url'] as String?) ?? '', source: (row['source'] as String?) ?? 'manual',
    createdAt: DateTime.parse(row['created_at'] as String), tags: const [], thumbnail: row['thumbnail_url'] as String?,
    favorite: row['favorite'] as bool? ?? false, pinned: row['pinned'] as bool? ?? false, archived: row['archived'] as bool? ?? false,
  );

  String _source(String source) => const {'youtube','instagram','x','url','manual'}.contains(source.toLowerCase()) ? source.toLowerCase() : 'manual';
  String _provider(String source) => const {'chatgpt','grok','gemini','other'}.contains(source.toLowerCase()) ? source.toLowerCase() : 'other';
}
