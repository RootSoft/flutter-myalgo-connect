import 'dart:async';
import 'dart:convert';

import 'package:flutter_myalgo_connect/src/interop/convert_interop.dart';
import 'package:flutter_myalgo_connect/src/interop/myalgo_interop.dart';
import 'package:flutter_myalgo_connect/src/myalgo_exception.dart';
import 'package:flutter_myalgo_connect/src/myalgo_platform.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:js/js_util.dart';

/// A web implementation of the MyAlgo Connect plugin.
class MyAlgoPlugin extends MyAlgoPlatform {
  final MyAlgo myAlgo;

  MyAlgoPlugin({required this.myAlgo});

  static void registerWith(Registrar registrar) {
    MyAlgoPlatform.instance = MyAlgoPlugin(
      myAlgo: MyAlgo(),
    );
  }

  @override
  Future<List<String>> connect() async {
    var c = Completer<List<String>>();
    promiseToFuture(myAlgo.connect()).then((value) {
      if (value is! List) {
        return c.complete([]);
      }

      final addresses = value.map((address) {
        return getProperty(address, 'address') as String;
      }).toList();

      return c.complete(addresses);
    }).onError((error, stackTrace) => c.completeError(_handleError(error)));

    return c.future;
  }

  @override
  Future<Map<String, dynamic>> signTransaction(
    Map<String, dynamic> transaction,
  ) async {
    final tx = mapToJSObj(transaction);
    var c = Completer<Map<String, dynamic>>();
    promiseToFuture(myAlgo.signTransaction([tx])).then((value) {
      final txId = getProperty(value, 'txID') ?? '';
      final blob = getProperty(value, 'blob') ?? [];
      return c.complete({
        'txId': txId,
        'blob': base64Encode(blob),
      });
    }).onError((error, stackTrace) => c.completeError(_handleError(error)));

    return c.future;
  }

  @override
  Future<List<Map<String, dynamic>>> signTransactions({
    required List<Map<String, dynamic>> transactions,
  }) async {
    final txs = transactions.map(mapToJSObj).toList();

    var c = Completer<List<Map<String, dynamic>>>();
    promiseToFuture(myAlgo.signTransaction(txs)).then((value) {
      if (value is! List) {
        return c.complete([]);
      }

      final transactions = value.map((tx) {
        final txId = getProperty(tx, 'txID') ?? '';
        final blob = getProperty(tx, 'blob') ?? [];
        return <String, dynamic>{
          'txId': txId,
          'blob': base64Encode(blob),
        };
      }).toList();

      return c.complete(transactions);
    }).onError((error, stackTrace) => c.completeError(_handleError(error)));

    return c.future;
  }

  @override
  Future<String> signLogicSigTransaction({
    required String logic,
    required String address,
  }) async {
    var c = Completer<String>();
    promiseToFuture(myAlgo.signLogicSig(logic, address))
        .then((value) => c.complete(base64Encode(value)))
        .onError((error, stackTrace) => c.completeError(_handleError(error)));

    return c.future;
  }

  MyAlgoException _handleError(dynamic error) {
    print(error.runtimeType);
    print(convert(error));
    final message = error is String ? error : convert(error)['message'] ?? '';
    return MyAlgoException(message, error);
  }
}
