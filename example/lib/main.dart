import 'dart:convert';

import 'package:algorand_dart/algorand_dart.dart';
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

              // Fetch the suggested transaction params
              final params = await algorand.getSuggestedTransactionParams();

              // Construct the transaction
              final data = <String, dynamic>{
                'fee': 1000,
                'flatFee': true,
                'type': 'pay',
                'from': accounts[1],
                'to': accounts[1],
                'amount': Algo.toMicroAlgos(0.5),
                'firstRound': params.lastRound,
                'lastRound': params.lastRound + 1000,
                'genesisID': params.genesisId,
                'genesisHash': params.genesisHash,
              };

              // Sign the transaction
              final signedTx = await MyAlgoConnect.signTransaction(data);
              final blob = signedTx['blob'];

              // Send the transaction
              final txId = await algorand.sendRawTransaction(
                base64Decode(blob),
              );

              // Wait for confirmation
              final tx = await algorand.waitForConfirmation(txId);
              print('Confirmed tx id in round: ${tx.confirmedRound}');
            } on MyAlgoException catch (ex) {
              print('unable to connect ${ex.message}');
            } on AlgorandException catch (ex) {
              print('unable to send transaction ${ex.message}');
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
