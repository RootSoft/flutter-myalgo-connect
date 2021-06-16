import 'package:flutter/services.dart';

import 'myalgo_platform.dart';

const MethodChannel _channel = MethodChannel('myalgo');

class MethodChannelMyAlgo extends MyAlgoPlatform {
  @override
  Future<List<String>> connect() async {
    final result = await _channel.invokeMethod<List<String>>(
      'connect',
    );

    return result ?? [];
  }

  @override
  Future<Map<String, dynamic>> signTransaction(
    Map<String, dynamic> transaction,
  ) async {
    final result = await _channel.invokeMethod<Map<String, dynamic>>(
      'signTransaction',
    );

    return result ?? <String, dynamic>{};
  }

  @override
  Future<List<Map<String, dynamic>>> signTransactions({
    required List<Map<String, dynamic>> transactions,
  }) async {
    final result = await _channel.invokeMethod<List<Map<String, dynamic>>>(
      'signTransactions',
    );

    return result ?? [];
  }

  @override
  Future<String> signLogicSigTransaction({
    required String logic,
    required String address,
  }) async {
    final result = await _channel.invokeMethod<String>(
      'signLogicSig',
    );

    return result ?? '';
  }
}
