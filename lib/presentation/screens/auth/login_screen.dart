import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../widgets/cube/cube_avatar.dart';
import '../../providers/user_provider.dart';
import '../../widgets/solana/solana_wallet_button.dart';

/// Login screen matching pages/index.js
/// Shows "RARECUBE : PHASE ONE LIVE" title, login buttons, and user carousel
class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allUsers = ref.watch(allVerifiedUsersProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Title
                  Text(
                    'RARECUBE : PHASE ONE LIVE',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2,
                          color: AppColors.textPrimary,
                        ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 32),

                  // Login Button
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Implement Twitter OAuth
                      _handleTwitterLogin(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary.withOpacity(0.2),
                      foregroundColor: AppColors.textPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: AppColors.primary.withOpacity(0.4),
                          width: 1.5,
                        ),
                      ),
                      minimumSize: const Size(double.infinity, 60),
                    ),
                    child: const Text(
                      'Log in with 𝕏',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // CUBE Agent Button
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Navigate to agent page
                      _handleAgentTap(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.overlayLight,
                      foregroundColor: AppColors.textSecondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: AppColors.borderPrimary,
                          width: 1.5,
                        ),
                      ),
                      minimumSize: const Size(double.infinity, 60),
                    ),
                    child: const Text(
                      'CUBE Agent',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),

                  const SizedBox(height: 48),

                  // Solana Wallet Connect Button
                  SolanaWalletButton(
                    onConnected: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Solana wallet connected!'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 48),

                  // User Carousel
                  allUsers.when(
                    data: (users) {
                      if (users.isEmpty) {
                        return const SizedBox.shrink();
                      }

                      return Column(
                        children: [
                          // User count
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${users.length}',
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'signed up',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // Horizontal scrolling user list
                          SizedBox(
                            height: 180,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(horizontal: 40),
                              itemCount: users.length,
                              itemBuilder: (context, index) {
                                final user = users[index];
                                return _UserCard(
                                  name: user.name,
                                  badge: user.badge,
                                  avatarUrl: user.avatarUrl,
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    },
                    loading: () => const CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                    error: (_, __) => const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleTwitterLogin(BuildContext context) {
    // TODO: Implement actual Twitter OAuth flow
    // For now, navigate directly to home to demo the app
    context.go('/home');
  }

  void _handleAgentTap(BuildContext context) {
    // TODO: Navigate to agent page
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('CUBE Agent - Coming soon!'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

/// User card widget for the carousel
class _UserCard extends StatelessWidget {
  final String name;
  final String badge;
  final String? avatarUrl;

  const _UserCard({
    required this.name,
    required this.badge,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 24),
      child: Column(
        children: [
          // Cube Avatar
          CubeAvatar(
            imageUrl: avatarUrl,
            size: 80,
          ),

          const SizedBox(height: 16),

          // Name
          Text(
            name,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8),

          // Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.2),
              border: Border.all(
                color: AppColors.primary.withOpacity(0.4),
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              badge.toLowerCase(),
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
