/// StreamCard model matching Convex schema (convex/schema.ts - streamCards table)
class StreamCard {
  final String id; // Convex _id
  final String userId; // Foreign key to users

  // Card content
  final String title;
  final String description;
  final String? category; // 'gaming', 'music', 'art', 'tech', 'finance', etc.

  // Banner media (1500x500 - shown on detail page header)
  final String bannerStorageId; // Convex storage ID
  final String bannerType; // 'image' | 'video' | 'gif'
  final String? bannerMimeType;

  // Stream media (Twitter-compatible formats - shown on wall feed)
  final String? mediaStorageId;
  final String? mediaType; // 'image' | 'video' | 'gif'
  final String? mediaMimeType;
  final String? mediaAspectRatio; // '16:9' | '1:1' | '9:16' | '4:5'
  final int? mediaLikes;

  // Social links
  final List<SocialLink> socialLinks;

  // Token/Asset attachment
  final TokenAttachment? token;

  // Analytics & Engagement
  final int views;
  final int upvotes;
  final int downvotes;
  final int commentCount;

  // Timestamps
  final int createdAt;
  final int updatedAt;

  // Populated user data (from getStreamCardById query)
  final Map<String, dynamic>? user;

  StreamCard({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    this.category,
    required this.bannerStorageId,
    required this.bannerType,
    this.bannerMimeType,
    this.mediaStorageId,
    this.mediaType,
    this.mediaMimeType,
    this.mediaAspectRatio,
    this.mediaLikes,
    this.socialLinks = const [],
    this.token,
    this.views = 0,
    this.upvotes = 0,
    this.downvotes = 0,
    this.commentCount = 0,
    required this.createdAt,
    required this.updatedAt,
    this.user,
  });

  factory StreamCard.fromJson(Map<String, dynamic> json) {
    // Helper to safely convert numbers (Convex returns doubles for all numbers)
    int? _toInt(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is double) return value.toInt();
      return null;
    }

    return StreamCard(
      id: json['_id'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String?,
      bannerStorageId: json['bannerStorageId'] as String,
      bannerType: json['bannerType'] as String,
      bannerMimeType: json['bannerMimeType'] as String?,
      mediaStorageId: json['mediaStorageId'] as String?,
      mediaType: json['mediaType'] as String?,
      mediaMimeType: json['mediaMimeType'] as String?,
      mediaAspectRatio: json['mediaAspectRatio'] as String?,
      mediaLikes: _toInt(json['mediaLikes']),
      socialLinks: (json['socialLinks'] as List<dynamic>?)
              ?.map((e) => SocialLink.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      token: json['token'] != null
          ? TokenAttachment.fromJson(json['token'] as Map<String, dynamic>)
          : null,
      views: _toInt(json['views']) ?? 0,
      upvotes: _toInt(json['upvotes']) ?? 0,
      downvotes: _toInt(json['downvotes']) ?? 0,
      commentCount: _toInt(json['commentCount']) ?? 0,
      createdAt: _toInt(json['createdAt']) ?? DateTime.now().millisecondsSinceEpoch,
      updatedAt: _toInt(json['updatedAt']) ?? DateTime.now().millisecondsSinceEpoch,
      user: json['user'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'title': title,
      'description': description,
      if (category != null) 'category': category,
      'bannerStorageId': bannerStorageId,
      'bannerType': bannerType,
      if (bannerMimeType != null) 'bannerMimeType': bannerMimeType,
      if (mediaStorageId != null) 'mediaStorageId': mediaStorageId,
      if (mediaType != null) 'mediaType': mediaType,
      if (mediaMimeType != null) 'mediaMimeType': mediaMimeType,
      if (mediaAspectRatio != null) 'mediaAspectRatio': mediaAspectRatio,
      if (mediaLikes != null) 'mediaLikes': mediaLikes,
      'socialLinks': socialLinks.map((e) => e.toJson()).toList(),
      if (token != null) 'token': token!.toJson(),
      'views': views,
      'upvotes': upvotes,
      'downvotes': downvotes,
      'commentCount': commentCount,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      if (user != null) 'user': user,
    };
  }
}

/// Social link for stream cards
class SocialLink {
  final String platform; // 'twitter', 'telegram', 'discord', etc.
  final String url;
  final String? label; // For 'other' platform

  SocialLink({
    required this.platform,
    required this.url,
    this.label,
  });

  factory SocialLink.fromJson(Map<String, dynamic> json) {
    return SocialLink(
      platform: json['platform'] as String,
      url: json['url'] as String,
      label: json['label'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'platform': platform,
      'url': url,
      if (label != null) 'label': label,
    };
  }
}

/// Token/NFT attachment for stream cards
class TokenAttachment {
  final String type; // 'token' | 'nft' | 'ordinal' | 'other'
  final String chain; // 'evm', 'solana', 'bitcoin', etc.
  final String? address; // Contract address for tokens
  final String? link; // External link for NFTs/other
  final Map<String, dynamic>? metadata; // Cached metadata

  TokenAttachment({
    required this.type,
    required this.chain,
    this.address,
    this.link,
    this.metadata,
  });

  factory TokenAttachment.fromJson(Map<String, dynamic> json) {
    return TokenAttachment(
      type: json['type'] as String,
      chain: json['chain'] as String,
      address: json['address'] as String?,
      link: json['link'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'chain': chain,
      if (address != null) 'address': address,
      if (link != null) 'link': link,
      if (metadata != null) 'metadata': metadata,
    };
  }
}
