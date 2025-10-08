import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../widgets/common/bottom_nav.dart';
import '../../widgets/cube/cube_avatar.dart';
import '../../providers/user_provider.dart';

/// Home screen matching pages/home.js
/// Shows feed of verified users with their profile cards
class HomeScreen extends ConsumerWidget {
  final bool embedded;

  const HomeScreen({
    super.key,
    this.embedded = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allUsers = ref.watch(allVerifiedUsersProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // App Bar
          Container(
            decoration: BoxDecoration(
              color: AppColors.background,
              border: Border(
                bottom: BorderSide(
                  color: AppColors.borderPrimary,
                  width: 0.5,
                ),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  'Home',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),

          // Content
          Expanded(
            child: allUsers.when(
              data: (users) {
                if (users.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '🟩',
                          style: TextStyle(
                            fontSize: 64,
                            color: AppColors.textTertiary.withOpacity(0.4),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'No users yet',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Be the first to sign up!',
                          style: TextStyle(
                            fontSize: 15,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return LayoutBuilder(
                  builder: (context, constraints) {
                    // Responsive grid columns based on width
                    int crossAxisCount = 2;
                    if (constraints.maxWidth > 900) {
                      crossAxisCount = 4;
                    } else if (constraints.maxWidth > 600) {
                      crossAxisCount = 3;
                    }

                    return GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        childAspectRatio: 0.75,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index];
                        return _UserCard(
                          name: user.name,
                          username: user.username,
                          badge: user.badge,
                          followers: user.followers,
                          avatarUrl: user.avatarUrl,
                          accentColor: user.accentColor,
                        );
                      },
                    );
                  },
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                ),
              ),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: AppColors.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error loading users',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      error.toString(),
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textTertiary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: embedded ? null : const BottomNav(currentPage: 'home'),
    );
  }
}

/// User card widget for home feed
class _UserCard extends StatelessWidget {
  final String name;
  final String username;
  final String badge;
  final String followers;
  final String? avatarUrl;
  final String accentColor;

  const _UserCard({
    required this.name,
    required this.username,
    required this.badge,
    required this.followers,
    this.avatarUrl,
    required this.accentColor,
  });

  Color get _accentColorParsed {
    try {
      final hex = accentColor.replaceAll('#', '');
      return Color(int.parse('FF$hex', radix: 16));
    } catch (e) {
      return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.overlayLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.borderPrimary,
          width: 0.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Navigate to user profile
            context.push('/u/$username');
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Cube Avatar
                CubeAvatar(
                  imageUrl: avatarUrl,
                  size: 90,
                ),

                const SizedBox(height: 12),

                // Name
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.01,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 3),

                // Username
                Text(
                  '@$username',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 10),

                // Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: _accentColorParsed.withOpacity(0.2),
                    border: Border.all(
                      color: _accentColorParsed.withOpacity(0.4),
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    badge.toLowerCase(),
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Followers
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.people_outline,
                      size: 13,
                      color: AppColors.textTertiary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      followers,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
