/// This is thrown when the plugin reports a TFLite related error.
class TFLiteException implements Exception {
  /// Creates a new TFLite exception with the given error code and description.
  TFLiteException(this.code, this.description);

  /// Error code.
  String code;

  /// Textual description of the error.
  String? description;

  @override
  String toString() => 'TFLiteException($code, $description)';
}
