import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/solana/solana_wallet_service.dart';

/// Provider for Solana wallet service
final solanaWalletServiceProvider = Provider<SolanaWalletService>((ref) {
  return SolanaWalletService();
});

/// Simple state holders for Solana wallet
class SolanaAuthState extends Notifier<bool> {
  @override
  bool build() => false;

  void setAuthorized(bool value) => state = value;
}

class SolanaPublicKeyState extends Notifier<String?> {
  @override
  String? build() => null;

  void setPublicKey(String? value) => state = value;
}

/// Provider for current Solana wallet authorization state
final solanaAuthStateProvider = NotifierProvider<SolanaAuthState, bool>(() {
  return SolanaAuthState();
});

/// Provider for current Solana public key
final solanaPublicKeyProvider = NotifierProvider<SolanaPublicKeyState, String?>(() {
  return SolanaPublicKeyState();
});
