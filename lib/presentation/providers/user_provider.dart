import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/user_repository.dart';
import '../../data/models/user.dart';
import 'convex_provider.dart';

/// User repository provider
final userRepositoryProvider = Provider<UserRepository>((ref) {
  final convex = ref.watch(convexProvider);
  return UserRepository(convex);
});

/// Provider for all verified users (home feed)
final allVerifiedUsersProvider = FutureProvider<List<User>>((ref) async {
  final userRepo = ref.watch(userRepositoryProvider);
  return await userRepo.getAllVerifiedUsers();
});

/// Provider for a specific user by username
final userByUsernameProvider =
    FutureProvider.family<User?, String>((ref, username) async {
  final userRepo = ref.watch(userRepositoryProvider);
  return await userRepo.getUserByUsername(username);
});

/// Provider for a specific user by Twitter ID
final userByTwitterIdProvider =
    FutureProvider.family<User?, String>((ref, twitterId) async {
  final userRepo = ref.watch(userRepositoryProvider);
  return await userRepo.getUserByTwitterId(twitterId);
});

/// Provider for avatar URL from storage ID
final avatarUrlProvider =
    FutureProvider.family<String?, String?>((ref, storageId) async {
  if (storageId == null) return null;

  final userRepo = ref.watch(userRepositoryProvider);
  return await userRepo.getAvatarUrl(storageId);
});
