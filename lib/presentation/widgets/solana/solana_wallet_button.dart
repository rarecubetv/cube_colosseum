import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/solana_provider.dart';
import '../../providers/user_provider.dart';
import '../../providers/auth_provider.dart';
import '../../../data/models/user.dart';

/// A button widget for connecting to Solana wallets
class SolanaWalletButton extends ConsumerWidget {
  final VoidCallback? onConnected;
  final VoidCallback? onDisconnected;

  const SolanaWalletButton({
    super.key,
    this.onConnected,
    this.onDisconnected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletService = ref.watch(solanaWalletServiceProvider);
    final isAuthorized = ref.watch(solanaAuthStateProvider);
    final publicKey = ref.watch(solanaPublicKeyProvider);

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.black.withOpacity(0.4),
                Colors.black.withOpacity(0.2),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () async {
                if (isAuthorized) {
                  // Disconnect
                  await walletService.deauthorize();
                  ref.read(solanaAuthStateProvider.notifier).setAuthorized(false);
                  ref.read(solanaPublicKeyProvider.notifier).setPublicKey(null);
                  onDisconnected?.call();
                } else {
                  // Connect
                  final result = await walletService.authorize();
                  if (result != null) {
                    ref.read(solanaAuthStateProvider.notifier).setAuthorized(true);
                    ref.read(solanaPublicKeyProvider.notifier).setPublicKey(walletService.publicKey);

                    // Authenticate with Convex backend
                    try {
                      final userRepo = ref.read(userRepositoryProvider);

                      // Get username from Seeker Genesis Token (account label)
                      final seekerUsername = walletService.currentAccount?.label;

                      final authResult = await userRepo.authenticateWithSolana(
                        walletAddress: walletService.publicKey!,
                        walletChain: 'solana',
                        username: seekerUsername,
                        name: seekerUsername,
                      );

                      print('✅ Solana auth successful: ${authResult['isNewUser'] ? 'New user created' : 'Existing user'}');
                      print('   User ID: ${authResult['userId']}');
                      print('   Username: ${authResult['user']['username']}');
                      if (seekerUsername != null) {
                        print('   Seeker name: $seekerUsername');
                      }

                      // Store user in auth state
                      final user = User.fromJson(authResult['user'] as Map<String, dynamic>);
                      ref.read(authProvider.notifier).setUser(
                        user,
                        walletAddress: walletService.publicKey,
                      );

                      // Navigate to home screen
                      if (context.mounted) {
                        context.go('/home');
                      }
                    } catch (e) {
                      print('❌ Solana authentication failed: $e');
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Authentication failed: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }

                    onConnected?.call();
                  }
                }
              },
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isAuthorized ? Icons.link_off : Icons.account_balance_wallet,
                      size: 20,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      isAuthorized
                          ? 'Disconnect ${_shortenAddress(publicKey)}'
                          : 'Connect Wallet',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _shortenAddress(String? address) {
    if (address == null || address.length < 8) return '';
    return '${address.substring(0, 4)}...${address.substring(address.length - 4)}';
  }
}
