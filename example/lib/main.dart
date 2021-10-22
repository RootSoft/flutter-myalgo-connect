import 'dart:convert';

import 'package:algorand_dart/algorand_dart.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_myalgo_connect/myalgo_connect.dart';
import 'package:flutter_myalgo_connect/myalgo_connect_web.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

final algorand = Algorand(
  algodClient: AlgodClient(apiUrl: AlgoExplorer.TESTNET_ALGOD_API_URL),
  indexerClient: IndexerClient(apiUrl: AlgoExplorer.TESTNET_INDEXER_API_URL),
);

class _MyAppState extends State<MyApp> {
  final String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on: $_platformVersion\n'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            try {
              // Fetch the accounts
              final accounts = await MyAlgoConnect.connect();
              final address = Address.fromAlgorandAddress(address: accounts[0]);

              // Fetch the suggested transaction params
              final params = await algorand.getSuggestedTransactionParams();

              // Construct the transactions
              final tx1 = await (PaymentTransactionBuilder()
                    ..sender = address
                    ..receiver = address
                    ..amount = Algo.toMicroAlgos(0.6)
                    ..suggestedParams = params)
                  .build();

              final tx2 = await (PaymentTransactionBuilder()
                    ..sender = address
                    ..receiver = address
                    ..amount = Algo.toMicroAlgos(0.5)
                    ..suggestedParams = params)
                  .build();

              // Group the transactions
              AtomicTransfer.group([tx1, tx2]);

              // Sign the transaction
              final txs = await MyAlgoConnect.signTransactions([
                tx1.toBase64(),
                tx2.toBase64(),
              ]);

              final sTxs = txs.map((tx) => base64Decode(tx['blob'])).toList();
              print(sTxs);

              // Send the transaction
              final txId = await algorand.sendRawTransactions(sTxs);

              // Wait for confirmation
              final pendingTx = await algorand.waitForConfirmation(txId);
              print('Confirmed tx id in round: ${pendingTx.confirmedRound}');
            } on MyAlgoException catch (ex) {
              print('unable to connect ${ex.message}');
            } on AlgorandException catch (ex) {
              final cause = ex.cause;
              var message = '';
              if (cause is DioError) {
                message = cause.message;
                print(cause.response);
              }
              print('AlgorandException: unable to send transaction $message');
            } catch (ex) {
              print('unable to send transaction $ex');
            }
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
