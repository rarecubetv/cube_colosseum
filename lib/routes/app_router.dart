import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../presentation/screens/auth/login_screen.dart';
import '../presentation/screens/main/main_scaffold.dart';
import '../presentation/screens/profile/user_profile_screen.dart';
import '../presentation/screens/stream/stream_create_screen.dart';
import '../presentation/screens/stream/stream_detail_screen.dart';

/// App router using go_router for navigation
/// Provides declarative routing matching the web app's structure
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      // Login screen (/)
      GoRoute(
        path: '/',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),

      // Home screen (/home) - Uses MainScaffold with persistent tabs
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const MainScaffold(initialTab: 0),
      ),

      // Stream feed (/stream) - Uses MainScaffold with stream tab
      GoRoute(
        path: '/stream',
        name: 'stream',
        builder: (context, state) => const MainScaffold(initialTab: 1),
      ),

      // User profile (/u/:username) - Changed to avoid conflicts
      GoRoute(
        path: '/u/:username',
        name: 'profile',
        builder: (context, state) {
          final username = state.pathParameters['username']!;
          return UserProfileScreen(username: username);
        },
      ),

      // Stream creation (/stream/create)
      GoRoute(
        path: '/stream/create',
        name: 'stream-create',
        builder: (context, state) => const StreamCreateScreen(),
      ),

      // Stream detail (/stream/:id)
      GoRoute(
        path: '/stream/:id',
        name: 'stream-detail',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return StreamDetailScreen(streamId: id);
        },
      ),

      // TODO: Add more routes
      // - /onboarding - Onboarding screen
      // - /cube - Cube page
      // - /notifications - Notifications
      // - /preview/:username - Preview/card customization
    ],
  );
});
