class Parameter {
  String _name;
  String _value;

  Parameter(this._name, this._value);

  String get name => _name;

  String get value => _value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Parameter &&
              runtimeType == other.runtimeType &&
              _name == other._name &&
              _value == other._value;

  @override
  int get hashCode =>
      _name.hashCode ^
      _value.hashCode;

  static const List<String> VALUE_ESCAPE_CHARS = [";", ":", ","];

  @override
  String toString() {
    return 'Parameter{_name: $_name, _value: $_value}';
  }

  /**
   * parameter values can be escaped by surrounding the value in double-quotes. Parameter values must be escaped if they contain any of the following characters:
      ; - semicolon
      : - colon
      , - comma

      Property parameter values MUST NOT contain the DQUOTE character. The DQUOTE character is used as a delimiter for parameter values that contain restricted characters or URI text.
   */
  static Parameter fromICalendarString(String parameterString) {
    var colonIndex = parameterString.indexOf("=");
    String name = parameterString.substring(0, colonIndex);
    String value = parameterString.substring(colonIndex + 1);
    return new Parameter(name, value);
  }

  String toICalendarString() {
    if (VALUE_ESCAPE_CHARS.any((ec) => value.contains(ec))) {
      return '$_name="$_value"';
    }
    return '$_name=$_value';
  }
}

class Value extends Parameter {
  Value(String value) : super("VALUE", value) {}

}