/// User model matching Convex schema (convex/schema.ts - users table)
class User {
  final String id; // Convex _id
  final String twitterId;
  final String username;
  final String name;
  final String? avatar; // Legacy field
  final String? avatarUrl; // Original Twitter URL
  final String? avatarStorageId; // Convex storage ID

  // Twitter Stats
  final String followers;
  final String posts;
  final String likes;

  // Card Customization
  final String badge;
  final String accentColor;

  // Wallet Info
  final String? wallet;
  final String? chain;

  // Generated GIF
  final String? gifUrl; // Legacy field
  final String? gifStorageId; // Convex file storage ID

  // Profile Verification
  final String? profileHash;
  final String? tweetUrl;
  final bool isVerified;

  // Metadata
  final int createdAt;
  final int updatedAt;

  User({
    required this.id,
    required this.twitterId,
    required this.username,
    required this.name,
    this.avatar,
    this.avatarUrl,
    this.avatarStorageId,
    required this.followers,
    required this.posts,
    required this.likes,
    required this.badge,
    required this.accentColor,
    this.wallet,
    this.chain,
    this.gifUrl,
    this.gifStorageId,
    this.profileHash,
    this.tweetUrl,
    this.isVerified = false,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create User from JSON (Convex API response)
  factory User.fromJson(Map<String, dynamic> json) {
    // Helper to safely convert numbers (Convex returns doubles for timestamps)
    int? _toInt(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is double) return value.toInt();
      return null;
    }

    return User(
      id: json['_id'] as String,
      twitterId: json['twitterId'] as String,
      username: json['username'] as String,
      name: json['name'] as String,
      avatar: json['avatar'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      avatarStorageId: json['avatarStorageId'] as String?,
      followers: json['followers'] as String? ?? '0',
      posts: json['posts'] as String? ?? '0',
      likes: json['likes'] as String? ?? '0',
      badge: json['badge'] as String? ?? 'Creator',
      accentColor: json['accentColor'] as String? ?? '#22c55e',
      wallet: json['wallet'] as String?,
      chain: json['chain'] as String?,
      gifUrl: json['gifUrl'] as String?,
      gifStorageId: json['gifStorageId'] as String?,
      profileHash: json['profileHash'] as String?,
      tweetUrl: json['tweetUrl'] as String?,
      isVerified: json['isVerified'] as bool? ?? false,
      createdAt: _toInt(json['createdAt']) ?? DateTime.now().millisecondsSinceEpoch,
      updatedAt: _toInt(json['updatedAt']) ?? DateTime.now().millisecondsSinceEpoch,
    );
  }

  /// Convert User to JSON (for API requests)
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'twitterId': twitterId,
      'username': username,
      'name': name,
      if (avatar != null) 'avatar': avatar,
      if (avatarUrl != null) 'avatarUrl': avatarUrl,
      if (avatarStorageId != null) 'avatarStorageId': avatarStorageId,
      'followers': followers,
      'posts': posts,
      'likes': likes,
      'badge': badge,
      'accentColor': accentColor,
      if (wallet != null) 'wallet': wallet,
      if (chain != null) 'chain': chain,
      if (gifUrl != null) 'gifUrl': gifUrl,
      if (gifStorageId != null) 'gifStorageId': gifStorageId,
      if (profileHash != null) 'profileHash': profileHash,
      if (tweetUrl != null) 'tweetUrl': tweetUrl,
      'isVerified': isVerified,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  /// Create a copy with updated fields
  User copyWith({
    String? id,
    String? twitterId,
    String? username,
    String? name,
    String? avatar,
    String? avatarUrl,
    String? avatarStorageId,
    String? followers,
    String? posts,
    String? likes,
    String? badge,
    String? accentColor,
    String? wallet,
    String? chain,
    String? gifUrl,
    String? gifStorageId,
    String? profileHash,
    String? tweetUrl,
    bool? isVerified,
    int? createdAt,
    int? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      twitterId: twitterId ?? this.twitterId,
      username: username ?? this.username,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      avatarStorageId: avatarStorageId ?? this.avatarStorageId,
      followers: followers ?? this.followers,
      posts: posts ?? this.posts,
      likes: likes ?? this.likes,
      badge: badge ?? this.badge,
      accentColor: accentColor ?? this.accentColor,
      wallet: wallet ?? this.wallet,
      chain: chain ?? this.chain,
      gifUrl: gifUrl ?? this.gifUrl,
      gifStorageId: gifStorageId ?? this.gifStorageId,
      profileHash: profileHash ?? this.profileHash,
      tweetUrl: tweetUrl ?? this.tweetUrl,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
