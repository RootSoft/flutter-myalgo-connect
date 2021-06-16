import 'dart:async';

import 'package:flutter_myalgo_connect/src/myalgo_platform.dart';

/// MyAlgo is an Algorand Wallet allowing you to freely interact with the
/// Algorand blockchain.
///
/// MyAlgo provides the simplest and most secure way to send and receive Algos
/// and tokens, organize and track all your Algorand wallets, manage your
/// assets and much more.
///
/// MyAlgo Connect allows WebApp users to review and sign Algorand transactions
/// using accounts secured within their MyAlgo Wallet.
/// This enables Algorand applications to use MyAlgo Wallet to interact with
/// the Algorand blockchain and users to access the applications in a private
/// and secure manner.
///
/// The integration with MyAlgo Wallet allows users secure access to
/// Algorand DApps. Users only need to share their public addresses with the
/// WebApp and this in turn allows them to review and sign all types of
/// transactions without exposing their private keys.
///
/// The main novelty of MyAlgo Connect lies in the fact that all the process is
/// managed in the user’s browser without the need for any backend service nor
/// downloads, extensions or browser plugins.
class MyAlgoConnect {
  /// Requests access to the Wallet for the dApp, may be rejected or approved.
  /// Every access to the extension begins with a connect request, which if
  /// approved by the user, allows the dApp to follow-up with other requests.
  static Future<List<String>> connect() async {
    final result = await MyAlgoPlatform.instance.connect();
    return result;
  }

  /// Send transaction objects to MyAlgo for approval.
  /// If approved, the response is a signed transaction object,
  /// with the binary blob field base64 encoded to prevent transmission issues.
  static Future<Map<String, dynamic>> signTransaction(
    Map<String, dynamic> transaction,
  ) async {
    final result = await MyAlgoPlatform.instance.signTransaction(transaction);
    return result;
  }

  /// Send transaction objects to MyAlgo for approval.
  /// If approved, the response is a signed transaction object,
  /// with the binary blob field base64 encoded to prevent transmission issues.
  static Future<List<Map<String, dynamic>>> signTransactions(
    List<Map<String, dynamic>> transactions,
  ) async {
    final result = await MyAlgoPlatform.instance.signTransactions(
      transactions: transactions,
    );
    return result;
  }

  /// Logic Signatures (or LogicSigs) authorize transactions associated with an
  /// Algorand Smart Contract.
  /// Logic signatures are added to transactions to authorize spends from a
  /// Contract Account or from a Delegated Account.
  static Future<String> signLogicSigTransaction({
    required String logic,
    required String address,
  }) async {
    final result = await MyAlgoPlatform.instance.signLogicSigTransaction(
      logic: logic,
      address: address,
    );
    return result;
  }
}
