import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/user.dart';
import '../../widgets/cube/cube_avatar.dart';
import '../../providers/user_provider.dart';

/// User profile screen showing detailed information
/// Matches web app's preview/profile pages
class UserProfileScreen extends ConsumerWidget {
  final String username;

  const UserProfileScreen({
    super.key,
    required this.username,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userByUsernameProvider(username));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            _buildAppBar(context),

            // Content
            Expanded(
              child: userAsync.when(
                data: (user) {
                  if (user == null) {
                    return _buildNotFound();
                  }
                  return _buildProfile(context, user);
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
                        'Error loading profile',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(
          bottom: BorderSide(
            color: AppColors.borderPrimary,
            width: 0.5,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
              color: AppColors.textPrimary,
            ),
            const Expanded(
              child: Text(
                'Profile',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(width: 48), // Balance the back button
          ],
        ),
      ),
    );
  }

  Widget _buildNotFound() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.person_off_outlined,
            size: 64,
            color: AppColors.textTertiary,
          ),
          const SizedBox(height: 16),
          const Text(
            'User not found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '@$username',
            style: const TextStyle(
              fontSize: 15,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfile(BuildContext context, User user) {
    final accentColor = _parseAccentColor(user.accentColor);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Large Cube Avatar
          CubeAvatar(
            imageUrl: user.avatarUrl ?? user.avatar,
            size: 200,
          ),

          const SizedBox(height: 24),

          // Name
          Text(
            user.name,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8),

          // Username
          Text(
            '@${user.username}',
            style: const TextStyle(
              fontSize: 18,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 24),

          // Badge
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.2),
              border: Border.all(
                color: accentColor.withOpacity(0.4),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              user.badge.toLowerCase(),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                letterSpacing: 0.5,
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Stats Grid
          _buildStatsGrid(user),

          const SizedBox(height: 32),

          // Wallet Info (if available)
          if (user.wallet != null && user.wallet!.isNotEmpty)
            _buildWalletInfo(user.wallet!, user.chain, accentColor),

          const SizedBox(height: 32),

          // Action Buttons
          _buildActionButtons(context, user, accentColor),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(User user) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.overlayLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.borderPrimary,
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            Icons.people_outline,
            'Followers',
            user.followers,
          ),
          _buildStatDivider(),
          _buildStatItem(
            Icons.article_outlined,
            'Posts',
            user.posts,
          ),
          _buildStatDivider(),
          _buildStatItem(
            Icons.favorite_outline,
            'Likes',
            user.likes,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(
          icon,
          size: 24,
          color: AppColors.textSecondary,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textTertiary,
          ),
        ),
      ],
    );
  }

  Widget _buildStatDivider() {
    return Container(
      height: 60,
      width: 0.5,
      color: AppColors.borderPrimary,
    );
  }

  Widget _buildWalletInfo(String wallet, String? chain, Color accentColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.overlayLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: accentColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.account_balance_wallet_outlined,
            size: 20,
            color: accentColor,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (chain != null)
                  Text(
                    chain,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                const SizedBox(height: 2),
                Text(
                  _formatWallet(wallet),
                  style: const TextStyle(
                    fontSize: 13,
                    fontFamily: 'monospace',
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, User user, Color accentColor) {
    return Column(
      children: [
        // View on Twitter button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              // TODO: Open Twitter profile
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Open https://twitter.com/${user.username}'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: accentColor,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.open_in_new, size: 20),
                SizedBox(width: 8),
                Text(
                  'View on Twitter',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Share button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              // TODO: Share profile
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Share profile'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.textPrimary,
              side: BorderSide(
                color: AppColors.borderPrimary,
                width: 1,
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.share, size: 20),
                SizedBox(width: 8),
                Text(
                  'Share Profile',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Color _parseAccentColor(String accentColor) {
    try {
      final hex = accentColor.replaceAll('#', '');
      return Color(int.parse('FF$hex', radix: 16));
    } catch (e) {
      return AppColors.primary;
    }
  }

  String _formatWallet(String wallet) {
    if (wallet.length < 12) return wallet;
    return '${wallet.substring(0, 6)}...${wallet.substring(wallet.length - 4)}';
  }
}
