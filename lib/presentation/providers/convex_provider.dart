import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/convex_client.dart';

/// Global Convex client provider
/// This singleton is used throughout the app for all Convex operations
final convexProvider = Provider<ConvexClient>((ref) {
  final client = ConvexClient();

  // Dispose client when provider is disposed
  ref.onDispose(() => client.dispose());

  return client;
});
