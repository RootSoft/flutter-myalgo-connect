@JS()
library myalgo.js;

import 'package:js/js.dart';

/// MyAlgo instance.
@JS('MyAlgoConnect')
class MyAlgo {
  @JS('connect')
  external List<dynamic> connect();

  @JS('signTransaction')
  external List<Map<String, dynamic>> signTransaction(
    List<dynamic> transactions,
  );

  @JS('signLogicSig')
  external String signLogicSig(String logic, String address);
}
