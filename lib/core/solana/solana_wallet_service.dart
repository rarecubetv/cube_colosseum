import 'package:flutter/foundation.dart';
import 'package:solana_wallet_adapter/solana_wallet_adapter.dart';

/// Service for managing Solana wallet connections and operations
class SolanaWalletService {
  late final SolanaWalletAdapter _adapter;

  Account? _currentAccount;
  bool _isAuthorized = false;

  Account? get currentAccount => _currentAccount;
  bool get isAuthorized => _isAuthorized;
  String? get publicKey => _currentAccount?.address;

  SolanaWalletService() {
    _adapter = SolanaWalletAdapter(
      AppIdentity(
        uri: Uri(scheme: 'https', host: 'rarecube.tv'),
        icon: Uri(scheme: 'https', host: 'rarecube.tv', path: '/favicon.ico'),
        name: 'RareCube',
      ),
      cluster: Cluster.devnet,
    );
  }

  /// Authorize and connect to a Solana wallet
  Future<AuthorizeResult?> authorize() async {
    try {
      final result = await _adapter.authorize();
      _currentAccount = result.accounts.first;
      _isAuthorized = true;
      return result;
    } catch (e) {
      if (kDebugMode) {
        print('Solana authorization error: $e');
      }
      _isAuthorized = false;
      return null;
    }
  }

  /// Deauthorize and disconnect from wallet
  Future<void> deauthorize() async {
    try {
      await _adapter.deauthorize();
      _currentAccount = null;
      _isAuthorized = false;
    } catch (e) {
      if (kDebugMode) {
        print('Solana deauthorization error: $e');
      }
    }
  }

  /// Sign a transaction
  Future<SignTransactionsResult?> signTransaction(String transaction) async {
    if (!_isAuthorized) {
      throw Exception('Not authorized. Call authorize() first.');
    }

    try {
      return await _adapter.signTransactions([transaction]);
    } catch (e) {
      if (kDebugMode) {
        print('Solana sign transaction error: $e');
      }
      return null;
    }
  }

  /// Sign multiple transactions
  Future<SignTransactionsResult?> signTransactions(List<String> transactions) async {
    if (!_isAuthorized) {
      throw Exception('Not authorized. Call authorize() first.');
    }

    try {
      return await _adapter.signTransactions(transactions);
    } catch (e) {
      if (kDebugMode) {
        print('Solana sign transactions error: $e');
      }
      return null;
    }
  }

  /// Sign a message
  Future<SignMessagesResult?> signMessage(String message) async {
    if (!_isAuthorized || _currentAccount == null) {
      throw Exception('Not authorized. Call authorize() first.');
    }

    try {
      return await _adapter.signMessages([message]);
    } catch (e) {
      if (kDebugMode) {
        print('Solana sign message error: $e');
      }
      return null;
    }
  }
}
