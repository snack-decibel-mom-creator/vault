enum ItemType { thought, content, tool, conversation }

enum ContentSource { youtube, instagram, x, url, manual }

enum AIProvider { chatgpt, grok, gemini, other }

class VaultItem {
  final String id;
  final ItemType type;
  final String title;
  final String description;
  final String body;
  final String url;
  final String source;
  final String? thumbnail;
  final DateTime createdAt;
  final List<String> tags;
  final bool favorite;
  final bool archived;
  final bool pinned;
  final ContentSource? contentSource;
  final AIProvider? provider;
  final int? rating;

  const VaultItem({
    required this.id,
    required this.type,
    required this.title,
    this.description = '',
    this.body = '',
    this.url = '',
    this.source = '',
    this.thumbnail,
    required this.createdAt,
    this.tags = const [],
    this.favorite = false,
    this.archived = false,
    this.pinned = false,
    this.contentSource,
    this.provider,
    this.rating,
  });

  VaultItem copyWith({bool? favorite, bool? archived, bool? pinned}) => VaultItem(
    id: id,
    type: type,
    title: title,
    description: description,
    body: body,
    url: url,
    source: source,
    thumbnail: thumbnail,
    createdAt: createdAt,
    tags: tags,
    favorite: favorite ?? this.favorite,
    archived: archived ?? this.archived,
    pinned: pinned ?? this.pinned,
    contentSource: contentSource,
    provider: provider,
    rating: rating,
  );
}
