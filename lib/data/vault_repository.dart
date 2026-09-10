import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/vault_item.dart';
import 'demo_data.dart';

final vaultRepositoryProvider = Provider<VaultRepository>((ref) => VaultRepository());

class VaultRepository {
  final List<VaultItem> _items = List.of(demoItems);
  List<VaultItem> get items => List.unmodifiable(_items);

  Future<void> add(VaultItem item) async => _items.insert(0, item);
  Future<void> update(VaultItem item) async {
    final i = _items.indexWhere((x) => x.id == item.id);
    if (i >= 0) _items[i] = item;
  }
  Future<void> archive(VaultItem item) async => update(item.copyWith(archived: true));
  Future<void> toggleFavorite(VaultItem item) async => update(item.copyWith(favorite: !item.favorite));
}
