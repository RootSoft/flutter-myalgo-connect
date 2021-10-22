<p align="center"> 
<img src="https://github.com/randlabs/myalgo-connect/raw/master/my-algo.png">
</p>

# flutter-myalgo-connect
[![pub.dev][pub-dev-shield]][pub-dev-url]
[![Effective Dart][effective-dart-shield]][effective-dart-url]
[![Stars][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]

MyAlgo is an Algorand Wallet allowing you to freely interact with the Algorand blockchain.

MyAlgo provides the simplest and most secure way to send and receive Algos and tokens, organize and track all your Algorand wallets, manage your assets and much more.

The plugin was developed by RootSoft and is not affiliated with Rand Labs or MyAlgo is any way. For more information, check out the official MyAlgo [documentation](https://github.com/randlabs/myalgo-connect).

## Introduction

The integration with MyAlgo Wallet allows users secure access to Algorand DApps. Users only need to share their public addresses with the WebApp and this in turn allows them to review and sign all types of transactions without exposing their private keys. The main novelty of MyAlgo Connect lies in the fact that all the process is managed in the user’s browser without the need for any backend service nor downloads, extensions or browser plugins. Unlike extension based wallets like Metamask or AlgoSigner, MyAlgo Connect works with any browser (including Safari) and any device giving developers a native HTML5 solution that works on all platforms.

The flutter-myalgo-connect plugin follows the Javascript MyAlgo Connect API closely and all methods are available. The plugin integrates elegantly with the [algorand_dart](https://github.com/RootSoft/algorand-dart) SDK so transactions can be easily signed and approved.

Once installed, you can simply sign transactions and start sending payments:

```dart
/// Fetch the accounts
final accounts = await MyAlgoConnect.connect();

/// Sign the transaction
final signedTx = await MyAlgoConnect.signTransaction(data);
final blob = signedTx['blob'];

// Send the transaction
final txId = await algorand.sendRawTransaction(
    base64Decode(blob),
);
```

## Getting started

### Installation

You can install the package via pub.dev:

```bash
flutter pub add flutter_myalgo_connect
```

This will add a line like this to your package's pubspec.yaml (and run an implicit dart pub get):

```yaml
dependencies:
  flutter_myalgo_connect: ^latest-version
```

Alternatively, your editor might support flutter pub get. Check the docs for your editor to learn more.

Next, add the MyAlgo Connect JS file to the bottom of your index.html file:

```html
  <script src="https://github.com/randlabs/myalgo-connect/releases/download/v1.0.1/myalgo.min.js"></script>
</body>
</html>
```

See [releases](https://github.com/randlabs/myalgo-connect/releases/) for the latest version.

Use ```flutter run -d web-server``` to serve your webapp at localhost.

## Methods
The **flutter-myalgo-connect** web plugin wraps the JavaScript API and exposes methods for Flutter developers. This way, Flutter web developers can benefit and create web3 dApplications using the same API.

### connect()

Requests access to the Wallet for the dApp, may be rejected or approved. Every access begins with a connect request, which if approved by the user, allows the dApp to follow-up with other requests.
The ```connect()``` method returns a list of accounts that can be used to sign transactions with.

```dart
final accounts = await MyAlgoConnect.connect();
```

### signTransaction()

Send transaction objects, conforming to the Algorand JS SDK, to MyAlgo Connect for approval. If approved, the response is an array of signed transaction objects, with the binary blob field base64 encoded to prevent transmission issues.

#### Transaction Requirements

Since MyAlgo Connect does not support passing base64-encoded transactions or raw bytes, the transaction fields have to conform the Algorand JS SDK.

For more information, see the [API Usage](https://github.com/randlabs/myalgo-connect)

#### Request

```dart
await MyAlgoConnect.signTransaction({
    'fee': 1000,
    'flatFee': true,
    'type': 'pay',
    'from': accounts[0],
    'to': accounts[0],
    'amount': Algo.toMicroAlgos(0.5),
    'firstRound': params.lastRound,
    'lastRound': params.lastRound + 1000,
    'genesisID': params.genesisId,
    'genesisHash': params.genesisHash,
});
```

#### Example
The following displays an example on how a payment transaction can be signed and approved with MyAlgo Connect.

```dart
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
```

### signLogicSigTransaction()

Logic Signatures (or LogicSigs) authorize transactions associated with an Algorand Smart Contract. Logic signatures are added to transactions to authorize spends from a Contract Account or from a Delegated Account.

```dart
final program = 'ASABASI=';
final sig = await MyAlgoConnect.signLogicSigTransaction(
    logic: program,
    address: accounts[1],
);
```

## Changelog

Please see [CHANGELOG](CHANGELOG.md) for more information on what has changed recently.

## Contributing & Pull Requests
Feel free to send pull requests.

Please see [CONTRIBUTING](.github/CONTRIBUTING.md) for details.

## Credits

- [Tomas Verhelst](https://github.com/rootsoft)
- [All Contributors](../../contributors)

## License

The MIT License (MIT). Please see [License File](LICENSE.md) for more information.


<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[pub-dev-shield]: https://img.shields.io/pub/v/flutter_myalgo_connect?style=for-the-badge
[pub-dev-url]: https://pub.dev/packages/flutter_myalgo_connect
[effective-dart-shield]: https://img.shields.io/badge/style-effective_dart-40c4ff.svg?style=for-the-badge
[effective-dart-url]: https://github.com/tenhobi/effective_dart
[stars-shield]: https://img.shields.io/github/stars/rootsoft/flutter-myalgo-connect.svg?style=for-the-badge&logo=github&colorB=deeppink&label=stars
[stars-url]: https://github.com/RootSoft/flutter-myalgo-connect/stargazers
[issues-shield]: https://img.shields.io/github/issues/rootsoft/flutter-myalgo-connect.svg?style=for-the-badge
[issues-url]: https://github.com/rootsoft/flutter-myalgo-connect/issues
[license-shield]: https://img.shields.io/github/license/rootsoft/flutter-myalgo-connect.svg?style=for-the-badge
[license-url]: https://github.com/RootSoft/flutter-myalgo-connect/blob/master/LICENSE