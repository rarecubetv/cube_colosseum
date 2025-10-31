import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/solana/solana_wallet_service.dart';

/// Provider for Solana wallet service
final solanaWalletServiceProvider = Provider<SolanaWalletService>((ref) {
  return SolanaWalletService();
});

/// Provider for current Solana wallet authorization state
final solanaAuthStateProvider = StateProvider<bool>((ref) => false);

/// Provider for current Solana public key
final solanaPublicKeyProvider = StateProvider<String?>((ref) => null);
