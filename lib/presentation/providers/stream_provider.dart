import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/convex_client.dart';
import '../../data/models/stream_card.dart';

/// Provider for Convex client
final convexClientProvider = Provider<ConvexClient>((ref) {
  return ConvexClient();
});

/// Provider to fetch all stream cards
final allStreamCardsProvider = FutureProvider<List<StreamCard>>((ref) async {
  final client = ref.watch(convexClientProvider);

  try {
    final result = await client.query<List<dynamic>>(
      'streamCards.getAllStreamCards',
    );

    return result
        .map((json) => StreamCard.fromJson(json as Map<String, dynamic>))
        .toList();
  } catch (e) {
    print('Error fetching stream cards: $e');
    return [];
  }
});

/// Provider to fetch a specific stream card by ID
final streamCardByIdProvider = FutureProvider.family<StreamCard?, String>((ref, id) async {
  final client = ref.watch(convexClientProvider);

  try {
    final result = await client.query<Map<String, dynamic>>(
      'streamCards.getStreamCardById',
      {'streamCardId': id},
    );

    if (result.isEmpty) return null;
    return StreamCard.fromJson(result);
  } catch (e) {
    print('Error fetching stream card: $e');
    return null;
  }
});

/// Provider to fetch stream cards by user ID
final streamCardsByUserProvider = FutureProvider.family<List<StreamCard>, String>((ref, userId) async {
  final client = ref.watch(convexClientProvider);

  try {
    final result = await client.query<List<dynamic>>(
      'streamCards.getStreamCardsByUser',
      {'userId': userId},
    );

    return result
        .map((json) => StreamCard.fromJson(json as Map<String, dynamic>))
        .toList();
  } catch (e) {
    print('Error fetching user stream cards: $e');
    return [];
  }
});

/// Stream media item model
class StreamMedia {
  final String id;
  final String streamCardId;
  final String userId;
  final String storageId;
  final String mediaType; // 'image' | 'video' | 'gif'
  final String? mimeType;
  final String? aspectRatio;
  final int likes;
  final int createdAt;

  // Populated fields
  final StreamCard? streamCard;
  final dynamic user;

  StreamMedia({
    required this.id,
    required this.streamCardId,
    required this.userId,
    required this.storageId,
    required this.mediaType,
    this.mimeType,
    this.aspectRatio,
    this.likes = 0,
    required this.createdAt,
    this.streamCard,
    this.user,
  });

  factory StreamMedia.fromJson(Map<String, dynamic> json) {
    // Helper to convert doubles to ints
    int? _toInt(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is double) return value.toInt();
      return null;
    }

    return StreamMedia(
      id: json['_id'] as String,
      streamCardId: json['streamCardId'] as String,
      userId: json['userId'] as String,
      storageId: json['storageId'] as String,
      mediaType: json['mediaType'] as String,
      mimeType: json['mimeType'] as String?,
      aspectRatio: json['aspectRatio'] as String?,
      likes: _toInt(json['likes']) ?? 0,
      createdAt: _toInt(json['createdAt']) ?? DateTime.now().millisecondsSinceEpoch,
      streamCard: json['streamCard'] != null
          ? StreamCard.fromJson(json['streamCard'] as Map<String, dynamic>)
          : null,
      user: json['user'],
    );
  }
}

/// Provider to fetch all stream media items
final allStreamMediaProvider = FutureProvider<List<StreamMedia>>((ref) async {
  final client = ref.watch(convexClientProvider);

  try {
    final result = await client.query<List<dynamic>>(
      'streamMedia.getAllMedia',
    );

    return result
        .map((json) => StreamMedia.fromJson(json as Map<String, dynamic>))
        .toList();
  } catch (e) {
    print('Error fetching stream media: $e');
    return [];
  }
});

/// Provider to fetch media items for a specific stream card
final streamMediaByCardProvider = FutureProvider.family<List<StreamMedia>, String>((ref, streamCardId) async {
  final client = ref.watch(convexClientProvider);

  try {
    final result = await client.query<List<dynamic>>(
      'streamMedia.getMediaByStreamCard',
      {'streamCardId': streamCardId},
    );

    return result
        .map((json) => StreamMedia.fromJson(json as Map<String, dynamic>))
        .toList();
  } catch (e) {
    print('Error fetching stream media: $e');
    return [];
  }
});
