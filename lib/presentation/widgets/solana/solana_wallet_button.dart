import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/solana_provider.dart';

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

    return ElevatedButton(
      onPressed: () async {
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
            onConnected?.call();
          }
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF22C55E),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isAuthorized ? Icons.link_off : Icons.account_balance_wallet,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            isAuthorized
                ? 'Disconnect ${_shortenAddress(publicKey)}'
                : 'Connect Wallet',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _shortenAddress(String? address) {
    if (address == null || address.length < 8) return '';
    return '${address.substring(0, 4)}...${address.substring(address.length - 4)}';
  }
}
