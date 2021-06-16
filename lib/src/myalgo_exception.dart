class MyAlgoException implements Exception {
  String message;
  dynamic cause;

  MyAlgoException(this.message, this.cause);
}
