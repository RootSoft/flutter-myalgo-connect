import 'package:flutter_myalgo_connect/src/method_channel_myalgo.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

/// The interface that implementations of myalgo_connect must implement.
///
/// Platform implementations should extend this class rather than implement
/// it as `myalgo_connect` does not consider newly added methods to be
/// breaking changes.
///
/// Extending this class (using `extends`) ensures that the subclass will get
/// the default implementation, while platform implementations that
/// `implements` this interface will be broken by newly added
/// [MyAlgoConnectPlatform] methods.
///
/// Normally this should be in a separate package but since we only support web
/// this isn't necessary.
abstract class MyAlgoPlatform extends PlatformInterface {
  static const _token = Object();
  MyAlgoPlatform() : super(token: _token);

  static MyAlgoPlatform _instance = MethodChannelMyAlgo();

  // ignore: unnecessary_getters_setters
  static MyAlgoPlatform get instance => _instance;

  // ignore: unnecessary_getters_setters
  static set instance(MyAlgoPlatform i) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = i;
  }

  /// Requests access to the Wallet for the dApp, may be rejected or approved.
  /// Every access to the extension begins with a connect request, which if
  /// approved by the user, allows the dApp to follow-up with other requests.
  ///
  /// Returns the list of accounts from MyAlgo.
  Future<List<String>> connect();

  /// Send transaction objects to MyAlgo for approval.
  /// If approved, the response is an array of signed transaction objects,
  /// with the binary blob field base64 encoded to prevent transmission issues.
  Future<Map<String, dynamic>> signTransaction(dynamic transaction);

  /// Send transaction objects to MyAlgo for approval.
  /// If approved, the response is an array of signed transaction objects,
  /// with the binary blob field base64 encoded to prevent transmission issues.
  Future<List<Map<String, dynamic>>> signTransactions({
    required List transactions,
  });

  /// Logic Signatures (or LogicSigs) authorize transactions associated with an
  /// Algorand Smart Contract.
  /// Logic signatures are added to transactions to authorize spends from a
  /// Contract Account or from a Delegated Account.
  Future<String> signLogicSigTransaction({
    required String logic,
    required String address,
  });
}
