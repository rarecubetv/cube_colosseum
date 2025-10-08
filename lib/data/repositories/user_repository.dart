import '../datasources/convex_client.dart';
import '../models/user.dart';

/// Repository for user-related operations
/// Handles all user data fetching and mutations
class UserRepository {
  final ConvexClient _convex;

  UserRepository(this._convex);

  /// Get all verified users (for home feed)
  Future<List<User>> getAllVerifiedUsers() async {
    try {
      // Call Convex function directly: users:getAllVerifiedUsers
      final response = await _convex.query<dynamic>(
        'users:getAllVerifiedUsers',
        {},
      );

      // Convex returns the data directly (not wrapped)
      if (response is List) {
        return response
            .map((json) => User.fromJson(json as Map<String, dynamic>))
            .toList();
      }

      return [];
    } catch (e) {
      print('Error fetching verified users: $e');
      return [];
    }
  }

  /// Get user by username
  Future<User?> getUserByUsername(String username) async {
    try {
      final response = await _convex.query<dynamic>(
        'users:getUserByUsername',
        {'username': username},
      );

      if (response == null) return null;

      return User.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      print('Error fetching user by username: $e');
      return null;
    }
  }

  /// Get user by Twitter ID
  Future<User?> getUserByTwitterId(String twitterId) async {
    try {
      final response = await _convex.query<dynamic>(
        'users:getUserByTwitterId',
        {'twitterId': twitterId},
      );

      if (response == null) return null;

      return User.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      print('Error fetching user by Twitter ID: $e');
      return null;
    }
  }

  /// Save/update user
  Future<User> saveUser(Map<String, dynamic> userData) async {
    final response = await _convex.mutate<Map<String, dynamic>>(
      'save-user',
      userData,
    );

    return User.fromJson(response['user'] as Map<String, dynamic>);
  }

  /// Update user card settings
  Future<void> updateCard({
    required String twitterId,
    String? badge,
    String? accentColor,
    String? wallet,
    String? chain,
    String? avatarStorageId,
  }) async {
    await _convex.mutate(
      'update-card',
      {
        'twitterId': twitterId,
        if (badge != null) 'badge': badge,
        if (accentColor != null) 'accentColor': accentColor,
        if (wallet != null) 'wallet': wallet,
        if (chain != null) 'chain': chain,
        if (avatarStorageId != null) 'avatarStorageId': avatarStorageId,
      },
    );
  }

  /// Save generated GIF to user profile
  Future<Map<String, dynamic>> saveGif({
    required String twitterId,
    required String gifStorageId,
  }) async {
    return await _convex.mutate<Map<String, dynamic>>(
      'save-gif',
      {
        'twitterId': twitterId,
        'gifStorageId': gifStorageId,
      },
    );
  }

  /// Get avatar URL from storage ID
  Future<String?> getAvatarUrl(String? storageId) async {
    if (storageId == null) return null;

    try {
      return await _convex.getFileUrl(storageId);
    } catch (e) {
      print('Error getting avatar URL: $e');
      return null;
    }
  }
}
